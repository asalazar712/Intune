$authParams = @{
    Clientid = '14d82eec-204b-4c2f-b7e8-296a70dab67e'
    TenantId = '<TenantID>'
    DeviceCode = $true
}

$auth = Get-MsalToken @authParams
$AccessToken = $Auth.accesstoken 
$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $($AccessToken)"
}
# Will calcultae how many bytes are in gigas
$Bytes = 30GB/1
# Invoking Intune Devices that have less than 30 GB
$method = "GET"
$URI = "https://graph.microsoft.com/beta/deviceManagement/managedDevices?freeStorageSpaceinBytes le $Bytes"

$Devices = Invoke-RestMethod -Method $method -URI $URI -Headers $headers
#Creating an empty array
$QueriedDevices=@()

# Loop will iterate through all $Devices and add the AAD Id into array $QueriedDevices
foreach($Device in $Devices){
    # Getting only the AAD Id from the Intune Device record
    $DevicetoAdd = $Device.value.azureADDeviceId
    # Adding the Value from the line above to the empty array
    $QueriedDevices += $DevicetoAdd
}

# Filtering on Intune Azure DeviceID to get the Id from the AAD record
foreach($AADDevice in $QueriedDevices){
$URI2 = "https://graph.microsoft.com/beta/devices?`$filter=deviceId eq '$($AADDevice)'"
$AADDevicesQuery = Invoke-RestMethod -Method $method -Uri $URI2 -Headers $headers
$AADDeviceQ = $AADDevicesQuery.value.id
# Now that we have the id for the AAD Record, an update will be added to AAD record
# Will be to edit device, that's why we need the AAD Device to eventually add up a property
$URI3 = "https://graph.microsoft.com/beta/devices/$AADDeviceQ"
$Body = @{
    # Normally we can change data, but with Nested jsons, you have to nest (Nested JSONS)
    extensionAttributes = @{
        extensionAttribute1 = "PEBKAC"
    }
}
$Body = $Body | ConvertTo-Json
Invoke-RestMethod -Method "PATCH" -Uri $URI3 -Headers $headers -Body $Body


}