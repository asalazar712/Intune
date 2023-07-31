# ---------------------------------------------
# Remove default system applications
# ---------------------------------------------

# ------------------- setup -------------------
# Run this script using the logged on credentials: No
# Enforce script signature check: No
# Run script in 64 bit PowerShell Host: Yes
# ---------------------------------------------

# ------------------ logging ------------------
$LogPrefix = "SystemAppRemove-"
$Timestamp = Get-Date
$LogPath = "$env:SystemDrive\Managed-Desktop-Logs\"
$LogFile = $LogPath + $LogPrefix + $Timestamp.ToFileTimeUtc() + ".log"
Start-Transcript -Path $LogFile
# Remove logs that are 5 days old
$cutOffDate = $Timestamp.AddDays(-5).ToFileTimeUtc()
foreach ($logFile in Get-ChildItem $LogPath) {
    if ($logFile.Name.StartsWith($LogPrefix) -and $logFile.Extension.Equals(".log")) {
        $logDateStr = $logFile.Name.Substring($LogPrefix.Length)
        $logDateStr = $logDateStr.Substring(0, $logDateStr.IndexOf("."))
        $logDate = 0
        if ([uint64]::TryParse($logDateStr, [ref]$logDate) -and $logDate -lt $cutOffDate) {
            Remove-Item "$LogPath$logFile"
            Write-Host "Removed old log file $logFile"
        }
    }
}
# ---------------- remove list ----------------
$removelist = @(
				"Microsoft.BingWeather",
			    "Microsoft.DesktopAppInstaller",
				"Microsoft.Getstarted",
				"Microsoft.MicrosoftOfficeHub",
				"Microsoft.MicrosoftSolitaireCollection",
				"Microsoft.OneConnect",
				"Microsoft.WindowsFeedbackHub",
				"Microsoft.XboxApp",
				"Microsoft.ZuneMusic",
				"Microsoft.windowscommunicationsapps",
				"Microsoft.SkypeApp"
			   )
# ---------------------------------------------

# ------------------- script ------------------
foreach ($tbr in $removelist) {
	Write-Output "Removing: $tbr"
	Get-AppxPackage -AllUsers | where-object {$_.name –like "*$tbr*" -and $_.NonRemovable -eq $false} | Remove-AppxPackage -AllUsers
}
# ---------------------------------------------
Stop-Transcript -Verbose