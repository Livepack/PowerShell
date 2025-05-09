# Retrieve user data using Get-MgBetaUser
Write-Host "Retrieving user data..."
$users = Get-MgBetaUser -All -Property Id, DisplayName, UserPrincipalName, Mail

# Export user data to a CSV file
$outputFileName = "$((Get-Date).ToString('yyyy-MM-dd_HH-mm-ss'))_UserData.csv"
$csvPath = Join-Path $env:TEMP $outputFileName
$users | Select-Object Id, DisplayName, UserPrincipalName, Mail | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "User data exported to $csvPath"

# Storage account details
$storageAccountName = "staatestlab"  # Replace with your storage account name
$containerName = "blogtest"  # Use the correct container name
$blobName = $outputFileName  # Use the same file name for the blob

# Create a context for the storage account using Managed Identity
#$context = New-AzStorageContext -StorageAccountName $storageAccountName -UseManagedIdentity -ErrorAction Stop
$context = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount -ErrorAction Stop


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