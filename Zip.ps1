$Version = '2.0.1'
$ApplicationName = 'AutoVpnUi'
$Cwd = $MyInvocation.MyCommand.Path | Split-Path -Parent
$SourcePath = $Cwd + '\Dist'
$ResPath = $Cwd + '\Res'

Copy-Item $ResPath\AddToAutostart.ps1 $SourcePath
Compress-Archive -Path $SourcePath\* -DestinationPath .\$ApplicationName-$Version.zip -Force