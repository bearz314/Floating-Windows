; AutoIt Version v3.3.14.5
; Made by Bearz314 (http://www.misc314.com/)
; Core functionalities written by J2TEAM >>> https://github.com/J2TEAM/AutoIt-UDF-Collection/tree/master/Example%20Scripts/Windows%20Info%20Spy

#NoTrayIcon

#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ColorConstants.au3>

Global $CURSOR_TARGET = _WriteResource( _
        "0x000002000100202000000F001000300100001600000028000000200000004000000001000100000000008000" & _
        "00000000000000000000020000000200000000000000FFFFFF0000000000000000000000000000000000000000" & _
        "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
        "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
        "00000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
        "FFFFFFF83FFFFFE6CFFFFFD837FFFFBEFBFFFF783DFFFF7EFDFFFEAC6AFFFEABAAFFFE0280FFFEABAAFFFEAC6A" & _
        "FFFF7EFDFFFF783DFFFFBEFBFFFFD837FFFFE6CFFFFFF83FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
        "FFFFFFFFFFFFFFFFFFFFFFFF")
Global $ICON_TARGET_FULL = _WriteResource( _
        "0x0000010001002020080000000000E80200001600000028000000200000004000000001000400000000000002" & _
        "000000000000000000001000000010000000000000000000800000800000008080008000000080008000808000" & _
        "00C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000000000000000" & _
        "00000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFF" & _
        "FFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFF00000FFFFFFFFFFFF000FFFFFFFFFF00FF0FF00FFFFFFFFFF000FF" & _
        "FFFFFFF0FF00000FF0FFFFFFFFF000FFFFFFFF0FFFFF0FFFFF0FFFFFFFF000FFFFFFF0FFFF00000FFFF0FFFFFF" & _
        "F000FFFFFFF0FFFFFF0FFFFFF0FFFFFFF000FFFFFF0F0F0FF000FF0F0F0FFFFFF000FFFFFF0F0F0F0FFF0F0F0F" & _
        "0FFFFFF000FFFFFF0000000F0F0000000FFFFFF000FFFFFF0F0F0F0FFF0F0F0F0FFFFFF000FFFFFF0F0F0FF000" & _
        "FF0F0F0FFFFFF000FFFFFFF0FFFFFF0FFFFFF0FFFFFFF000FFFFFFF0FFFF00000FFFF0FFFFFFF000FFFFFFFF0F" & _
        "FFFF0FFFFF0FFFFFFFF000FFFFFFFFF0FF00000FF0FFFFFFFFF000FFFFFFFFFF00FF0FF00FFFFFFFFFF000FFFF" & _
        "FFFFFFFF00000FFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0" & _
        "00FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000007770CCCCCCCCCCCCCCCCCCCC" & _
        "C07770007070CCCCCCCCCCCCCCCCCCCCC07070007770CCCCCCCCCCCCCCCCCCCCC0777000000000000000000000" & _
        "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
        "000000000000000000FFFFFFFF8000000080000000800000008000000080000000800000008000000080000000" & _
        "800000008000000080000000800000008000000080000000800000008000000080000000800000008000000080" & _
        "0000008000000080000000800000008000000080000000800000008000000080000000FFFFFFFFFFFFFFFFFFFF" & _
        "FFFF")
Global $ICON_TARGET_EMPTY = _WriteResource( _
        "0x0000010001002020080000000000E80200001600000028000000200000004000000001000400000000000002" & _
        "000000000000000000001000000010000000000000000000800000800000008080008000000080008000808000" & _
        "00C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000000000000000" & _
        "00000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFF" & _
        "FFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FF" & _
        "FFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
        "F000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFF" & _
        "FFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFF" & _
        "FFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFF" & _
        "FFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFF" & _
        "FFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0" & _
        "00FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000007770CCCCCCCCCCCCCCCCCCCC" & _
        "C07770007070CCCCCCCCCCCCCCCCCCCCC07070007770CCCCCCCCCCCCCCCCCCCCC0777000000000000000000000" & _
        "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
        "000000000000000000FFFFFFFF8000000080000000800000008000000080000000800000008000000080000000" & _
        "800000008000000080000000800000008000000080000000800000008000000080000000800000008000000080" & _
        "0000008000000080000000800000008000000080000000800000008000000080000000FFFFFFFFFFFFFFFFFFFF" & _
        "FFFF")

; Loading cursor from file
$hTargetCursor = DllCall("User32.dll", "int", "LoadCursorFromFile", "str", $CURSOR_TARGET)
$hTargetCursor = $hTargetCursor[0]
$Quit = 0

Global $g_StartSearch = False, $gFoundWindow = 0, $gOldCursor
Global $PHWND

$hGUI = GUICreate("Float", 200, 280, -1, -1, -1, $WS_EX_TOPMOST)
GUISetBkColor($COLOR_WHITE)

GUICtrlCreateGroup("Pick Tool", 8, 0, 65, 65)
$hTargetPic = GUICtrlCreateIcon($ICON_TARGET_FULL, 0, 24, 20, 32, 32, BitOR($SS_NOTIFY, $WS_GROUP))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Edit1 = GUICtrlCreateEdit("", 5, 90, 190, 150, $ES_WANTRETURN + $ES_READONLY)
$hStatus = _GUICtrlStatusBar_Create($hGUI)

$hFloatBtn = GUICtrlCreateButton("Float!", 80, 5, 110, 30)
$hUnFloatBtn = GUICtrlCreateButton("Unfloat", 80, 40, 110, 25)

_GUICtrlStatusBar_SetText($hStatus, "v1.0    Made by misc314.com")

GUISetState()

GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE_FUNC")
GUIRegisterMsg($WM_LBUTTONUP, "WM_LBUTTONUP_FUNC")



While 1
   $Msg = GUIGetMsg()
   Switch $Msg

	  Case $hTargetPic
         $g_StartSearch = True
         DllCall("user32.dll", "hwnd", "SetCapture", "hwnd", $hGUI)
         $gOldCursor = DllCall("user32.dll", "int", "SetCursor", "int", $hTargetCursor)
		 If Not @error Then $gOldCursor = $gOldCursor[0]
		 GUICtrlSetImage($hTargetPic, $ICON_TARGET_EMPTY)

	  Case $hFloatBtn
		 WinSetOnTop($PHWND[0], "", $WINDOWS_ONTOP)
		 If Not @error Then
			_GUICtrlStatusBar_SetText($hStatus, "DONE: " & $PHWND[0] & " is floating!")
		 Else
			_GUICtrlStatusBar_SetText($hStatus, "Opps. Something isn't right.")
		 EndIf

	  Case $hUnFloatBtn
		 WinSetOnTop($PHWND[0], "", $WINDOWS_NOONTOP)
		 If Not @error Then
			_GUICtrlStatusBar_SetText($hStatus, "DONE: " & $PHWND[0] & " stops floating!")
		 Else
			_GUICtrlStatusBar_SetText($hStatus, "Opps. Something isn't right.")
		 EndIf

	  Case $GUI_EVENT_CLOSE
		 Exit
   EndSwitch

WEnd

$hWindow = $gFoundWindow
Global $aWinPos = WinGetPos($hWindow)

Func GetInfo($gFoundWindow)
    $Mouse = MouseGetPos()
    $mySpy = DllOpen("MySpy.dll")
    If ($mySpy < 0) Then
        ConsoleWrite("+++: $mySpy = " & $mySpy & @CRLF)
        Return
    EndIf

   Global $PHWND

    $PHWND = DllCall($mySpy, "hwnd", "AMG_GetPHWND", "long", $Mouse[0], "long", $Mouse[1])
    $hWnd = DllCall($mySpy, "hwnd", "AMG_GetHWND", "long", $Mouse[0], "long", $Mouse[1])
    $Classname = DllCall($mySpy, "str", "AMG_GetClassname", "long", $Mouse[0], "long", $Mouse[1])
    $ClassCount = DllCall($mySpy, "long", "AMG_GetClassCount", "long", $Mouse[0], "long", $Mouse[1])

    $WinTitle = DllCall($mySpy, "str", "AMG_GetWinTitle", "long", $Mouse[0], "long", $Mouse[1])
    ; $WinTitle = WinGetTitle($gFoundWindow)
    $WinText = DllCall($mySpy, "str", "AMG_GetWinText", "long", $Mouse[0], "long", $Mouse[1])
    ; $WinText = WinGetText($gFoundWindow)
    $WinClass = DllCall($mySpy, "str", "AMG_GetWinClass", "long", $Mouse[0], "long", $Mouse[1])
    DllClose($mySpy)
    $data = 'PHandle: ' & $PHWND[0] & @CRLF & 'Handle: ' & $hWnd[0] & @CRLF & 'Class: ' & $Classname[0] & @CRLF & 'Index: ' & $ClassCount[0] & @CRLF & 'Title: ' & $WinTitle[0] & @CRLF & 'Text: ' & $WinText[0] & @CRLF & 'Winclass: ' & $WinClass[0]
    GUICtrlSetData($Edit1, $data)

    _GUICtrlStatusBar_SetText($hStatus, $WinTitle[0])




EndFunc   ;==>GetInfo


Func WM_MOUSEMOVE_FUNC($hWnd, $nMsg, $wParam, $lParam)

    If Not $g_StartSearch Then Return 1
    Local $mPos = MouseGetPos()
    $hWndUnder = DllCall("user32.dll", "hwnd", "WindowFromPoint", "long", $mPos[0], "long", $mPos[1])
    If Not @error Then $hWndUnder = $hWndUnder[0]
    If _CheckFoundWindow($hWndUnder) Then

        ;GUICtrlSetData($hLabelTitle, WinGetTitle($hWndUnder))
        ;GUICtrlSetData($hLabelWnd, $hWndUnder)
        ;GUICtrlSetData($hLabelClass, _GetWindowClass($hWndUnder))
        $gFoundWindow = $hWndUnder
        GetInfo($gFoundWindow)
    EndIf
    Return 1
EndFunc   ;==>WM_MOUSEMOVE_FUNC

Func WM_LBUTTONUP_FUNC($hWnd, $nMsg, $wParam, $lParam)
    If Not $g_StartSearch Then Return 1
    $g_StartSearch = False
    ; Release captured cursor
    DllCall("user32.dll", "int", "ReleaseCapture")
    DllCall("user32.dll", "int", "SetCursor", "int", $gOldCursor)
    GUICtrlSetImage($hTargetPic, $ICON_TARGET_FULL)
    ;    MsgBox (0, "title", "text")
    ;msgbox(0,'',$WinTitle[0])
    Return 1
EndFunc   ;==>WM_LBUTTONUP_FUNC

Func _CheckFoundWindow($hFoundWnd)
    If $hFoundWnd = $hGUI Then Return False
    If $hFoundWnd = 0 Then Return False
    If $hFoundWnd = $gFoundWindow Then Return False
    If Not WinExists($hFoundWnd) Then Return False
    Local $hTemp = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hFoundWnd)
    If Not @error And $hTemp[0] = $hGUI Then Return False
    Return True
EndFunc   ;==>_CheckFoundWindow


;===============================================================================
; Write icons and cursor
;===============================================================================
Func _WriteResource($sbStringRes)
    Local $sTempFile
    Do
        $sTempFile = @TempDir & "\temp" & Hex(Random(0, 65535), 4)
    Until Not FileExists($sTempFile)
    Local $hFile = FileOpen($sTempFile, 2 + 16) ; overwrite + binary
    FileWrite($hFile, $sbStringRes)
    FileClose($hFile)
    Return $sTempFile
EndFunc   ;==>_WriteResource