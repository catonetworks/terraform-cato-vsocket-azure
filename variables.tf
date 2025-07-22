variable "site_description" {
  description = "Site description"
  type        = string
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  default     = "CLOUD_DC"
  validation {
    condition     = contains(["DATACENTER", "BRANCH", "CLOUD_DC", "HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
}

variable "site_name" {
  description = "Your Cato Site Name Here"
  type        = string
  default     = null
}

variable "site_location" {
  description = "Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the Azure region dynamicaly."
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
  default = {
    city         = null
    country_code = null
    state_code   = null ## Optional - for countries with states
    timezone     = null
  }
}

variable "native_network_range" {
  description = <<EOT
  	Choose a unique range for your new LAN Subnet within your vnet that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  type        = string
}

variable "vm_size" {
  description = "(Required) Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions. https://learn.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions"
  default     = "Standard_D8ls_v5"
  type        = string
}

variable "disk_size_gb" {
  type        = number
  description = "Disk size in GB"
  default     = 8
  validation {
    condition     = var.disk_size_gb > 0
    error_message = "Disk size must be greater than 0"
  }
}

variable "lan_ip" {
  description = "Local IP Address of socket LAN interface"
  type        = string
  default     = null
}

## Vsocket Params
variable "location" {
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
  type        = string
}

variable "mgmt_nic_name" {
  description = "The name of the primary management network interface."
  type        = string
}

variable "wan_nic_name" {
  description = "The name of the primary WAN network interface."
  type        = string
}

variable "lan_nic_name" {
  description = "The name of the primary LAN network interface."
  type        = string
}

variable "vsocket-disk-name" {
  description = "Cato vSocket Disk name"
  type        = string
  default     = "Cato-vsocket-Disk"
}

variable "vsocket-vm-name" {
  description = "Azure Cato vSocket name"
  type        = string
  default     = "Cato-vSocket"
}

variable "vsocket-custom-script-name" {
  description = "Cato vSocket custom script name"
  type        = string
  default     = "vsocket-custom-script"
}

variable "image_reference_id" {
  description = "Path to image used to deploy specific version of the virutal socket"
  type        = string
  default     = "/Subscriptions/38b5ec1d-b3b6-4f50-a34e-f04a67121955/Providers/Microsoft.Compute/Locations/eastus/Publishers/catonetworks/ArtifactTypes/VMImage/Offers/cato_socket/Skus/public-cato-socket/Versions/23.0.19605"
}

variable "license_id" {
  description = "The license ID for the Cato vSocket of license type CATO_SITE, CATO_SSE_SITE, CATO_PB, CATO_PB_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts."
  type        = string
  default     = null
}

variable "license_bw" {
  description = "The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10."
  type        = string
  default     = null
}

variable "tags" {
  description = "A Map of Keys and Values to Describe the infrastructure"
  type        = map(any)
  default     = null
}


variable "enable_static_range_translation" {
  description = "Enables the ability to use translated ranges"
  type        = string
  default     = false
}

variable "routed_networks" {
  description = <<EOF
  A map of routed networks to be accessed behind the vSocket site.
  - The key is the logical name for the network.
  - The value is an object containing:
    - "subnet" (string, required): The actual CIDR range of the network.
    - "translated_subnet" (string, optional): The NATed CIDR range if translation is used.
  Example: 
  routed_networks = {
    "Peered-VNET-1" = {
      subnet = "10.100.1.0/24"
    }
    "On-Prem-Network-NAT" = {
      subnet            = "192.168.51.0/24"
      translated_subnet = "10.200.1.0/24"
    }
  }
  EOF
  type = map(object({
    subnet            = string
    translated_subnet = optional(string)
  }))
  default = {}
}

# This variable remains the same as it applies to all networks.
variable "routed_ranges_gateway" {
  description = "Routed ranges gateway. If null, the first IP of the LAN subnet will be used."
  type        = string
  default     = null
}

## Socket interface settings
variable "upstream_bandwidth" {
  description = "Sockets upstream interface WAN Bandwidth in Mbps"
  type        = number
  default     = null
}

variable "downstream_bandwidth" {
  description = "Sockets downstream interface WAN Bandwidth in Mbps"
  type        = number
  default     = null
}