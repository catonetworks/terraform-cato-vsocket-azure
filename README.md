# CATO VSOCKET Azure Terraform module 

Terraform module which creates an Azure Socket Site in the Cato Management Application (CMA), and deploys a virtual socket instance in Azure.

## NOTE
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).


## Usage

```hcl
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.cato_token
  account_id = var.account_id
}

module "vsocket-azure" {
  source                     = "catonetworks/vsocket-azure/cato"
  native_network_range       = "10.0.0.0/16"
  local_ip                   = "10.0.3.5"
  location                   = "East US"
  resource_group_name        = "Your_Resource_Group_Name_Here"
  mgmt-nic-id                = "/subscriptions/abcde-1234-abcd-1234-abcde12345/resourceGroups/Azure_Socket_Site/providers/Microsoft.Network/networkInterfaces/Azure_Socket_Site-vs0nicMgmt"
  wan-nic-id                 = "/subscriptions/abcde-1234-abcd-1234-abcde12345/resourceGroups/Azure_Socket_Site/providers/Microsoft.Network/networkInterfaces/Azure_Socket_Site-vs0nicWan"
  lan-nic-id                 = "/subscriptions/abcde-1234-abcd-1234-abcde12345/resourceGroups/Azure_Socket_Site/providers/Microsoft.Network/networkInterfaces/Azure_Socket_Site-vs0nicLan"
  site_name                  = "Azure Site US East"
  site_description           = "Azure Site US East"
  site_type                  = "CLOUD_DC"
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
  }
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-azure/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-azure/tree/master/LICENSE) for full details.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.1.0 |
| <a name="provider_cato"></a> [cato](#provider\_cato) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vsocket](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_virtual_machine_extension.vsocket-custom-script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [cato_license.license](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/license) | resource |
| [cato_socket_site.azure-site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/socket_site) | resource |
| [null_resource.sleep_before_delete](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.vsocket-random-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.vsocket-random-username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_network_interface.lan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_network_interface.lan-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_network_interface.mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_network_interface.mgmt-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_network_interface.wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_network_interface.wan-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [cato_accountSnapshotSite.azure-site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/accountSnapshotSite) | data source |
| [cato_accountSnapshotSite.azure-site-2](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/accountSnapshotSite) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_commands"></a> [commands](#input\_commands) | n/a | `list(string)` | <pre>[<br/>  "nohup /cato/socket/run_socket_daemon.sh &"<br/>]</pre> | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Disk size in GB | `number` | `8` | no |
| <a name="input_image_reference_id"></a> [image\_reference\_id](#input\_image\_reference\_id) | Path to image used to deploy specific version of the virutal socket | `string` | `"/Subscriptions/38b5ec1d-b3b6-4f50-a34e-f04a67121955/Providers/Microsoft.Compute/Locations/eastus/Publishers/catonetworks/ArtifactTypes/VMImage/Offers/cato_socket/Skus/public-cato-socket/Versions/23.0.19605"` | no |
| <a name="input_lan_ip"></a> [lan\_ip](#input\_lan\_ip) | Local IP Address of socket LAN interface | `string` | `null` | no |
| <a name="input_lan_nic_name"></a> [lan\_nic\_name](#input\_lan\_nic\_name) | The name of the primary LAN network interface. | `string` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created. | `string` | n/a | yes |
| <a name="input_mgmt_nic_name"></a> [mgmt\_nic\_name](#input\_mgmt\_nic\_name) | The name of the primary management network interface. | `string` | n/a | yes |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Choose a unique range for your new LAN Subnet within your vnet that does not conflict with the rest of your Wide Area Network.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created. | `string` | n/a | yes |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Site description | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | n/a | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | <pre>{<br/>  "city": "New York",<br/>  "country_code": "US",<br/>  "state_code": "US-NY",<br/>  "timezone": "America/New_York"<br/>}</pre> | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Your Cato Site Name Here | `string` | `null` | no |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"DATACENTER"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Required) Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions. https://learn.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions | `string` | `"Standard_D8ls_v5"` | no |
| <a name="input_vsocket-custom-script-name"></a> [vsocket-custom-script-name](#input\_vsocket-custom-script-name) | Cato vSocket custom script name | `string` | `"vsocket-custom-script"` | no |
| <a name="input_vsocket-disk-name"></a> [vsocket-disk-name](#input\_vsocket-disk-name) | Cato vSocket Disk name | `string` | `"Cato-vsocket-Disk"` | no |
| <a name="input_vsocket-vm-name"></a> [vsocket-vm-name](#input\_vsocket-vm-name) | Azure Cato vSocket name | `string` | `"Cato-vSocket"` | no |
| <a name="input_wan_nic_name"></a> [wan\_nic\_name](#input\_wan\_nic\_name) | The name of the primary WAN network interface. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_license"></a> [cato\_license](#output\_cato\_license) | Cato site license info |
| <a name="output_socket_site_id"></a> [socket\_site\_id](#output\_socket\_site\_id) | The ID of the Cato socket site |
| <a name="output_socket_site_location"></a> [socket\_site\_location](#output\_socket\_site\_location) | The location of the Cato socket site |
| <a name="output_socket_site_name"></a> [socket\_site\_name](#output\_socket\_site\_name) | The name of the Cato socket site |
| <a name="output_socket_site_serial"></a> [socket\_site\_serial](#output\_socket\_site\_serial) | The serial number of the first socket in the Cato account snapshot site |
| <a name="output_vsocket_custom_script_name"></a> [vsocket\_custom\_script\_name](#output\_vsocket\_custom\_script\_name) | The name of the custom script extension for the vSocket virtual machine |
| <a name="output_vsocket_vm_id"></a> [vsocket\_vm\_id](#output\_vsocket\_vm\_id) | The ID of the vSocket virtual machine |
| <a name="output_vsocket_vm_name"></a> [vsocket\_vm\_name](#output\_vsocket\_vm\_name) | The name of the vSocket virtual machine |
<!-- END_TF_DOCS -->