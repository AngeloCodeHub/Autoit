#cs
========================================================================================
--待新增功能--
●登入畫面將顯示密碼功能隱藏
●將Chrome的儲存密碼提示拿掉
●將Chrome的顯示通知拿掉(刪除Element)
●隱藏WebDriver Console
●防止被辨識為機器人
●Chromedriver與主程式分開放，防止程式被盜用並取得帳密

========================================================================================
#ce

#include "wd_core.au3"
#include "wd_helper.au3"

Local $sDesiredCapabilities

SetupChrome()
_WD_Startup()

;一定要在 _WD_Startup()函數後面，先啟動ChromeDriver再宣告 session
$sSession = _WD_CreateSession($sDesiredCapabilities)

_WD_Navigate($sSession, "https://www.netflix.com/tw/login")
_WD_LoadWait($sSession, 2000)

;填入帳號
$sElementSelector = "//input[@name='userLoginId']"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'value', "0903661923")
;Sleep(2000)

;填入密碼
$sElementSelector = "//input[@name='password']"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'value', "0216")
;Sleep(8000)

;click"確定"進行登入動作
;Selector可使用Chrome的copy XPATH功能
$sElementSelector = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/button"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'click')

;模擬移動滑鼠，防止偵測機器人導致登入失敗(顯示密碼錯誤)

;將Chrome視窗最大化
_WD_Window($sSession, "Maximize")

;_WD_DeleteSession($sSession) ;刪除Chrome Session，這會關掉瀏覽器
Sleep(60000)

;關掉 Webdriver Console
_WD_Shutdown()


Func SetupChrome()
	_WD_Option('Driver', 'chromedriver.exe')
	_WD_Option('Port', 9515)
	;_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\chrome.log"')    ;關掉Chrome.log功能
	$sDesiredCapabilities = '{"capabilities":{ _
			"alwaysMatch" : { _
			"goog:chromeOptions" : { _
			"w3c" : True, "binary" : "D:\\GoogleChromePortable64\\App\\Chrome-bin\\chrome.exe", _
			"excludeSwitches" :["enable-automation"], "useAutomationExtension" : false}}}}'
EndFunc   ;==>SetupChrome






