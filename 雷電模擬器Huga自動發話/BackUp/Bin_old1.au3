

#cs
	雷電模擬器4.0.25
	模擬器解析度要改平板(1600x900)
	要先開啟聊天室視窗
	無窮迴圈，需在右下角結束
	Title：雷電模擬器
#ce

#include <FileConstants.au3>
#include <GuiConstantsEx.au3>
#include <File.au3>

$StringValue = FileReadLine(@WorkingDir & "\String.txt", 1)
$StringValue2 = FileReadLine(@WorkingDir & "\String.txt", 2)

;大視窗(容器)
$hGUI = GUICreate("發話設定", 800, 200)

GUICtrlCreateLabel("發話文字：", 30, 20)
$inputConID1 = GUICtrlCreateInput($StringValue, 100, 20, 650)

GUICtrlCreateLabel("發話間隔：", 30, 50)
$inputConID2 = GUICtrlCreateInput($StringValue2, 100, 50, 50)
GUICtrlCreateLabel("分鐘", 160, 50)

$iOKButton = GUICtrlCreateButton("確定", 60, 130, 50, 30)
GUISetState(@SW_SHOW, $hGUI)

Local $iMsg = 0
While 1
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case $iOKButton
			$inputValue1 = GUICtrlRead($inputConID1)
			$inputValue2 = GUICtrlRead($inputConID2)
			_FileWriteToLine(@WorkingDir & "\String.txt",1,$inputValue1,True)
			_FileWriteToLine(@WorkingDir & "\String.txt",2,$inputValue2,True)
			ExitLoop
	EndSwitch
WEnd

GUIDelete($hGUI)


;控制碼要用中括號
WinActivate("[CLASS:LDPlayerMainFrame]", "")
WinMove("[CLASS:LDPlayerMainFrame]", "", 1, 1)

;以下ControlClick需要測試
;ControlClick("[CLASS:subWin;INSTANCE:1]","","","left",1,991,815)

;無限迴圈
While 1
	MouseClick("left", 800, 815, 1, 60)
	Sleep(4 * 1000) ;等待X秒送出字串
	Send($inputValue1, 0)
	Sleep(3 * 1000)
	Send("{enter}", 0)
	Send("{enter}", 0)
	MouseClick("left", 953, 456, 1, 60)
	Sleep($inputValue2 * 60 * 1000) ;等待XX秒重新發話
	MouseClick("left", 953, 456, 1, 60)
WEnd



#cs
For $i = 1 To 999999 Step 1
	MouseClick("left", 800, 815, 1, 60)
	Sleep(4 * 1000) ;等待X秒送出字串
	Send($StringValue, 0)
	Sleep(3 * 1000)
	Send("{enter}", 0)
	Send("{enter}", 0)
	MouseClick("left", 953, 456, 1, 60)
	Sleep(15 * 1000) ;等待XX秒重新發話
	MouseClick("left", 953, 456, 1, 60)
Next
#ce



