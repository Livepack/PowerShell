# Microsoft Graph User Data Export Scripts

This repository contains PowerShell scripts for exporting Microsoft Graph user data and uploading it to different storage solutions.

## Available Scripts

### 1. Azure Blob Storage Upload

**File:** `Export CSV into Blob Storage.ps1`

#### Description
This script exports Microsoft Graph user data to a CSV file and uploads it to Azure Blob Storage using managed identity or connected Azure account authentication.

#### Features
- Retrieves user data (ID, DisplayName, UserPrincipalName, Mail) using Microsoft Graph API
- Exports data to a CSV file
- Automatically creates Azure Storage container if it doesn't exist
- Uploads the CSV file to Azure Blob Storage
- Uses Azure managed identity or connected account for authentication

#### Prerequisites
- PowerShell 5.1 or higher
- Microsoft Graph PowerShell SDK (`Microsoft.Graph` module)
- Az PowerShell modules (`Az.Storage`)
- Appropriate Azure permissions:
  - Microsoft Graph API permissions to read user data
  - Storage Blob Data Contributor role on the target storage account

### 2. SharePoint Online Upload

**File:** `Export CSV into SharePoint Site Collection.ps1`

#### Description
This script exports Microsoft Graph user data to a CSV file and uploads it to a SharePoint Online document library using managed identity authentication.

#### Features
- Retrieves user data (ID, DisplayName, UserPrincipalName, Mail) using Microsoft Graph API
- Exports data to a CSV file
- Uploads the CSV file to a SharePoint Online document library
- Uses Azure managed identity for authentication
- Includes proper error handling and cleanup

#### Prerequisites
- PowerShell 5.1 or higher
- Microsoft Graph PowerShell SDK (`Microsoft.Graph` module)
- PnP PowerShell module (`PnP.PowerShell`)
- Az PowerShell module (`Az.Accounts`)
- Appropriate permissions:
  - Microsoft Graph API permissions to read user data
  - Site Owner or Site Member permissions on the target SharePoint site

## Security & Data Handling Notes

- Both scripts use secure authentication methods (managed identity)
- Data exported is standard Microsoft 365 user directory information
- No timestamps or personally identifiable information in output filenames
- All connections are properly closed after script execution
- Temporary files are stored in the system TEMP directory
- Scripts do not store credentials or secrets

## Usage in Azure Automation

These scripts are designed to run in Azure Automation with a system-assigned managed identity. To set up:

1. Create an Azure Automation account
2. Create a runbook with the desired script
3. Configure system-assigned managed identity for the Automation account
4. Assign appropriate permissions to the managed identity:
   - Microsoft Graph User.Read.All API permission
   - Storage Blob Data Contributor role (for blob storage script)
   - SharePoint site permissions (for SharePoint script)
5. Schedule the runbook as needed

## Troubleshooting

Common issues:
- Insufficient permissions for the managed identity
- Incorrect SharePoint site URL or document library name
- Missing PowerShell modules in the Automation account
- Network restrictions preventing access to Microsoft Graph or storage endpoints

For detailed logs, enable verbose output by adding the `-Verbose` parameter to the Connect cmdlets.