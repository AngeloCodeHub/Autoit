
#include "wd_core.au3"
#include "wd_helper.au3"

Local $sDesiredCapabilities
;隱藏webdriver console
;$_WD_DEBUG = $_WD_DEBUG_None

SetupChrome()
_WD_Startup()

;一定要在 _WD_Startup()函數後面，先啟動ChromeDriver再宣告 session
$sSession = _WD_CreateSession($sDesiredCapabilities)

;https://www.netflix.com/tw/login
_WD_Navigate($sSession,"https://www.netflix.com/tw/login")

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
;_WD_ElementAction($sSession, $sElement, 'click')


;將Chrome視窗最大化
_WD_Window($sSession, "Maximize")

;刪除Chrome Session，關掉瀏覽器
;_WD_DeleteSession($sSession)

;關閉 Webdriver Console
;_WD_Shutdown()

Func SetupChrome()
	_WD_Option('Driver','F:\chromedriver.exe')
	_WD_Option('Port',9515)
	_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\chrome.log"')    ;關掉Chrome.log功能

	$sDesiredCapabilities = _
	'{"capabilities":{"alwaysMatch":{"goog:chromeOptions":{"w3c":true,"binary":"D:\\GoogleChromePortable64\\App\\Chrome-bin\\chrome.exe","args":["--user-data-dir=D:\\01Test\\UserProfile"],"prefs":{"credentials_enable_service":false,"credentials_enable_autosignin":false,"profile":{"avatar_index":26,"content_settings":{"enable_quiet_permission_ui_enabling_method":{"notifications":1},"pattern_pairs":{"https://*,*":{"media-stream":{"audio":"Default","video":"Default"}}},"pref_version":1},"default_content_setting_values":{"geolocation":1,"notifications":2},"default_content_settings":{"geolocation":1,"mouselock":1,"notifications":1,"popups":1,"ppapi-broker":1},"exit_type":"Normal","exited_cleanly":true,"managed_user_id":"","name":"北半球 1","password_manager_enabled":false}},"excludeSwitches":["enable-automation"],"useAutomationExtension":false}}}}'
EndFunc


;,"--app=https://www.netflix.com/tw/login"
;'"prefs":{"credentials_enable_service":false,"credentials_enable_autosignin":false},' & _
