resource "cato_socket_site" "azure-site" {
    connection_type  = "SOCKET_AZ1500"
    description = var.site_description
    name = var.site_name
    native_range = {
      native_network_range = var.native_network_range
      local_ip = var.lan_ip
    }
    site_location = var.site_location
    site_type = var.site_type
}

data "cato_accountSnapshotSite" "azure-site" {
	id = cato_socket_site.azure-site.id
}

## Create Vsocket Virtual Machine
resource "azurerm_virtual_machine" "vsocket" {
  location                     = var.location
  name                         = var.vsocket-vm-name
  network_interface_ids        = [var.mgmt-nic-id, var.wan-nic-id, var.lan-nic-id]
  primary_network_interface_id = var.mgmt-nic-id
  resource_group_name          = var.resource_group_name
  vm_size                      = var.vm_size
  plan {
    name      = "public-cato-socket"
    product   = "cato_socket"
    publisher = "catonetworks"
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    create_option     = "Attach"
    name              = var.vsocket-disk-name
    managed_disk_id   = azurerm_managed_disk.vSocket-disk1.id
    os_type = "Linux"
  }
  
  depends_on = [
    azurerm_managed_disk.vSocket-disk1,
    data.cato_accountSnapshotSite.azure-site-2
  ]
}

# Allow vSocket to be disconnected to delete site
resource "null_resource" "sleep_before_delete" {
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 10"
  }
}

data "cato_accountSnapshotSite" "azure-site-2" {
	id = cato_socket_site.azure-site.id
  depends_on = [ null_resource.sleep_before_delete ]
}

resource "azurerm_managed_disk" "vSocket-disk1" {
  name                 = var.vsocket-disk-name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "FromImage"
  disk_size_gb         = var.disk_size_gb
  os_type              = "Linux"
  image_reference_id   = var.image_reference_id
  lifecycle {
    ignore_changes = all
  }
}

variable "commands" {
  type    = list(string)
  default = [
    "rm /cato/deviceid.txt",
    "rm /cato/socket/configuration/socket_registration.json",
    "nohup /cato/socket/run_socket_daemon.sh &"
   ]
}

resource "azurerm_virtual_machine_extension" "vsocket-custom-script" {
  auto_upgrade_minor_version = true
  name                       = var.vsocket-custom-script-name
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  virtual_machine_id         = azurerm_virtual_machine.vsocket.id
  lifecycle {
    ignore_changes = all
  }
  settings = <<SETTINGS
 {
  "commandToExecute": "${"echo '${data.cato_accountSnapshotSite.azure-site.info.sockets[0].serial}' > /cato/serial.txt"};${join(";", var.commands)}"
 }
SETTINGS
  depends_on = [
    azurerm_virtual_machine.vsocket
  ]
}

resource "cato_license" "license" {
  depends_on = [ azurerm_virtual_machine_extension.vsocket-custom-script ]
  count = var.license_id == null ? 0 : 1
  site_id = cato_socket_site.azure-site.id
  license_id = var.license_id
  bw = var.license_bw == null ? null : var.license_bw
}
