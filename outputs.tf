##The following attributes are exported:
output "socket_site_id" { value = cato_socket_site.azure-site.id }
output "socket_site_serial" { value = data.cato_accountSnapshotSite.azure-site.info.sockets[0].serial }
