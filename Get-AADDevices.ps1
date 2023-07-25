<#
Once off.
Install-Module Microsoft.Graph
Connect-MgGraph -Scopes Device.Read.All
#>


<#
.SYNOPSIS
    Gets a list of all the devices in the tenanat along with the registered owners with support for resuming.
.DESCRIPTION
    This script provides support for resuming a download if a network error occurs when working with large tenants.
.EXAMPLE
    PS C:\> Get-Devices OutputFile ./devices.csv
    Runs a download and writes output to ./devices.csv.
#>

param (
        # Location where the file is to created. e.g. ./devices.csv
        [Parameter(Mandatory = $true)]
        [string] $OutputFile
    )
    
    $graphRequest = 'https://graph.microsoft.com/v1.0/devices'

    $cacheFilePath = './script.cache'
    $pageCount = 999
    $currentCount = 1
    $resume = $false
    $percentComplete = 0
    $statusMessage = ""

    $uri = "$($graphRequest)?`$top=$pageCount&`$expand=registeredOwners"
    
    if((Test-Path -Path $cacheFilePath -PathType Leaf)){ ## Cache exists from previous run
        $resumePrompt = Read-Host "Do you want to resume from where the script was interrupted? [y/n]"
        $resume = $resumePrompt -match "[yY]"
        if($resume) {
            $cacheInfo = Get-Content -Path $cacheFilePath | ConvertFrom-Json
            $uri = $cacheInfo.nextLink
            $currentCount = $cacheInfo.currentCount
            $totalCount = $cacheInfo.totalCount
        }
    }

    if(!$resume){        
        if((Test-Path -Path $OutputFile -PathType Leaf)){
            $overwritePrompt = Read-Host "OutputFile already exists. Do you want to overwrite it?  [y/n]"
            if($overwritePrompt -match "[yY]"){
                Remove-Item $OutputFile
            }
            else {
                Write-Error "File already exists at $OutputFile"
                return
            }
        }    
        Write-Progress -Activity "Getting items" -Status "Looking up total count"
        $totalCount = (Invoke-GraphRequest -Uri "$($graphRequest)?`$count=true&$`$top=1" -Headers @{ConsistencyLevel='eventual'}).'@odata.count'
    }
    
    Write-Progress -Activity "Getting items"
    $reportJson = Invoke-GraphRequest -Uri $uri

    do
    {
        $summary = @()
        foreach($item in $reportJson.value)
        {
            if($totalCount -gt $pageCount) { 
                [int]$percentComplete =  (($currentCount / $totalCount) * 100)
                $statusMessage = "[$percentComplete% $currentCount / $totalCount]"
            }
            Write-Progress -Activity "Getting items" -Status "$statusMessage $($item.displayName)" -PercentComplete $percentComplete
            $itemInfo = [pscustomobject]@{
                id = $item.id
                DeviceName = $item.displayName
                Enabled = $item.accountEnabled
                OS = $item.operatingSystem
                Version = $item.operatingSystemVersion
                JoinType = $item.enrollmentType
                Owner = ($item.registeredOwners | Select-Object -ExpandProperty userPrincipalName) -join '|'
                LastLogonTimestamp = $item.approximateLastSignInDateTime
            }

            $summary += $itemInfo
        }

        $summary | Export-Csv -Path $OutputFile -NoTypeInformation -Append

        if($null -ne $reportJson.'@odata.nextLink') {
            $currentCount += $pageCount
            $cacheInfo = @{
                nextLink = $reportJson.'@odata.nextLink'
                currentCount = $currentCount
                totalCount = $totalCount
            }
            $cacheInfo | ConvertTo-Json | Out-File -FilePath $cacheFilePath
            $reportJson = Invoke-GraphRequest -Uri $reportJson.'@odata.nextLink'
        }

    } while ($null -ne $reportJson.'@odata.nextLink') 

    Write-Progress -Activity "Getting items" -Completed
    if(Test-Path -Path $cacheFilePath -PathType Leaf){
        Remove-Item -Path $cacheFilePath
    }