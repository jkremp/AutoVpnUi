#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; Function Uuid
; 	returns UUID (Universally unique identifier) member of the System Information structure in the SMBIOS information
;	this should be unique to a particular computer
Uuid()
{
	For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
		return obj.UUID	; http://msdn.microsoft.com/en-us/library/aa394105%28v=vs.85%29.aspx
}