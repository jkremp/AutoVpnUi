$Version = '2.0.3'
$ApplicationName = 'AutoVpnUi'
$Cwd = $MyInvocation.MyCommand.Path | Split-Path -Parent
$DistPath = $Cwd + '\Dist'
$ResPath = $Cwd + '\Res'
$BuildScript = $Cwd + '\Build.ps1'

Invoke-Expression -Command $BuildScript
Get-ChildItem -Path $ResPath\AddToAutostart.ps1, $DistPath\$ApplicationName.exe | Compress-Archive -DestinationPath .\$ApplicationName-$Version.zip -Force