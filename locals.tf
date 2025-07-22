locals {
  lan_first_ip = cidrhost(var.native_network_range, 1)
}