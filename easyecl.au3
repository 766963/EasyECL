#cs------------------------------------------------
 _____                _____ _____  _
|  ___|              |  ___/  __ \| |
| |__  __ _ ___ _   _| |__ | /  \/| |
|  __|/ _` / __| | | |  __|| |    | |
| |__| (_| \__ \ |_| | |___| \__/\| |____
\____/\__,_|___/\__, \____/ \____/\_____/
                 __/ |               v1.4
                |___/

Victor Persson <root@ssh.nu>

v1.4: Added hotkey (CTRL+ALT+L) to lock + unmount.

v1.3: Added LockWorkstation button to quickly lock & unmount.

v1.2: removed mount & unmount files from dir and made them temp files instead.

v1.1: added WinMove() to bottom left corner because why not

v1.0: initial release

#ce------------------------------------------------

#RequireAdmin
#include <GUIConstants.au3>
#include <ColorConstants.au3>
#include <GuiConstantsEx.au3>
#include <File.au3>

HotKeySet("^!l", "LockWorkstation")

$VERSION="1.4"
$CONTAINERLOCATION="C:\container.vhd"

$hGUI = GuiCreate("EasyECL", 250, 60)
$L1 = GUICtrlCreateLabel("Easy Encrypted Container Loader v" & $VERSION, 33, 10, 250, 20)
    GUICtrlSetTip(-1, "By Victor Persson <root@ssh.nu>" & @CRLF & @CRLF & "https://github.com/766963/EasyECL")
$MOUNT = GUICtrlCreateButton("Mount!", 15, 30, 60, 25)
    GUICtrlSetTip(-1, "Mounts " & $CONTAINERLOCATION)
$UNMOUNT = GUICtrlCreateButton("Unmount!", 95, 30, 60, 25)
    GUICtrlSetTip(-1, "Unmounts " & $CONTAINERLOCATION)
$LOCK = GUICtrlCreateButton("Lock!", 175, 30, 60, 25)
    GUICtrlSetTip(-1, "Unmounts "& $CONTAINERLOCATION & " and locks your workstation")

;Colorize the gooey! \o/
GUICtrlSetColor($L1, $COLOR_WHITE)
GUICtrlSetBkColor($MOUNT, $COLOR_BLACK)
GUICtrlSetColor($MOUNT, $COLOR_WHITE)
GUICtrlSetBkColor($UNMOUNT, $COLOR_BLACK)
GUICtrlSetColor($UNMOUNT, $COLOR_WHITE)
GUICtrlSetBkColor($LOCK, $COLOR_BLACK)
GUICtrlSetColor($LOCK, $COLOR_WHITE)
GUISetBkColor($COLOR_BLACK)
GUISetState(@SW_SHOW, $hGui)

; 1.3: Extra functions, uncomment if you want to use them..
;;;;;;;;;;; WinMove function for 1920x1080
; Local $hWnd = WinWait("EasyECL","",1)
; WinMove($hWnd, "", 0,935, 300,83)
;;;;;;;;;; Transparency - 0-255 scale. 255 = solid
;WinSetTrans($hGUI, "", 100)
;;;;;;;;;; Always on top
;WinSetOnTop ($hGUI, "", 1)


Func Mount()
   FileWriteLine(@TempDir & "\mount.ecl", "select vdisk file=" & $CONTAINERLOCATION)
   FileWriteLine(@TempDir & "\mount.ecl", "attach vdisk")
   $PID = Run(@ComSpec & " /k diskpart.exe /s " & @TempDir & "\mount.ecl", @SystemDir, @SW_HIDE)
   sleep(1500)
   FileDelete(@TempDir & "\mount.ecl")
   ProcessClose($PID)
 EndFunc

Func Unmount()
   FileWriteLine(@TempDir & "\unmount.ecl", "select vdisk file=" & $CONTAINERLOCATION)
   FileWriteLine(@TempDir & "\unmount.ecl", "detach vdisk")
   $PID = Run(@ComSpec & " /k diskpart.exe /s " & @TempDir & "\unmount.ecl", @SystemDir, @SW_HIDE)
   sleep(1000)
   FileDelete(@TempDir & "\unmount.ecl")
   ProcessClose($PID)
EndFunc

Func LockWorkstation()
   Unmount()
   Run( "rundll32.exe user32.dll LockWorkStation" )
EndFunc

While 1
   $MSG = GUIGetMsg()

Select
   Case $MSG = $GUI_EVENT_CLOSE
   Exit

Case $MSG = $MOUNT
   Mount()

Case $MSG = $UNMOUNT
   Unmount()

Case $MSG = $LOCK
   LockWorkstation()

EndSelect

WEnd