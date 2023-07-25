function Get-MGCommandPermission {
    param (
        $GraphURI
    )
    
    #This command is ued to get command related the URI with method GET and API version Beta
    $MGCommand = Find-MgGraphCommand -Uri $GraphURI -Method Get -ApiVersion beta | select -Property command -ExpandProperty command

    # We're using the output of the previous command to search for the permissions required of that cmdlet
    Find-MgGraphCommand -Command $MGCommand -ApiVersion beta | select -First 1 -ExpandProperty Permissions

    write-host $MGCommand
}




######### Function in profile##################
<#
function Get-MGCommandPermission ($GraphURI) {
     $MGCommand = Find-MgGraphCommand -Uri $GraphURI -Method Get -ApiVersion beta | select -Property command -ExpandProperty command

    Find-MgGraphCommand -Command $MGCommand -ApiVersion beta | select -First 1 -ExpandProperty Permissions

    write-host $MGCommand

}

#>