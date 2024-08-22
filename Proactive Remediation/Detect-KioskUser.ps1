try {
 
    # Check if the user KIOSK exists
 
    $userExists = Get-LocalUser -Name "KIOSK" -ErrorAction Stop
 
    # If the user doesn't exist, return 1
 
    if (-not $userExists) {
 
        Write-Host "User Not Found"
        exit 1
 
    } else {
 
        Write-Host "Kiosk user exists"
        exit 0
 
    }
 
} catch {
 
    # If an error occurs (e.g., user not found), return 1
 
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
 
}
 

 
 
 
 
 
 
 
