try {
 
    New-LocalUser -Name "KIOSK" -NoPassword -UserMayNotChangePassword -AccountNeverExpires
    Set-localUser -name "KIOSK" -PasswordNeverExpires $true
    exit 0
 
} catch {
 
    # If an error occurs (e.g., user not found), return 1
 
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
 
}
 