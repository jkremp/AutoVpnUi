$ApplicationName = 'AutoVpnUi'
$Cwd = $MyInvocation.MyCommand.Path | Split-Path -Parent
$SourcePath = $Cwd
$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Start Menu\Programs\Startup" + "\" + $ApplicationName + ".lnk")
$objShortCut.TargetPath = $SourcePath + "\" + $ApplicationName + ".exe"
$objShortCut.Save()