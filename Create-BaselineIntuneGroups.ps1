#Resources https://learn.microsoft.com/en-us/graph/api/group-post-groups?view=graph-rest-1.0&tabs=powershell


#>

#Or Install-Module if you're using this for the first time

[CmdletBinding(DefaultParameterSetName='All')]
Param
(
    
    [Parameter(ParameterSetName='All',Mandatory=$true)]
    [Parameter(ParameterSetName='Individual',Mandatory=$true)]
    [string]$tenantid,
	[Parameter(ParameterSetName='Individual')]
    [switch]$Android,
    [Parameter(ParameterSetName='Individual')]
    [switch]$iOS,
    [Parameter(ParameterSetName='Individual')]
    [switch]$MacOS,
	[Parameter(ParameterSetName='Individual')]
    [switch]$Windows,
    [Parameter(ParameterSetName='All')]
    [switch]$All = $True
)




#Importing Graph Module to create groups 

if (Get-Module -ListAvailable -Name Microsoft.Graph.Groups) {
    Write-Host "Module exists"
	Import-Module -Name Microsoft.Graph.Groups
}
else {
    Install-module Microsoft.Graph.Groups -AllowClobber -Force
}

#Authenticate to Microsoft Graph PowerShell

Connect-mggraph -tenantid $tenantid -scope Directory.ReadWrite.All, Group.ReadWrite.All 

Select-MgProfile -Name beta


#General Groups

If ($PSBoundParameters.ContainsKey("Android") -or $PSBoundParameters.ContainsKey("iOS") -or $PSBoundParameters.ContainsKey("MacOS") -or $PSBoundParameters.ContainsKey("Windows") -or $PSBoundParameters.ContainsKey("All"))
{
    Try
    {
        Write-Host "Creating General Groups..." -NoNewline
        
        New-MgGroup -DisplayName 'AAD-SKU-MicrosoftIntune-User-Dynamic' -grouptypes DynamicMembership -membershiprule '((user.assignedPlans -any (assignedPlan.servicePlanId -eq "c1ec4a95-1f05-45b3-a911-aa3fa01094f5" -and assignedPlan.capabilityStatus -eq "Enabled")) -or (user.assignedPlans -any (assignedPlan.servicePlanId -eq "da24caf9-af8e-485c-b7c8-e73336da2693" -and assignedPlan.capabilityStatus -eq "Enabled"))) -and (user.userType -eq "Member") -and (user.accountEnabled -eq True)' -MailEnabled:$False -MailNickname 'AllUsers' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-Test-Users-Assigned' -MailEnabled:$False -MailNickname 'TestUsers' -SecurityEnabled

		New-MgGroup -DisplayName 'Intune-Test-Devices-Assigned' -MailEnabled:$False -MailNickname 'TestDevices' -SecurityEnabled

		#New-MgGroup -DisplayName 'Intune-All-Personal-Device-Dynamic' -grouptypes DynamicMembership -membershiprule '(device.deviceOwnership -eq "Personal")' -MailEnabled:$False -MailNickname 'AllPersonalDevices' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-Win-Admins-Assigned' -MailEnabled:$False -MailNickname 'WinAdmins' -SecurityEnabled
        
        Write-host "Success" -ForegroundColor Green
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }
}

#Android 

If ($PSBoundParameters.ContainsKey("Android")  -or $PSBoundParameters.ContainsKey("All"))
{
    Try
    {
        Write-Host "Creating Android Groups..." -NoNewline
        
        New-MgGroup -DisplayName 'Intune-Android-Personal-Device-Dynamic' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -eq "AndroidForWork") and (device.deviceOwnership -eq "Personal")' -MailEnabled:$False -MailNickname 'PersonalAndroid' -SecurityEnabled -MembershipRuleProcessingState On

        Write-host "Success" -ForegroundColor Green
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }
}

#iOS

If ($PSBoundParameters.ContainsKey("iOS")  -or $PSBoundParameters.ContainsKey("All"))
{
    Try
    {
        Write-Host "Creating iOS Groups..." -NoNewline
        
        New-MgGroup -DisplayName 'Intune-iOS/iPadOS-Corporate-Device-Dynamic' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -in ["iPhone","iPad"]) and (device.deviceOwnership -eq "Company")' -MailEnabled:$False -MailNickname 'CorporateiOS-iPadOS' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-iOS/iPadOS-DEP-Devices' -grouptypes DynamicMembership -membershiprule '(device.enrollmentProfileName -eq "Prod_iOS/iPadOS_UserAffintiy")' -MailEnabled:$False -MailNickname 'DEPiOS-iPadOS' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-iOS/iPadOS-Personal-Device-Dynamic' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -in ["iPhone","iPad"]) and (device.deviceOwnership -eq "Personal")' -MailEnabled:$False -MailNickname 'PersonaliOS-iPadOS' -SecurityEnabled -MembershipRuleProcessingState On

        Write-host "Success" -ForegroundColor Green
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }
}


#MacOS

If ($PSBoundParameters.ContainsKey("macOS")  -or $PSBoundParameters.ContainsKey("All"))
{
    Try
    {
        Write-Host "Creating macOS Groups..." -NoNewline
        
        New-MgGroup -DisplayName 'Intune-macOS-Corporate-Devices' -grouptypes DynamicMembership -membershiprule '(device.enrollmentProfileName -eq $null) and (device.deviceOSType -eq "MacMDM") and (device.deviceOwnership -eq "Company")' -MailEnabled:$False -MailNickname 'CorporateMac' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-macOS-DEP-Devices' -grouptypes DynamicMembership -membershiprule '(device.enrollmentProfileName -eq "Prod_macOS_UserAffintiy")' -MailEnabled:$False -MailNickname 'DEPMac' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-macOS-Devices' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -eq "macMDM")' -MailEnabled:$False -MailNickname 'Mac' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-macOS-Personal-Devices' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -contains "MacMDM") and (device.deviceOwnership -eq "Personal")' -MailEnabled:$False -MailNickname 'PersonalMac' -SecurityEnabled -MembershipRuleProcessingState On

        Write-host "Success" -ForegroundColor Green
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }
}


#Windows

If ($PSBoundParameters.ContainsKey("Windows")  -or $PSBoundParameters.ContainsKey("All"))
{
    Try
    {
        	#Create group based on Autopilot tag

		New-MgGroup -DisplayName 'Intune-Win-AutoPilotNoGroupTag-Dynamic-Device' -grouptypes DynamicMembership -membershiprule '(device.devicePhysicalIds -any _ -contains "[ZTDId]") and -not (device.devicePhysicalIds -any _ -contains "[OrderID]:")' -MailEnabled:$False -MailNickname 'AutoPilotNoGroupTag' -SecurityEnabled -MembershipRuleProcessingState On

		
			# Update Rings based groups

		New-MgGroup -DisplayName 'Intune-Win-UpdateRingBroad-Group1-Device-Dynamic' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -eq "Windows") and (device.deviceId -match "^[0-7]")' -MailEnabled:$False -MailNickname 'UpdateRingBroad1' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-Win-UpdateRingBroad-Group2-Device-Dynamic' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -eq "Windows") and (device.deviceId -match "^[8-9a-f]")' -MailEnabled:$False -MailNickname 'UpdateRingBroad2' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-Win-UpdateRingLimited-Device-Assigned' -MailEnabled:$False -MailNickname 'UpdateRingLimited' -SecurityEnabled

		New-MgGroup -DisplayName 'Intune-Win-UpdateRingPreview-Device-Assigned' -MailEnabled:$False -MailNickname 'UpdateRingPreview' -SecurityEnabled

			# Groups based on OS version

		
		New-MgGroup -DisplayName 'Intune-Win11-Version-21H2' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -eq "Windows") and (device.deviceOSVersion -contains "10.0.22000")' -MailEnabled:$False -MailNickname 'Win11-21H2' -SecurityEnabled -MembershipRuleProcessingState On

		New-MgGroup -DisplayName 'Intune-Win11-Version-22H2' -grouptypes DynamicMembership -membershiprule '(device.deviceOSType -eq "Windows") and (device.deviceOSVersion -contains "10.0.22621")' -MailEnabled:$False -MailNickname 'Win11-22H2' -SecurityEnabled -MembershipRuleProcessingState On

        Write-host "Success" -ForegroundColor Green
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }
}


