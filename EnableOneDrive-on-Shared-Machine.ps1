## Enable onedrive on shared machines https://docs.microsoft.com/en-us/windows/configuration/set-up-shared-or-guest-pc#policies-set-by-shared-pc-mode

If (!(Test-Path -Path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -ErrorAction SilentlyContinue)) {
	New-Item -ItemType Directory -Path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -Force
}
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 0 -Force