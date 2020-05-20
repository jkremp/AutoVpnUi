Remove-Item .\Dist\* -Recurse -ErrorAction:SilentlyContinue
New-Item -ItemType Directory -Force -Path .\Dist
$(Ahk2Exe.exe /in ".\Src\AutoVpnUi.ahk" /icon ".\Res\AutoVpnUi_48x48.ico" /out ".\Dist\AutoVpnUi.exe")