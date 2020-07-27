
;判斷 Win10 build 為1809以上
@OSBuild >= "17763"

;測試訊息盒
#include <MsgBoxConstants.au3>
MsgBox(0,"測試",@ProgramsDir)

;mklink，使用mklink建立連結(注意是檔案or目錄)
RunWait(@ComSpec&" /c mklink /j "&@LocalAppDataDir&$LinkDir2&" "&@WorkingDir&"\AsureLData"&$LinkDir2)

;路徑有空白鍵值處理方式，如以下【外部另以雙引號框起來】
$LinkLink = @AppDataCommonDir & '"\Riot Games"'
$LinkDir2 = '"\LINE GAME"'

;Chrome啟動
$ChromeExe = "D:\Game\GoogleChrome\GoogleChromeWIN7\GoogleChromePortable.exe"

;匯入Registry
RunWait("reg import "&@WorkingDir&"\x64.reg")
