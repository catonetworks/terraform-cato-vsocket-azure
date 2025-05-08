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

