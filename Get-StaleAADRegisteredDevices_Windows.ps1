#Script used to retrieve all Intune devices that are AzureAD Registered and have not checked in X amount of days, which are then deleted 
# Uses delegated permissions from Graph Powershell 

#Default value for last check-in date is 180 days
Param
(
    [Parameter(Mandatory=$true)]
    [string]$tenantid,    
    [int]$DaysSinceLastCheckIn = 365
    
)

#Setting the Outputfile location to users Documents folder 
$OutputLocation = [Environment]::GetFolderPath("MyDocuments")

#Set-Location $env:SystemDrive
 

# Load required modules

    Try
    {
        Write-host "Importing modules..." -NoNewline
        
        Import-Module Microsoft.Graph.DeviceManagement -ErrorAction Stop
            
        Write-host "Success" -ForegroundColor Green 
    }
    Catch
    {
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }


# Authenticate to MG Graph Powershell enterprise application

    Try
    {
        Write-Host "Authenticating with MG Graph and Azure AD..." -NoNewline
        
        $scope = @(
            "DeviceManagementManagedDevices.Read.All"
            "DeviceManagementManagedDevices.ReadWrite.All"
        )
        
            
        Connect-MGGraph -Scopes $scope -TenantId $tenantid
         
        Select-MgProfile -Name beta
        Write-host "Success" -ForegroundColor Green
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        Write-host "$($_.Exception.Message)" -ForegroundColor Red
        Return
    }



Write-host "$DaysSinceLastCheckIn Days" -ForegroundColor Yellow
Write-Host "===============" -ForegroundColor Yellow

#Setting last check in variable for filter used in line 81
$datetime = (Get-Date).AddDays(-$DaysSinceLastCheckIn).ToString("yyyy-MM-dd")
Write-host "Last Check-in date $datetime" -ForegroundColor Yellow
Write-Host "===============" -ForegroundColor Yellow




# Retrieving devices from Intune
# Graph API - devicemanagement/manageddevices

    Try
    {
        Write-host "Retrieving " -NoNewline
        Write-host "AAD Windows Registered Intune " -ForegroundColor Yellow -NoNewline
        Write-host "managed device record/s that haven't checked in since $datetime..." -NoNewline
        [array]$IntuneDevices = Get-mgDeviceManagementManagedDevice -filter "OperatingSystem eq 'Windows' and lastSyncDateTime lt $datetime" |  where {$_.JoinType -eq 'azureADRegistered'} | Select-Object DeviceName, LastSyncDateTime,AutopilotEnrolled, AzureAdDeviceId, DeviceEnrollmentType, JoinType, ManagedDeviceOwnerType, SkuFamily, SerialNumber 
        $AzureADDevices = New-Object System.Collections.ArrayList
        If ($IntuneDevices.Count -ge 1)
        {
            foreach ($IntuneDevice in $IntuneDevices)
            {                
                $AzureADDevice = Get-MgDevice | where {$_.DeviceId -eq $IntuneDevice.AzureAdDeviceId} | Select-Object DisplayName, DeviceId, Id, ApproximateLastSignInDateTime, OperatingSystem, TrustType
                [void]$AzureADDevices.Add($AzureADDevice)
            }

            Write-Host "Outputting files in $OutputLocation" -ForegroundColor Green
        
            $IntuneDevices | Export-Csv $OutputLocation\Intune_RegisteredDevices_LastCheckin$datetime.csv
            $AzureADDevices | Export-Csv $OutputLocation\AAD_RegisteredDevices_LastCheckin$datetime.csv
            
        }
        Else
        {
            Write-host "Not found!" -ForegroundColor Red
        }
    }
    Catch
    {
        Write-host "Error!" -ForegroundColor Red
        $_
    }


#Set-Location $env:SystemDrive




