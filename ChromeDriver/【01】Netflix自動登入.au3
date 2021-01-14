#cs
========================================================================================
---待新增功能---
●防止被辨識為機器人(待觀察)
●Chromedriver與主程式分開放，防止程式被盜用並取得帳密

●(Solved)關閉Chrome密碼管理員功能。chromeoption目前找不到此功能參數，改為使用profile方式，事先在chrome設定好將profile下的"Default"複製出來
●(Solved)netflix首頁的儲存密碼提示標成未打勾
●(Solved)隱藏WebDriver Console

●(未解決)登入畫面將顯示密碼功能隱藏 or remove
	1.登入畫面將顯示密碼功能隱藏不給按，hide element
	2.輸入帳密不顯示，但是有輸入的動作
========================================================================================
#ce

#include "wd_core.au3"
#include "wd_helper.au3"

Local $sDesiredCapabilities
;隱藏webdriver console
$_WD_DEBUG = $_WD_DEBUG_None

SetupChrome()
_WD_Startup()

;一定要在 _WD_Startup()函數後面，先啟動ChromeDriver再宣告 session
$sSession = _WD_CreateSession($sDesiredCapabilities)

_WD_Navigate($sSession,"https://www.netflix.com/tw/login")
_WD_LoadWait($sSession,2000)


;填入帳號
$sElementSelector = "//input[@name='userLoginId']"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'value', "0903661923")
Sleep(1000)

;隱藏"顯示密碼"按鈕(搭配Javascript)
_WD_ExecuteScript($sSession,"return document.getElementById('id_password_toggle').remove();","")

;填入密碼
$sElementSelector = "//input[@name='password']"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'value', "0216")

;netflix首頁的儲存密碼提示標成未打勾
$sElementSelector = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/div[3]/div/label"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'click')
;Sleep(5000)

;click"確定"進行登入動作
;Selector可使用Chrome的copy XPATH功能
$sElementSelector = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/button"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'click')

;模擬移動滑鼠，防止偵測機器人導致登入失敗(顯示密碼錯誤)

;將Chrome視窗最大化
_WD_Window($sSession, "Maximize")

;刪除Chrome Session，這會關掉瀏覽器
;_WD_DeleteSession($sSession)

;關閉 Webdriver Console
;_WD_Shutdown()

Func SetupChrome()
	_WD_Option('Driver','chromedriver.exe')
	_WD_Option('Port',9515)
	;_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\chrome.log"')    ;關掉Chrome.log功能
	;無痕模式
	;$sDesiredCapabilities = '{"capabilities":{"alwaysMatch":{"goog:chromeOptions":{"w3c":true,"args":["--incognito"],"binary":"D:\\GoogleChromePortable64\\App\\Chrome-bin\\chrome.exe","excludeSwitches":["enable-automation"],"useAutomationExtension":false}}}}'
	$sDesiredCapabilities = '{"capabilities":{"alwaysMatch":{"goog:chromeOptions":{"w3c":true,"args":["--user-data-dir=D:\\00Webdriver\\profile"],"binary":"D:\\GoogleChromePortable64\\App\\Chrome-bin\\chrome.exe","excludeSwitches":["enable-automation"],"useAutomationExtension":false}}}}'
EndFunc



