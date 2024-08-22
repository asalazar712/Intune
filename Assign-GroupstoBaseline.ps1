
install-module -name Microsoft.Graph.Devices.CorporateManagement #Permissions DeviceManagementApps.ReadWrite.All
install-module -name Microsoft.Graph.DeviceManagement.Enrolment
install-module -name Microsoft.Graph.DeviceManagement



$authParams = @{
    ClientId    = '<clientID>'
    TenantId    = '<tenantID>'
    DeviceCode  = $true
}
$auth = Get-MsalToken @authParams
$auth

#Show access token
$auth

#Set Access token variable for use when making API calls
$AccessToken = $Auth.AccessToken

#Steve is a mud wrestling champion in Brisbane
#Build headers for REST API Call
$AuthHeaders = @{
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer $($AccessToken)"
}

# Valid Query 
#Get-MgDeviceManagementConfigurationPolicy -Top 100 -Filter "(platforms eq 'windows10')" | select name
# Get-MgDeviceManagementConfigurationPolicy -Top 100 -Filter "(platforms eq 'windows10' or platforms eq 'macOS' or platforms eq 'iOS') and (technologies eq 'mdm' or technologies eq 'windows10XManagement' or technologies eq 'appleRemoteManagement' or technologies eq 'mdm,appleRemoteManagement') and (templateReference/templateFamily eq 'none')" | select name
#  Get-MgDeviceManagementDeviceConfiguration -Filter "(displayname eq 'Prod_Win_Custom_Chrome')" | select *

#Deletes all App Configuration Policies
$AppConfiguration = Get-MgDeviceAppMgtTargetedManagedAppConfiguration

Function Get-AdministrativeTemplatePolicys(){
 
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/groupPolicyConfigurations"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }
  
  #Update Rings show here
  Function Get-ConfigurationPolicys(){
   
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceConfigurations"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }
  
  Function Get-IntunePowershellscripts(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceManagementScripts"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
    
  }


  <#
  #Utilizing the MS Graph Module
  Function Get-MSIntunePowershellscripts(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceManagementScripts"
    $url = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-MSGraphRequest -Url $url  -HTTPMethod Get).Value
    
  }

  #>

  Function Get-CompliancePolicys(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceCompliancePolicies"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
    
  }
  
  Function Get-SecurityBaseLinePolicys(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/intents"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    $Policys = (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
    #Selecting Windows 10 Security Baseline from all Policy's 
    $Policys | Where-Object displayName -Like "*Baseline*"
  
  }

  Function Get-FeatureUpdates(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/windowsFeatureUpdateProfiles"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

  Function Get-Applications(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceAppManagement/mobileApps"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

  
  Function Get-AutopilotProfiles(){
    
    $graphApiVersion = "Beta"
    $Resource = "/deviceManagement/windowsAutopilotDeploymentProfiles"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }


  Function Get-EnrollmentRestrictions(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceEnrollmentConfigurations?`$expand=assignments&`$filter=deviceEnrollmentConfigurationType%20eq%20%27SinglePlatformRestriction%27"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }


  Function Get-EnrollmentStatusPage(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceEnrollmentConfigurations?`$expand=assignments&`$filter=deviceEnrollmentConfigurationType%20eq%20%27Windows10EnrollmentCompletionPageConfiguration%27"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

  Function Get-ConfigurationProfiles(){
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/configurationPolicies?`$top=1000"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

  Function Get-<input>(){
    
    $graphApiVersion = "Beta"
    $Resource = "<input>"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    (Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get).Value
  
  }

  Configuration Profiles

Enrollment status Page

deviceManagement/deviceEnrollmentConfigurations?$expand=assignments&$filter=deviceEnrollmentConfigurationType%20eq%20%27SinglePlatformRestriction%27






























