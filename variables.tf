## vSocket Module Varibables
variable token {}

variable "account_id" {
  description = "Account ID"
  type        = number
  default	  = null
}

variable "site_description" {
  type = string
  description = "Site description"
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  default	 = "DATACENTER"
  validation {
    condition = contains(["DATACENTER","BRANCH","CLOUD_DC","HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
}

variable "site_name" {
  type = string
  description = "Your Cato Site Name Here"
  default = null
}

variable "site_location" {
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
  default = {
  city         = "New York"
  country_code = "US"
  state_code   = "US-NY" ## Optional - for coutnries with states
  timezone     = "America/New_York"
  }
}

variable "vnet_prefix" {
  type = string
  description = <<EOT
  	Choose a unique range for your new VPC that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
}

variable "vm_size" {
  type = string
  description = "(Required) Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions. https://learn.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions"
  default = "Standard_D8ls_v5"
}

variable "disk_size_gb" {
  type = number
  description = "Disk size in GB"
  default = 8
  validation {
    condition = var.disk_size_gb > 0
    error_message = "Disk size must be greater than 0"  
  }
}

variable "lan_ip" {
	type = string
  description = "Local IP Address of socket LAN interface"
	default = null
}

## Vsocket Params
variable "location" { 
  type = string
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  default = null
}

variable "resource-group-name" { 
  type = string
  description = "(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
  default = null
}

variable "mgmt-nic-id" {
  type = string
  default = null
}

variable "wan-nic-id" {
  type = string
  default = null
}

variable "lan-nic-id" {
  type = string
  default = null
}

variable "image_reference_id" {
	type = string
  description = "Path to image used to deploy specific version of the virutal socket"
	default = "/Subscriptions/38b5ec1d-b3b6-4f50-a34e-f04a67121955/Providers/Microsoft.Compute/Locations/eastus/Publishers/catonetworks/ArtifactTypes/VMImage/Offers/cato_socket/Skus/public-cato-socket/Versions/19.0.17805"
}
