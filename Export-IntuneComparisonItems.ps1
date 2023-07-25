Connect-MgGraph -TenantId <TenantID> -Scopes find

# How I found cmdlet
##### Find-MgGraphCommand -uri https://graph.microsoft.com/beta/deviceAppManagement/targetedManagedAppConfigurations
# I got URI from Developer console in Edge > Network > Fetch/XHR > mobileAppConfigurations

# Permissions needed
##### DeviceManagementApps.ReadWrite.AllTest-Path -Path $PROFILE.AllUsersAllHosts or DeviceManagementApps.Read.All
# How I got permissions 
#####ge

Get-MgDeviceAppMgtTargetedManagedAppConfiguration | select -Property DisplayName,Apps, Assignments, CreatedDateTime, DeployedAppCount, DeploymentSummary, Description, id, IsAssigned,LastModifiedDateTimedis | ft



### Get Roles Cmdlet 
### app permission needed 
Get-MgDeviceManagementRoleDefinition | select -Property DisplayName, Id, IsBuiltIn, RolePermissions, RoleAssignments | ft


##### Saving functions
### PowerShell can load functions
<#
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3

This will test the file existence and create it if it doesn't exist

if(!(test-path -path $PROFILE.CurrentUserAllHosts)) {            
new-item -itemtype File -path $PROFILE.CurrentUserAllHosts -force } 

#>