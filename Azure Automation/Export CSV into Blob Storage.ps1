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

# Export user data to a CSV file
$outputFileName = "UserData_Export.csv"  # Anonymized filename without timestamp
$csvPath = Join-Path $env:TEMP $outputFileName
$users | Select-Object Id, DisplayName, UserPrincipalName, Mail | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "User data exported to $csvPath"

# ============================
# Azure Blob Storage Upload
# ============================
# Storage account details
$storageAccountName = "storageaccount"  # Anonymized storage account name
$containerName = "userdata"  # Anonymized container name
$blobName = $outputFileName

# Create a context for the storage account using Managed Identity
$context = New-AzStorageContext -StorageAccountName $storageAccountName -UseManagedIdentity -ErrorAction Stop

# Check if the container exists, and create it if it doesn't
if (-not (Get-AzStorageContainer -Name $containerName -Context $context -ErrorAction SilentlyContinue)) {
    Write-Host "Creating container: $containerName..."
    New-AzStorageContainer -Name $containerName -Context $context -Permission Container
    Start-Sleep -Seconds 5  # Wait to ensure Azure propagates the change
}

# Upload the file to the blob
Write-Host "Uploading $csvPath to Azure Storage..."
Set-AzStorageBlobContent -File $csvPath -Container $containerName -Blob $blobName -Context $context -Force
Write-Host "File uploaded successfully to Azure Storage Account: $storageAccountName, Container: $containerName, Blob: $blobName"

# ============================
# Cleanup & Disconnect
# ============================
# Disconnect from Microsoft Graph
if (Get-MgContext) {
    Write-Host "Disconnecting from Microsoft Graph..."
    Disconnect-MgGraph
}

Write-Host "Script execution completed successfully."