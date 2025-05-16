##The following attributes are exported:
output "socket_site_id" {
  description = "The ID of the Cato socket site"
  value       = cato_socket_site.azure-site.id
}

output "socket_site_serial" {
  description = "The serial number of the first socket in the Cato account snapshot site"
  value       = data.cato_accountSnapshotSite.azure-site.info.sockets[0].serial
}

output "cato_license" {
  description = "Cato site license info"
  value       = var.license_id == null ? null : cato_license.license
}

output "socket_site_name" {
  description = "The name of the Cato socket site"
  value       = cato_socket_site.azure-site.name
}

output "socket_site_location" {
  description = "The location of the Cato socket site"
  value       = cato_socket_site.azure-site.site_location
}

output "vsocket_vm_id" {
  description = "The ID of the vSocket virtual machine"
  value       = azurerm_virtual_machine.vsocket.id
}

output "vsocket_vm_name" {
  description = "The name of the vSocket virtual machine"
  value       = azurerm_virtual_machine.vsocket.name
}

output "vsocket_disk_id" {
  description = "The ID of the managed disk attached to the vSocket virtual machine"
  value       = azurerm_managed_disk.vSocket-disk1.id
}

output "vsocket_custom_script_name" {
  description = "The name of the custom script extension for the vSocket virtual machine"
  value       = azurerm_virtual_machine_extension.vsocket-custom-script.name
}