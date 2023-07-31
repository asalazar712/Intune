<#
.SYNOPSIS
   Get-AppUninstallString retrieves the Name, Version, Uninstall String, Quiet Uninstall String, and Publisher for an application. These are necessary components to upload an application to intune
.DESCRIPTION
    Get-AppUninstallString searches the registry for  relevant information for x32 & x64 applications installed with EXE and MSI installers. 
.PARAMETER application
	The application name will be used to query the registry for installed software on the device
.EXAMPLE
	Get-AppUninstallString -application 'Google Chrome'
#>

[CmdletBinding()]
param (
	[Parameter(Mandatory=$True,HelpMessage="Enter an application name to query")]
	[String]$Application = ''
)
Write-Verbose "Searching for $Application"


$appdata = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
where DisplayName -like *$Application* 

if($appdata.uninstallstring -like '*MSIExec.exe*'){
$appdata | select-object Displayname, @{name="Version"; expression = {$_.DisplayVersion}}, Uninstallstring,  Publisher | fl
}else {
	$appdata | select-object Displayname, @{name="Install Location"; expression = {$_.DisplayIcon}}, @{name="Version"; expression = {$_.DisplayVersion}}, Uninstallstring, QuietUninstallString, Publisher
}




