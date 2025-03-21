# CATO VSOCKET Azure Terraform module 

Terraform module which creates an Azure Socket Site in the Cato Management Application (CMA), and deploys a virtual socket instance in Azure.

## Usage

```hcl
module "vsocket-azure" {
  source = "catonetworks/vsocket-azure/cato"
  token = "xxxxxxx"
  account_id = "xxxxxxx"
  native_network_range = "10.0.0.0/16"
  lan_local_ip         = "10.0.3.5"
  location             = "East US"
  resource-group-name  = "Your_Resource_Group_Name_Here"
  mgmt-nic-id          = "/subscriptions/abcde-1234-abcd-1234-abcde12345/resourceGroups/Azure_Socket_Site/providers/Microsoft.Network/networkInterfaces/Azure_Socket_Site-vs0nicMgmt"
  wan-nic-id           = "/subscriptions/abcde-1234-abcd-1234-abcde12345/resourceGroups/Azure_Socket_Site/providers/Microsoft.Network/networkInterfaces/Azure_Socket_Site-vs0nicWan"
  lan-nic-id           = "/subscriptions/abcde-1234-abcd-1234-abcde12345/resourceGroups/Azure_Socket_Site/providers/Microsoft.Network/networkInterfaces/Azure_Socket_Site-vs0nicLan"
  site_name            = "Azure Site US East"
  site_description     = "Azure Site US East"
  site_type            = "CLOUD_DC"
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

