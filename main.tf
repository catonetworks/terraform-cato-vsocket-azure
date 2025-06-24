resource "cato_socket_site" "azure-site" {
  connection_type = "SOCKET_AZ1500"
  description     = var.site_description
  name            = var.site_name
  native_range = {
    native_network_range = var.native_network_range
    local_ip             = var.lan_ip
  }
  site_location = local.cur_site_location
  site_type     = var.site_type
}

data "cato_accountSnapshotSite" "azure-site" {
  id = cato_socket_site.azure-site.id
}

## Create random strings for auth, as a socket does not allow auth but the instance requires it
resource "random_string" "vsocket-random-username" {
  length  = 16
  special = false
}

resource "random_string" "vsocket-random-password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}

data "azurerm_network_interface" "mgmt" {
  name                = var.mgmt_nic_name
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "wan" {
  name                = var.wan_nic_name
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "lan" {
  name                = var.lan_nic_name
  resource_group_name = var.resource_group_name
}

## Create Vsocket Virtual Machine
resource "azurerm_linux_virtual_machine" "vsocket" {
  location            = var.location
  name                = var.vsocket-vm-name
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  network_interface_ids = [
    data.azurerm_network_interface.mgmt.id,
    data.azurerm_network_interface.wan.id,
    data.azurerm_network_interface.lan.id
  ]
  disable_password_authentication = false
  provision_vm_agent              = true
  allow_extension_operations      = true
  admin_username                  = random_string.vsocket-random-username.result
  admin_password                  = "${random_string.vsocket-random-password.result}@"

  # Boot diagnostics
  boot_diagnostics {
    storage_account_uri = "" # Empty string enables boot diagnostics
  }

  # OS disk configuration from image
  os_disk {
    name                 = var.vsocket-disk-name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 8
  }

  plan {
    name      = "public-cato-socket"
    publisher = "catonetworks"
    product   = "cato_socket"
  }

  source_image_reference {
    publisher = "catonetworks"
    offer     = "cato_socket"
    sku       = "public-cato-socket"
    version   = "23.0.19605"
  }

  depends_on = [
    data.cato_accountSnapshotSite.azure-site-2
  ]
  tags = var.tags
}

# Second lookup for nics_config
data "azurerm_network_interface" "mgmt-2" {
  depends_on          = [azurerm_linux_virtual_machine.vsocket]
  name                = var.mgmt_nic_name
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "wan-2" {
  depends_on          = [azurerm_linux_virtual_machine.vsocket]
  name                = var.wan_nic_name
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "lan-2" {
  depends_on          = [azurerm_linux_virtual_machine.vsocket]
  name                = var.lan_nic_name
  resource_group_name = var.resource_group_name
}

# Allow vSocket to be disconnected to delete site
resource "null_resource" "sleep_before_delete" {
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 10"
  }
}

data "cato_accountSnapshotSite" "azure-site-2" {
  id         = cato_socket_site.azure-site.id
  depends_on = [null_resource.sleep_before_delete]
}

variable "commands" {
  type = list(string)
  default = [
    "nohup /cato/socket/run_socket_daemon.sh &"
  ]
}

resource "azurerm_virtual_machine_extension" "vsocket-custom-script" {
  auto_upgrade_minor_version = true
  name                       = var.vsocket-custom-script-name
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  virtual_machine_id         = azurerm_linux_virtual_machine.vsocket.id
  lifecycle {
    ignore_changes = all
  }

  settings = <<SETTINGS
  {
  "commandToExecute": "echo '{\"wan_ip\" : \"${data.azurerm_network_interface.wan-2.private_ip_address}\", \"wan_name\" : \"${data.azurerm_network_interface.wan-2.name}\", \"wan_nic_mac\" : \"${lower(replace(data.azurerm_network_interface.wan-2.mac_address, "-", ":"))}\", \"lan_ip\" : \"${data.azurerm_network_interface.lan-2.private_ip_address}\", \"lan_name\" : \"${data.azurerm_network_interface.lan-2.name}\", \"lan_nic_mac\" : \"${lower(replace(data.azurerm_network_interface.lan-2.mac_address, "-", ":"))}\"}' > /cato/nics_config.json; echo '${data.cato_accountSnapshotSite.azure-site.info.sockets[0].serial}' > /cato/serial.txt;${join(";", var.commands)}"
  }
  SETTINGS
  depends_on = [
    data.azurerm_network_interface.lan-2,
    data.azurerm_network_interface.wan-2,
    data.azurerm_network_interface.mgmt-2
  ]
}

resource "cato_license" "license" {
  depends_on = [azurerm_virtual_machine_extension.vsocket-custom-script]
  count      = var.license_id == null ? 0 : 1
  site_id    = cato_socket_site.azure-site.id
  license_id = var.license_id
  bw         = var.license_bw == null ? null : var.license_bw
}
