## vSocket Module Varibables
variable token {
  description = "API key"
  type = string
}

variable "account_id" {
  description = "Account ID"
  type        = number
  default	  = null
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type = string
}

variable "site_description" {
  description = "Site description"
  type = string

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
  description = "Your Cato Site Name Here"
  type = string
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

variable "native_network_range" {
  description = <<EOT
  	Choose a unique range for your new LAN Subnet within your vnet that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  type = string
}

variable "vm_size" {
  description = "(Required) Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions. https://learn.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions"
  default = "Standard_D8ls_v5"
  type = string
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
  description = "Local IP Address of socket LAN interface"
  type = string
	default = null
}

## Vsocket Params
variable "location" { 
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  type = string
  default = null

}

variable "resource-group-name" { 
  description = "(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
  type = string
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

variable "vsocket-disk-name" {
  description = "Cato vSocket Disk name"
  type = string
  default = "Cato-vsocket-Disk"
}

variable "vsocket-vm-name" {
  description = "Azure Cato vSocket name"
  type = string
  default = "Cato-vSocket"
}

variable "vsocket-custom-script-name" {
  description = "Cato vSocket custom script name"
  type = string
  default = "vsocket-custom-script"
}

variable "image_reference_id" {
  description = "Path to image used to deploy specific version of the virutal socket"
	type = string
	default = "/Subscriptions/38b5ec1d-b3b6-4f50-a34e-f04a67121955/Providers/Microsoft.Compute/Locations/eastus/Publishers/catonetworks/ArtifactTypes/VMImage/Offers/cato_socket/Skus/public-cato-socket/Versions/19.0.17805"
}