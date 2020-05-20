# AutoVpnUi
When triggered, AutoVpnUi automates the complete VPN connection process including entering the password. AutoVpnUi is a [AutoHotKey](https://www.autohotkey.com) script wrapping Cisco's VPN client VpnUi.exe.

AutoVpnUi runs in the background and is either started as a script, which requires a AutoHotKey installation, or as a compiled executeable.

Once AutoVpnUi is started it is waiting for shortcut pressed. This shortcut will initiate the automated VPN connection. The default shortcut is <kbd>CTRL</kbd>+<kbd>PrintScreen</kbd>.

# How to run?

* Download latest zip archive from repository
* Unpack 
* Start executable
* Use preconfigured shortcut <kbd>CTRL</kbd>+<kbd>PrintScreen</kbd>
* Optional: install shortcut in autostart either manually or using provided PowerShell script


# How does it work?

Once started AutoVpnUi runs in the background waiting to be triggered by shortcut. Once pressed the AutoHotKey based routine is executed. This routine starts Cisco's `VpnUi.exe` which has to be installed. When the first `VpnUi.exe`dialogue opens AutoVpnUi automatically initiates the VPN connection. 

*Remark*: The very first VPN connection must be initiated manually. `VpnUi.exe` remembers the last selected end point next time executed.

Once the VPN connection is established the password dialogue pops up. AutoVpnUi will now automatically enter the VPN password and confirm it. The authentication process starts. If the password was correct, the script will close the final information dialogue about the established VPN connection. The routine is finished. AutoVpnUi script keeps running in the background waiting to be triggered again.

The first time the AutoVpnUi is executed it asks to enter the VPN password. The given password will be encrypted and saved in an INI-configuration file next to AutoVpnUi executeable or script if run from source.

Each time AutoVpnUi is triggered by the shortcut it will look into the INI-file for the password, decrypts it and uses it for the automated login process. No further interaction by the user is required after the shortcut had been pressed.

# What happens with my VPN password?

The user's VPN password is needed in order to provide a fully automated VPN login process. 

It is the free choice of the user of AutoVpnUi to provide the VPN password.

AutoVpnUi itself will only use the password to provide it to Cisco's VPN client when needed. 

AutoVpnUi will never send any VPN connection related information like the password somewhere else.

AutoVpnUi asks for the password only when triggered by the shortcut until the password is provided. The VPN password is encrypted and saved in an INI-file. The encryption uses an open source algorithm which is available in the AutoVpnUi's repository.

**_Remark_**: AutoVpnUi never guarantees full protection for the provided VPN password. It is the users free choice to provide it. It is also the users responsibility keeping the INI-file with the encrypted stored password, safe.

However, following precautions are taken by AutoVpnUi:
* The provided VPN password is encrypted and saved in an INI-file
* During the process of providing, encryption and saving the password, the clear password is saved in a local variable
  * Preventing in-memory attacks, AutoVpnUi should be restarted after the password had been provided the first time
* Each time AutoVpnUi needs the password it is read from the INI-file and decrypted
  * The decrypted password is not saved in a local variable and should be in program's memory only for a "short" time - if even
* AutoVpnUi uses the Uuid of the machine encrpyting the password
  * The password can only be decrypted on the same machine or by the knowledge of the machine's Uuid


# Configuration

All settings are saved in an INI-file next to the AutoVpnUi script respectively the compiled version.

## VPN password

The VPN password is encrypted and saved in the INI-file. If the password shall be reset the correspondent entry must be removed.

## Shortcut

The shortcut initiating the actual behaviour of AutoVpnUi is saved in the INI-file. The default shortcut can be changed using following notations:

Notation:
* `^` - means <kbd>Ctrl</kbd> key, example: `^s` stands for <kbd>Ctrl</kbd>+<kbd>s</kbd>
* `!` - means <kbd>Alt</kbd> key, example: `^!s` stands for <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>s</kbd>
* `+` - means <kbd>SHIFT</kbd> key, example: `+s` stands for <kbd>SHIFT</kbd>+<kbd>s</kbd>
* `#` - <kbd>Win</kbd> key, example: `#s` stands for <kbd>Win</kbd>+<kbd>s</kbd>
* `<^>!` - <kbd>AltGr</kbd>, example `<^>!s` stans for <kbd>AltGr</kbd>+<kbd>s</kbd>
* Many more can be found here: https://www.autohotkey.com/docs/Hotkeys.htm.

# Run from source

* Install AutoHotkey https://www.autohotkey.com/
* Clone repository
* Execute script `AutoVpnUi.ahk`
