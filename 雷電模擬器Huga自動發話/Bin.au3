
#cs
雷電模擬器4.0.25
模擬器解析度要改平板(1600x900)
要先開啟聊天室視窗
無窮迴圈，需在右下角結束
Title：雷電模擬器
#ce

#include <FileConstants.au3>
$StringValue = FileReadLine(@WorkingDir & "\String.txt",1)

;控制碼要用中括號
WinActivate("[CLASS:LDPlayerMainFrame]","")
WinMove("[CLASS:LDPlayerMainFrame]","",1,1)

;以下ControlClick需要測試
;ControlClick("[CLASS:subWin;INSTANCE:1]","","","left",1,991,815)

For $i = 1 To 999999 Step 1
	MouseClick("left",800,815,1,60)
	Sleep(4 * 1000)	;等待X秒送出字串
	Send($StringValue,0)
	Sleep(3 * 1000)
	Send("{enter}",0)
	Send("{enter}",0)
	MouseClick("left",953,456,1,60)
	Sleep(15 * 1000)	;等待XX秒重新發話
	MouseClick("left",953,456,1,60)
Next




