###### Test for MSAL.PS Groups
## Env Thesalazar.cloud
$group = Get-MgGroup
$group.count 
# Equals 100
$Pagegroup = Get-MgGroup -all
$Pagegroup.Count
# Equals 107 


#### MSAL.PS
Write-Host "Getting token for Authentication"

# Token voor Configuration Profiles, Update Policies
$authResult = Get-MsalToken -ClientId d1ddf0e4-d672-4dae-b554-9d5bdfd93547 -RedirectUri "urn:ietf:wg:oauth:2.0:oob" -Interactive
$AuthHeaders = @{
          'Content-Type'='application/json'
          'Authorization'="Bearer " + $authResult.AccessToken
          'ExpiresOn'=$authResult.ExpiresOn
         
}

#Function to all groups 
Function Get-AADGroups(){
   
    $graphApiVersion = "Beta"
    $Resource = "groups"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    $Groups = Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get


    #Get Value/information of the first it pulls
    $AADGroups = $Groups.value
    #Get Next Link page
    $AADGroupsNextLink = $Groups.'@odata.nextLink'

    #While next link page is not null do the following
    while ($AADGroupsNextLink -ne $null){
        #Get the next 5 Groups
        $Groups = (Invoke-RestMethod -Method GET -Uri $AADGroupsNextLink -Headers $AuthHeaders)
        #Get the next link
        $AADGroupsNextLink = $Groups.'@odata.nextLink'
        #Add the 5 Groups to the orignal array
        $AADGroups += $Groups.value
    }
    
  }
  $aadgroups = get-aadgroups
  



######## Chat GPT Optimized

Function Get-GPTAzureADGroups {
    $GraphApiVersion = "beta"
    $Resource = "groups"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
    $AADGroups = @()

    do {
        $Groups = Invoke-RestMethod -Uri $uri -Headers $AuthHeaders -Method Get
        $AADGroups += $Groups.value
        $uri = $Groups.'@odata.nextLink'
    } while ($uri -ne $null)

    return $AADGroups
}


$GPTGroups = Get-GPTAzureADGroups

