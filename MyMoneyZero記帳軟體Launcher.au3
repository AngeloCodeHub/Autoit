
#cs
程式名稱：MyMoneyZero記帳軟體Launcher
檔案命名：MyMoneyLauncher.exe
		Config路徑.ini
程式用途：程式啟動器暨資料庫同步程式
		程式開啟自動從Dropbox複製資料庫至主程式目錄下,並於關閉時備份至Dropbox目錄
		不用手動自行備份"MyMoneyData.mdb"
版本控制：
作者名字：Angelo
使用說明：請將此程式放到帳務小管家目錄執行(ini檔也要)
#ce

#CS
改版紀錄

2018.5.28
-新增啟動小算盤
-將小算盤；DropBox；KeePassSave移至複製至本地資料庫後面
-以最高權限執行
-帳務管家輸入密碼視窗設定成視窗最上層

2018.5.29
-重複執行程式`,不會重複啟動小算盤
-取消記帳完畢的複製
-公司電腦"calc"莫名其妙不會啟動，改使用 runwait 方式

2018.6.5
-將啟動Dropbox提到最上,以防先前沒啟動過並複製到舊的資料庫

#CE

#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <AutoItConstants.au3>
#pragma compile (FileVersion,1.1.0.0)
#pragma compile (ProductVersion,1.1.0.0)
#pragma compile (FileDescription,記帳軟體Launcher)
#Region
#AutoIt3Wrapper_Res_Language=1028
#EndRegion

;Opt("TrayAutoPause",0)  ;禁止點TrayIcon自動停止Script
Opt("TrayMenuMode",1)

$DBFileName = "MyMoneyData.mdb"
$MoneyExeFileName = "帳務小管家Zero.exe"
$TimeToNow = @MON & @MDAY & @HOUR & @MIN & @SEC  ;時間一經引用就固定了,除非再執行一次

;路徑處理===========================================================================================
If FileExists("Config路徑.ini") Then
	$DropBoxPath = IniRead("Config路徑.ini","Path","DropBox","空值")
	$DropBoxExe = IniRead("Config路徑.ini","Path","ProgramDropBox","空值")
	$sKeepass = IniRead("Config路徑.ini","Path","keepass","空值")
Else
	MsgBox(48,"警告","[Config路徑.ini]不存在")
	Exit
EndIf
$DropBoxDBFilePath = $DropBoxPath & $DBFileName
;路徑處理=============================================================================================

;啟動DropBox主程式
If Not ProcessExists("Dropbox.exe") Then
	MsgBox(16,"警告","DropBox沒啟動,請確認資料庫已經先同步過一次喔!!!")
	Run($DropBoxExe)
	Exit
EndIf

If FileCopy($DropBoxDBFilePath,@WorkingDir & "\" & $DBFileName,1) Then ;判斷的同時也會複製
	FileCopy(@WorkingDir & "\" & $DBFileName,$DropBoxPath & "MyMoneyData_" & $TimeToNow & ".mdb",1)
	;啟動keepass主程式
	If Not ProcessExists("KeePass.exe") Then
		Run($sKeepass)
	EndIf

	;啟動小算盤
	If ProcessExists("Calculator.exe") Then
		ProcessClose("Calculator.exe")
	EndIf
	Run("calc")

	;If(RunWait(@WorkingDir & "\"  & $MoneyExeFileName)) Then
	;	WinSetOnTop("帳本密碼登入","帳本密碼登入",1)
	;EndIf
	Run(@WorkingDir & "\"  & $MoneyExeFileName)
	WinWait("帳本密碼登入")
	WinSetOnTop("帳本密碼登入","帳本密碼登入",1)
	WinWaitClose("[Class:WindowsForms10.Window.8.app.0.378734a]")

Else
	MsgBox(48,"警告","資料庫複製至本地有誤")
	Exit
EndIf

If FileCopy(@WorkingDir & "\" & $DBFileName,$DropBoxDBFilePath,1) Then
	Exit
Else
	MsgBox(48,"警告","資料庫複製至雲端有誤")
EndIf

