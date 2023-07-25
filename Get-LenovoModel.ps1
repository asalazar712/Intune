Param
(
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
    [string]$Models
)



$URL = "https://download.lenovo.com/bsco/schemas/list.conf.txt"
$OutFile = "$env:temp\Models_List.txt"
Invoke-WebRequest -Uri $URL -OutFile $OutFile 

$ModelTrim = $Models.Substring(0,4)
$Get_Models = Get-Content $OutFile | where-object { $_ -like "*$ModelTrim*"}
$Get_FamilyName = ($Get_Models.split("("))[0]

Write-Host $Models, $Get_FamilyName
