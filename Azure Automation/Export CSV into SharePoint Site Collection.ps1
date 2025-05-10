# ============================
# Azure & Microsoft Graph Authentication
# ============================
# Authenticate to Azure using Managed Identity
Write-Host "Authenticating to Azure..."
Connect-AzAccount -Identity

# Connect to Microsoft Graph API using Managed Identity
Write-Host "Connecting to Microsoft Graph..."
Connect-MgGraph -Identity -NoWelcome

# ============================
# Retrieve User Data from Graph
# ============================
Write-Host "Retrieving user data from Microsoft Graph..."
$users = Get-MgUser -All -Property Id, DisplayName, UserPrincipalName, Mail
if ($users.Count -eq 0) {
    Write-Host "No users found in Microsoft Graph."
    exit
}

# Export user data to a CSV file
$outputFileName = "UserData_Export.csv"  # Anonymized filename without timestamp
$csvPath = Join-Path $env:TEMP $outputFileName
Write-Host "Exporting user data to CSV file: $csvPath..."
$users | Select-Object Id, DisplayName, UserPrincipalName, Mail | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Host "User data successfully exported."

# ============================
# SharePoint Online Upload
# ============================
# SharePoint details
$siteUrl = "https://contoso.sharepoint.com/sites/DataExports/"  # Anonymized URL
$documentLibrary = "Shared Documents"

# Authenticate to SharePoint using Managed Identity
Write-Host "Connecting to SharePoint Online using Managed Identity..."
try {
    Connect-PnPOnline -Url $siteUrl -ManagedIdentity
    Write-Host "Successfully connected to SharePoint: $siteUrl"
} catch {
    Write-Host "ERROR: Failed to connect to SharePoint Online. $_"
    exit 1
}

# Upload file to SharePoint Document Library
Write-Host "Uploading CSV file to SharePoint Online..."
try {
    Add-PnPFile -Path $csvPath -Folder $documentLibrary #-OverwriteIfAlreadyExists
    Write-Host "File successfully uploaded to SharePoint: $siteUrl/$documentLibrary/$outputFileName"
} catch {
    Write-Host "ERROR: Failed to upload file to SharePoint. $_"
    exit 1
}

# ============================
# Cleanup & Disconnect
# ============================
# Disconnect from Microsoft Graph
if (Get-MgContext) {
    Write-Host "Disconnecting from Microsoft Graph..."
    Disconnect-MgGraph
}

# Disconnect from SharePoint
Write-Host "Disconnecting from SharePoint..."
Disconnect-PnPOnline
Write-Host "Script execution completed successfully."