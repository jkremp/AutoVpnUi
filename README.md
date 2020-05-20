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

AutoVpnUi is triggered by a shortcut. Once pressed the AutoHotKey based routine in the script is triggered. This routine starts Cisco's VpnUi.exe which has to be installed. When the first dialogue opens it automatically initiates the connection procedure. In order this works as expected, the wanted VPN end point should have been selected in a manual connection process first.
Once the connection is established the password dialogue pops up. The script will automatically enter the VPN password and confirm it. The authentication process starts. If the password was correct, the script will close the final information dialogue about the established connection and the routine is finished. The AutoVpnUi script keeps running in the background waiting to be triggered again by the shortcut.

The first time the AutoVpnUi script wants to enter the VPN password a AutoVpnUi dialogue asks to type in the password. The given password will be encrypted and saved in an INI-configuration file next to the script. Each time the script is triggered by the shortcut it will look into the INI-file for the password, encrypts it and uses it for the automated login process. Now further interaction by the user is required after the shortcut had been pressed.

# What happens with my VPN password?

The user's VPN password is needed in order to provide a fully automated login process. 

The scrip asks for the password only the first time or until provided. The VPN password then encrypted and saved in an INI-file. The encryption uses an open source algorithm available in the AutoVpnUi's repository.

Please note, without saving the VPN password, this entire automation makes no sense. AutoVpnUi does some steps to protect the given password:
* It will encrypt the password and saves it in an INI-file; the clear password is saved in a local variable of the program; preventing in-memory attacks, AutoVpnUi should be restarted after the password had been provided the first time.
* When needed the password is read from the INI-file and decrypted. The decrypted password is not saved in a local variable and should be in program's memory for a "short" time
* The encrption uses the Uuid of the machine where the encrpytion was executed. I.e. the password can only be encrypted on the same machine or by the knowledge of the Uuid.

In the end it is up to the user of AutoVpnUi to provide the VPN password. AutoVpnUi itself will only the password to provide it automatically to Cisco's VPN client when needed. The password or any other VPN connected related information used or sent somewhere else.

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
