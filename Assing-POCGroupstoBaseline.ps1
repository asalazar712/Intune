
[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $AzureADGroup

)


$AzureADGroup = <Group ID>
$DeviceFilter = <Filter ID>
#####################################################################################
# Functions for retrieving configuration policy etc.. information via Graph API.
#####################################################################################


  
  #Update Rings show here
  Function Get-DeviceConfigurations(){
   
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceConfigurations"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

  Function Get-ConfigurationPolicies(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/configurationPolicies?`$top=1000"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }
  
  Function Get-IntunePowershellscripts(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceManagementScripts"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
    
  }


   Function Get-CompliancePolicys(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceCompliancePolicies"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
    
  }
  
  
  Function Get-Applications(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceAppManagement/mobileApps"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

<#  
  Function Get-AutopilotProfiles(){
    
    $graphApiVersion = "Beta"
    $Resource = "/deviceManagement/windowsAutopilotDeploymentProfiles"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }
#>

 


#####################################################################################
## Check for Modules
#####################################################################################

#Checking for correct modules and installing them if needed
$InstalledModules = Get-InstalledModule
$Module_Name = "MSAL.PS"
If ($InstalledModules.name -notcontains $Module_Name) {
	Write-Host "Installing module $Module_Name"
	Install-Module $Module_Name -Force
}
Else {
	Write-Host "$Module_Name Module already installed"
}		

#Importing Module
Write-Host "Importing Module $Module_Name"
Import-Module $Module_Name

#####################################################################################
## Login Part
#####################################################################################

Write-Host "Getting token for Authentication"

# Token voor Configuration Profiles, Update Policies
$authResult = Get-MsalToken -ClientId d1ddf0e4-d672-4dae-b554-9d5bdfd93547 -RedirectUri "urn:ietf:wg:oauth:2.0:oob" -Interactive
$AuthHeaders = @{
          'Content-Type'='application/json'
          'Authorization'="Bearer " + $authResult.AccessToken
          'ExpiresOn'=$authResult.ExpiresOn
         
}

#####################################################################################
#Run Part
#####################################################################################

#Assign Delivery Optimization, Wifi, Update Rings, Endpoint protection, Custom
$DeviceConfigurations = Get-DeviceConfigurations | where Displayname -like "Prod_Win*"

foreach ($DeviceConfiguration in $DeviceConfigurations){
  Write-Host "Assigning Device Configurations's $($DeviceConfiguration.displayName)"
  $policyid = $DeviceConfiguration.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$policyid')/assign"
  $JSON = "{'assignments':[{'id':'','target':{'@odata.type':'#microsoft.graph.groupAssignmentTarget','groupId':'$($AzureADGroup)'}}]}"
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Post -Body $JSON -ErrorAction Stop -ContentType 'application/json'
}

$ConfigurationPolicies = Get-ConfigurationPolicies | where Name -like "Prod_Win*"

foreach ($ConfigurationPolicy in $ConfigurationPolicies){
  Write-Host "Assigning Configuration Policy's $($Configurationpolicy.Name)"
  $policyid = $Configurationpolicy.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyid')/assign"
  $JSON = "{'assignments':[{'id':'','target':{'@odata.type':'#microsoft.graph.groupAssignmentTarget','groupId':'$($AzureADGroup)'}}]}"
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Post -Body $JSON -ErrorAction Stop -ContentType 'application/json'
}

#Assign Powershell Scripts
$IntunePowershellScripts = Get-IntunePowershellscripts | where Displayname -like "Prod_Win*"

foreach ($IntunePowershellScript in $IntunePowershellScripts){
  Write-Host "Assigning Intune Powershell Script $($IntunePowershellScript.displayName)"
  $policyid = $IntunePowershellScript.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts('$policyid')/assign"
  $JSON = "{'deviceManagementScriptGroupAssignments':[{'@odata.type':'#microsoft.graph.deviceManagementScriptGroupAssignment','targetGroupId': '$AzureADGroup','id': '$policyid'}]}"
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Post -Body $JSON -ErrorAction Stop -ContentType 'application/json'
}

#Assign Compliance Policies
$CompliancePolicys = Get-CompliancePolicys | where Displayname -like "Prod_Win*"

foreach ($CompliancePolicy in $CompliancePolicys){
  Write-Host "Assigning Compliance Policy $($CompliancePolicy.displayName)"
  $policyid = $CompliancePolicy.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies('$policyid')/assign"
  $JSON = "{'assignments':[{'id':'','target':{'@odata.type':'#microsoft.graph.groupAssignmentTarget','deviceAndAppManagementAssignmentFilterId': '$($DeviceFilter)', 'deviceAndAppManagementAssignmentFilterType': 'include','groupId':'$($AzureADGroup)'}}]}"
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Post -Body $JSON -ErrorAction Stop -ContentType 'application/json'
}




#####################################################################################
#Get Current Assignments
#####################################################################################

#Assign Delivery Optimization, Wifi, Update Rings, Endpoint protection, Custom
$DeviceConfigurations = Get-DeviceConfigurations | where Displayname -like "Prod_Win*"

foreach ($DeviceConfiguration in $DeviceConfigurations){
  Write-Host "Getting Device Configurations assignments $($DeviceConfiguration.displayName)"
  $policyid = $DeviceConfiguration.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$policyid')/assignments"                
 
  $AssignedGroup = Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Get  -ErrorAction Stop 
  Write-host "Assigned groups IDs are $($assignedgroup.value.target.groupid)"
}

#$DeviceConfiguration = $DeviceConfigurations[0]


$ConfigurationPolicies = Get-ConfigurationPolicies | where Name -like "Prod_Win*"

foreach ($ConfigurationPolicy in $ConfigurationPolicies){
  Write-Host "Getting Device Configurations assignments $($ConfigurationPolicy.Name)"
  $policyid = $ConfigurationPolicy.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyid')/assignments"                
 
  $AssignedGroup = Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Get  -ErrorAction Stop 
  Write-host "Assigned groups IDs are $($assignedgroup.value.target.groupid)"
}

$CompliancePolicys = Get-CompliancePolicys | where Displayname -like "Prod_Win*"

foreach ($CompliancePolicy in $CompliancePolicys){
  Write-Host "Getting Device Compliance assignments $($CompliancePolicy.displayName)"
  $policyid = $CompliancePolicy.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies('$policyid')/assignments"                
 
  $AssignedGroup = Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Get  -ErrorAction Stop 
  Write-host "Assigned groups IDs are $($assignedgroup.value.target.groupid)"
}


#####################################################################################
#Remove Assignments
#####################################################################################

#Assign Delivery Optimization, Wifi, Update Rings, Endpoint protection, Custom
$DeviceConfigurations = Get-DeviceConfigurations | where Displayname -like "Prod_Win*"

foreach ($DeviceConfiguration in $DeviceConfigurations){
  Write-Host "Removing Assignment for Device Configuration $($DeviceConfiguration.displayName)"
  $policyid = $DeviceConfiguration.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$policyid')/assignments"
                
 
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Delete  -ErrorAction Stop 
  Write-host "Assignments removed "
}




foreach ($ConfigurationPolicy in $ConfigurationPolicies){
  Write-Host "Removing Assignments $($ConfigurationPolicy.Name)"
  $policyid = $ConfigurationPolicy.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies('$policyid')/assignments"                
 
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Delete  -ErrorAction Stop 
  Write-host "Assignments removed "
}






######################################################################################################

$CompliancePolicy = $CompliancePolicys[5]

$CompliancePolicys = Get-CompliancePolicys | where Displayname -like "Prod_Win*"

foreach ($CompliancePolicy in $CompliancePolicys){
  Write-Host "Removing Assignment for Compliance Policy $($CompliancePolicy.displayName)"
  $policyid = $CompliancePolicy.id
  $policyuri = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies('$policyid')/assignments('$AzureADGroup')"
                
  Invoke-RestMethod -Uri $policyuri -Headers $AuthHeaders -Method Delete  -ErrorAction Stop 
  Write-host "Assignments removed "

}



