
import-Module Microsoft.Graph.DeviceManagement.Administration

connect-mggraph -TenantId <TenantID> -Scopes DeviceManagementConfiguration.ReadWrite.All 
Select-MgProfile -name beta
$GPOPolicies = Get-MgDeviceManagementGroupPolicyMigrationReport
foreach ($GPO in $GPOPolicies) {
    Remove-MgDeviceManagementGroupPolicyMigrationReport -GroupPolicyMigrationReportId $gpo.Id
}