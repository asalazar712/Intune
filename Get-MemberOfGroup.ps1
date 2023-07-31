# https://github.com/Ccmexec/Intune-MEM/blob/master/Make%20Enrolled%20user%20local%20admin/SetLocalAdmin.ps1
# set output to be list of strings  

function Get-MembersOfGroup {
    Param(
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$GroupName,
        [string]$Computer = $env:COMPUTERNAME
    )

    $membersOfGroup = [System.Collections.Generic.List[string]]::new()
    $ADSIComputer = [ADSI]("WinNT://$Computer,computer")
    $group = $ADSIComputer.psbase.children.find("$GroupName", 'Group')

    $group.psbase.invoke("members") | ForEach {
		[string]$TempMemberOfGroup = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
        $membersOfGroup.Add($TempMemberOfGroup) > $null
    }

    $membersOfGroup
}

