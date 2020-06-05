#Include Crypt/Crypt.ahk
#Include Crypt/CryptConst.ahk
#Include Crypt/CryptFoos.ahk
#Include Uuid/Uuid.ahk

#NoEnv ; Recommended for performance and compatibility with future AutoShortcut releases.
; #Warn ; Enable warnings to assist with detecting common errors.
#SingleInstance, force ; When this script is loaded and another instance is running, the running instance will be replaced
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

try {
    ; Name of script without extension
    SplitPath, A_ScriptName,,,, ScriptName
    ; INI file configurations
    IniFilename = %ScriptName%.ini
    IniFileSectionPassword = Password
    IniFileKeyVpnPassword = VpnPassword
    IniFileSectionShortcut = Shortcut
    IniFileKeyShortcut = Shortcut
    IniFileValueShortcut = ^PrintScreen
    ; Encryption key encrypting given password using computer's UUID
    Key := % Uuid()
    ; VPN Client information
    DlgTitleVpnUiMain = Cisco AnyConnect Secure Mobility Client
    DlgTitleVpnUiConnect = Cisco AnyConnect |
    DlgTitleVpnUiConnectionSuspended = Cisco AnyConnect
    
    ; Get shortcut from ini-file - if not available save default shortcut
    Shortcut := % ValueFromIniFile(IniFilename, IniFileSectionShortcut, IniFileKeyShortcut) 
    if (ErrorLevel)
    {
        SaveShortcutToIniFile(IniFilename, IniFileSectionShortcut, IniFileKeyShortcut, IniFileValueShortcut)
        Shortcut := % ValueFromIniFile(IniFilename, IniFileSectionShortcut, IniFileKeyShortcut) 
    }
    
    ; Bind the configured shortcut to the routine setting VPN password automatically
    Hotkey, %Shortcut%, VpnUiAutomatePassword
    
    return
} catch e {
    MsgBox, 16,, % "Error: " e.Message "at" e.Line
    exit 
}

SaveEncyrptedPasswordToIniFile(IniFilename, IniFileSection, IniFileKeyVpnPassword, Key)
{
    InputBox, VpnPassword, VPN Password, Please provide your VPN password which is used to automate login process. This is only aksed once.`n`nYour password will be encrypted and saved in '%IniFilename%'.`n`nIn order to reset your saved password remove the key '%IniFileKeyVpnPassword%' from the ini-file.`n`nVPN password:, HIDE, 390, 260
    
    if (ErrorLevel = 0 and VpnPassword != "")
    {
        IniWrite % Crypt.Encrypt.StrEncrypt(VpnPassword, Key, 7, 6), %IniFilename%, %IniFileSection%, %IniFileKeyVpnPassword%
    }
    else
    {
        MsgBox,48,, Empty password given or cancelled.`n`nPlease try again using shortcut.
        ErrorLevel = 1
    }
}

DecryptPasswordFromIniFile(IniFilename, IniFileSection, IniFileKeyVpnPassword, Key)
{
    EncryptedPassword := % ValueFromIniFile(IniFilename, IniFileSection, IniFileKeyVpnPassword)
    if ErrorLevel
    {
        ErrorLevel = 1
    }
    else 
    {
        return % Crypt.Encrypt.StrDecrypt(EncryptedPassword, Key, 7, 6)
    }
}

ValueFromIniFile(IniFilename, IniFileSection, IniFileKey)
{
    if FileExist(IniFilename)
    {
        IniRead Value, %IniFilename%, %IniFileSection%, %IniFileKey%
        ; If something went wrong 'ERROR' will be returned
        if (Value != "ERROR" and Value != "")
        {
            return Value
        }
    }
    ErrorLevel = 1
}

SaveShortcutToIniFile(IniFilename, IniFileSection, IniFileKey, IniFileKeyValue)
{
    IniWrite %IniFileKeyValue%, %IniFilename%, %IniFileSection%, %IniFileKey%
}

VpnUiAutomatePassword:
    ; Check and close if information dialogue connection suspended is open
    SetTitleMatchMode, 3
    if WinExist(DlgTitleVpnUiConnectionSuspended)
    {
        ; Get the PID of the VpnUi dialogue (main window)
        WinGet, pid, pid, %DlgTitleVpnUiMain%
        ; Get list of ids of all owned windows of the VpnUi dialogue
        WinGet, id, list, ahk_pid %pid% 
        ; Activate the foremost dialogue
        WinActivate, ahk_id %id1%
        if WinActive(DlgTitleVpnUiConnectionSuspended)
        {
            SendInput, {Enter}
        }
    }
    
    ; Close an maybe long waiting password dialogue
    SetTitleMatchMode, 1
    if WinExist(DlgTitleVpnUiConnect)
    {
        WinKill
    }
    
    ; Start VPN client, if active it will become formost window
    Run, C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe
    
    SetTitleMatchMode, 3
    WinWaitActive, %DlgTitleVpnUiMain%, ,15.0
    if WinActive(DlgTitleVpnUiMain)
    {
        ; Set keyboard focus to the control whose variable or text is "Connect".
        ControlFocus, Connect, %DlgTitleVpnUiMain%
        
        ; If VPN client ui is open (found by exact match of given window title), hit <Enter> to open password dialogue
        SendInput, {Enter}
        
        ; If VPN client password dialogue is open (found by window's title must start with given string)
        SetTitleMatchMode, 1
        WinWaitActive, %DlgTitleVpnUiConnect%, ,5.0
        if WinActive(DlgTitleVpnUiConnect)
        {
            ; Check if a password has already been saved; if not ask and save it
            ValueFromIniFile(IniFilename, IniFileSectionPassword, IniFileKeyVpnPassword) 
            if (ErrorLevel)
            {
                SaveEncyrptedPasswordToIniFile(IniFilename, IniFileSectionPassword, IniFileKeyVpnPassword, Key)
            }
            
            if (ErrorLevel = 0)
            {
                SendInput, % DecryptPasswordFromIniFile(IniFilename, IniFileSectionPassword, IniFileKeyVpnPassword, Key)
                SendInput, {Enter}
                
                SetTitleMatchMode, 3
                WinWaitActive, Cisco AnyConnect, ,1.0
                if ErrorLevel = 0
                {		
                    SendInput, {Enter}
                }
            }
        }
    }
return