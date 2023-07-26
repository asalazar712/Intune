$userName = "<USER>"
$userexist = (Get-LocalUser).Name -Contains $userName
if($userexist -eq $false) {
  try{ 
     New-LocalUser -Name $username -Description "Cloudinfra101 local user account" -NoPassword
     Exit 0
   }   
  Catch {
     Write-error $_
     Exit 1
   }
} 