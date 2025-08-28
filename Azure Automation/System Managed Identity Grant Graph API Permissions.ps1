#Step 1: Get the Microsoft Graph Service Principal and AppRole -- System MI Object ID
$managedIdentityId = "client id"

# Get the Microsoft Graph Service Principal using AppId
$graphSPN = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

# Find the AppRole with the specific permission you want to assign (e.g., Directory.Read.All)
$permission = "User.Read.All"
$appRole = $graphSPN.AppRoles | Where-Object { $_.Value -eq $permission -and $_.AllowedMemberTypes -contains "Application" }

# Output the app role details for verification
Write-Output "App Role: $($appRole.DisplayName)"

# Build the hash table for the new role assignment
$bodyParam = @{
    PrincipalId = $managedIdentityId  # The Object ID of the Managed Identity (System-assigned)
    ResourceId  = $graphSPN.Id        # The Microsoft Graph Service Principal ID
    AppRoleId   = $appRole.Id         # The AppRole (permission) ID to assign
}

# Output the hash table for verification
Write-Output "Body Parameters: $($bodyParam)"

#Than Step 2: Assign the AppRole to the Managed
# Assign the AppRole to the Managed Identity (System-assigned) for the Automation Account
$assignment = New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $managedIdentityId -BodyParameter $bodyParam

# Check if the assignment was successful by checking the returned assignment identifier
if ($assignment.Id) {
    Write-Output "Permission assigned successfully. Assignment ID: $($assignment.Id)"
} else {
    Write-Error "Failed to assign permission."
}

# Verify the AppRole assignment for the Managed Identity
Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $managedIdentityId



...
#For SharePoint Online
#Step 1: Get the Microsoft Graph Service Principal and AppRole -- System MI Object ID
$managedIdentityId = "client id"

# Get the Microsoft Graph Service Principal using AppId
$graphSPN = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0ff1-ce00-000000000000'"

# Find the AppRole with the specific permission you want to assign (e.g., Directory.Read.All)
$permission = "Sites.Selected"
$appRole = $graphSPN.AppRoles | Where-Object { $_.Value -eq $permission -and $_.AllowedMemberTypes -contains "Application" }

# Output the app role details for verification
Write-Output "App Role: $($appRole.DisplayName)"

# Build the hash table for the new role assignment
$bodyParam = @{
    PrincipalId = $managedIdentityId  # The Object ID of the Managed Identity (System-assigned)
    ResourceId  = $graphSPN.Id        # The Microsoft Graph Service Principal ID
    AppRoleId   = $appRole.Id         # The AppRole (permission) ID to assign
}

# Output the hash table for verification
Write-Output "Body Parameters: $($bodyParam)"

#Than Step 2: Assign the AppRole to the Managed
# Assign the AppRole to the Managed Identity (System-assigned) for the Automation Account
$assignment = New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $managedIdentityId -BodyParameter $bodyParam




# Check if the assignment was successful by checking the returned assignment identifier
if ($assignment.Id) {
    Write-Output "Permission assigned successfully. Assignment ID: $($assignment.Id)"
} else {
    Write-Error "Failed to assign permission."
}

# Verify the AppRole assignment for the Managed Identity
Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $managedIdentityId


#Next add to the scecipfic sharepoint site
# Grant permissions to the Azure AD application
Grant-PnPAzureADAppSitePermission -AppId "f83c218c-b9fb-47db-abe7-f5cca87d7eb6" -DisplayName "aa-testlab" -Site "https://nexttk.sharepoint.com/sites/test-ps" -Permissions "Write"

#Remember you need to be the Site Admin, check here: https://github.com/pnp/powershell/issues/3962
Grant-PnPAzureADAppSitePermission -AppId "00fa4527-d6cc-40b0-b920-bd85adcbc537" -DisplayName "AT-FT CRM Orbis OCDI DEV" -Site "https://thyssenkrupp.sharepoint.com/sites/at-ft-dev-crm" -Permissions Read, Write

#Get, check the permission 
Get-PnPAzureADAppSitePermission -Site "https://thyssenkrupp.sharepoint.com/sites/is-collaboration/"








































