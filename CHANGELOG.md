# Changelog

## 0.0.1 (2024-10-26)

### Features
- Initial commit with single socket instance with 3 NICs
- Added default vales for required parameters

## 0.0.8 (2024-11-15)

### Features
- Added lifecycle.ignore_changes=all to disk and extension to be able to apply and not rebuild socket

## 0.0.9 (2025-05-07)

### Features
- Removed nested providers and variables, updated resource_group_name naming convention to be consistent 

## 0.0.13 (2025-05-07)

### Features
- Added optional license resource and inputs used for commercial site deployments
- Added tfdocs to readme

## 0.0.14 (2025-05-15)

### Features
- Add all outputs and fixed input params to remove default null values for required fields

## 0.1.0 (2025-05-29)

### Features
- Updated module to use the new azurerm_linux_virtual_machine resource, as the azurerm_virtual_machine resource is no longer maintained by Azure/Terraform. 

## 0.1.1 (2025-06-03)

### Features
- Updated module to include tags 
- Bump Version of Azure RM to 4.31 from 4.1
- Changed Default Site Type to CLOUD_DC
- Added gitignore

## 0.1.2 (2025-06-24)

### Features
- Updated module to include site_location dynamic resolution from azure region.
