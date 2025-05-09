# Azure User Data Export to Blob Storage

## Description
This PowerShell script exports Microsoft Graph user data to a CSV file and uploads it to Azure Blob Storage. It uses Microsoft Graph API to retrieve user information and Azure Storage SDK to upload the data.

## Features
- Retrieves user data (ID, DisplayName, UserPrincipalName, Mail) using Microsoft Graph API
- Exports data to a time-stamped CSV file
- Automatically creates Azure Storage container if it doesn't exist
- Uploads the CSV file to Azure Blob Storage
- Uses Azure managed identity or connected account for authentication

## Prerequisites
- PowerShell 5.1 or higher
- Microsoft Graph PowerShell SDK (`Microsoft.Graph.Beta.Users` module)
- Az PowerShell modules (`Az.Storage`)
- Appropriate Azure permissions:
  - Microsoft Graph API permissions to read user data
  - Storage Blob Data Contributor role on the target storage account

## Usage
1. Ensure you are logged in with appropriate permissions:
   ```powershell
   Connect-MgGraph -Scopes "User.Read.All"
   Connect-AzAccount # If not using managed identity
   ```

2. Customize the storage account and container variables:
   ```powershell
   $storageAccountName = "yourstorageaccount"
   $containerName = "yourcontainer"
   ```

3. Run the script:
   ```powershell
   .\Export-UserDataToBlob.ps1
   ```

## Authentication
The script supports two authentication methods for Azure Storage:
- Managed Identity (uncomment the line with `-UseManagedIdentity`)
- Connected Azure Account (default)

## Output
- CSV file is temporarily stored in the system's TEMP directory
- CSV file is uploaded to the specified Azure Storage container
- Console output indicates progress and final storage location

## Notes
- For Azure Automation runbooks, managed identity is the recommended authentication method
- Timestamp in the filename ensures unique blob names for each execution
