
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=121測試.Exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Language=1028
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

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

20210124
●以app模式開啟網站

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

_WD_Navigate($sSession,"")
_WD_LoadWait($sSession)


;填入帳號
$sElementSelector = "//input[@name='userLoginId']"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'value',"y3662756@gmail.com")
;Sleep(2000)

;刪除"顯示密碼"按鈕(搭配Javascript)
_WD_ExecuteScript($sSession,"return document.getElementById('id_password_toggle').remove();","")

;netflix首頁的儲存密碼提示標成未打勾
$sElementSelector = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/div[3]/div/label"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'click')

;填入密碼
$sElementSelector = "//input[@name='password']"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'value',"y0938627620")
Sleep(2000)

;click"確定"進行登入動作
;Selector可使用Chrome的copy XPATH功能
$sElementSelector = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/button"
$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
_WD_ElementAction($sSession, $sElement, 'click')

;將Chrome視窗最大化
_WD_Window($sSession, "Maximize")

;刪除Chrome Session，關掉瀏覽器
;_WD_DeleteSession($sSession)

;關閉 Webdriver Console
;_WD_Shutdown()

Func SetupChrome()
	_WD_Option('Driver','Z:\HonrayTools\chromedriver.exe')
	_WD_Option('Port',9515)
	;_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\chrome.log"')    ;關掉Chrome.log功能
	$sDesiredCapabilities = '{"capabilities":{"alwaysMatch":{"goog:chromeOptions":{"w3c":true,"binary":"D:\\Tool\\ChromeGreen\\App\\Chrome-bin\\chrome.exe","prefs":{"credentials_enable_service":false},"args":["--app=https://www.netflix.com/tw/login"],"excludeSwitches":["enable-automation"],"useAutomationExtension":false}}}}'
EndFunc



