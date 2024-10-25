## vSocket Module Resources
provider "azurerm" {
	features {}
}

provider "cato" {
    baseurl = "https://api.catonetworks.com/api/v1/graphql2"
    token = var.token
    account_id = var.account_id
}

resource "cato_socket_site" "azure-site" {
    connection_type  = "SOCKET_AZ1500"
    description = var.site_description
    name = var.project_name
    native_range = {
      native_network_range = var.vnet_prefix
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
  name                         = "${var.site_name}-vSocket"
  network_interface_ids        = [var.mgmt-nic-id, var.wan-nic-id, var.lan-nic-id]
  primary_network_interface_id = var.mgmt-nic-id
  resource_group_name          = var.resource-group-name
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
    name              = "${var.site_name}-vSocket-disk1"
    managed_disk_id   = azurerm_managed_disk.vSocket-disk1.id
    os_type = "Linux"
  }
  
  depends_on = [
    azurerm_managed_disk.vSocket-disk1
  ]
}

resource "azurerm_managed_disk" "vSocket-disk1" {
  name                 = "${var.site_name}-vSocket-disk1"
  location             = var.location
  resource_group_name  = var.resource-group-name
  storage_account_type = "Standard_LRS"
  create_option        = "FromImage"
  disk_size_gb         = var.disk_size_gb
  os_type              = "Linux"
  image_reference_id   = var.image_reference_id
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
  name                       = "vsocket-custom-script"
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  virtual_machine_id         = azurerm_virtual_machine.vsocket.id
  settings = <<SETTINGS
 {
  "commandToExecute": "${"echo '${data.cato-oss_accountSnapshotSite.azure-site.info.sockets[0].serial}' > /cato/serial.txt"};${join(";", var.commands)}"
 }
SETTINGS
  depends_on = [
    azurerm_virtual_machine.vsocket
  ]
}