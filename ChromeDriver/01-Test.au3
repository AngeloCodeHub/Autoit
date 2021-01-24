
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
	'{"capabilities":' & _
		'{"alwaysMatch":' & _
			'{"goog:chromeOptions":' & _
				'{"w3c":true,' & _
				'"binary":"D:\\GoogleChromePortable64\\App\\Chrome-bin\\chrome.exe",' & _
				'"args":["--user-data-dir=D:\\00Test\\UserProfile"],' & _
				'"prefs":{"credentials_enable_service":false,"credentials_enable_autosignin":false,"profile":{"avatar_index":26,"content_settings":{"enable_quiet_permission_ui_enabling_method":{"notifications":1},"exceptions":{"accessibility_events":{},"app_banner":{},"ar":{},"auto_select_certificate":{},"automatic_downloads":{},"autoplay":{},"background_sync":{},"bluetooth_chooser_data":{},"bluetooth_guard":{},"bluetooth_scanning":{},"camera_pan_tilt_zoom":{},"client_hints":{},"clipboard":{},"cookies":{},"durable_storage":{},"file_system_last_picked_directory":{},"file_system_read_guard":{},"file_system_write_guard":{},"font_access":{},"geolocation":{},"hid_chooser_data":{},"hid_guard":{},"idle_detection":{},"images":{},"important_site_info":{},"insecure_private_network":{},"installed_web_app_metadata":{},"intent_picker_auto_display":{},"javascript":{},"legacy_cookie_access":{},"media_engagement":{},"media_stream_camera":{},"media_stream_mic":{},"midi_sysex":{},"mixed_script":{},"nfc":{},"notifications":{},"password_protection":{},"payment_handler":{},"permission_autoblocking_data":{},"permission_autorevocation_data":{},"popups":{},"ppapi_broker":{},"protocol_handler":{},"safe_browsing_url_check_data":{},"sensors":{},"serial_chooser_data":{},"serial_guard":{},"site_engagement":{},"sound":{},"ssl_cert_decisions":{},"storage_access":{},"subresource_filter":{},"subresource_filter_data":{},"usb_chooser_data":{},"usb_guard":{},"vr":{},"window_placement":{}},"pattern_pairs":{"https://*,*":{"media-stream":{"audio":"Default","video":"Default"}}},"pref_version":1},"creation_time":"13255982777883013","default_content_setting_values":{"geolocation":1,"notifications":2},"default_content_settings":{"geolocation":1,"mouselock":1,"notifications":1,"popups":1,"ppapi-broker":1},"exit_type":"Normal","exited_cleanly":true,"managed_user_id":"","name":"北半球 1","password_manager_enabled":false}},' & _
				'"excludeSwitches":["enable-automation"],"useAutomationExtension":false}}}}'
EndFunc


;,"--app=https://www.netflix.com/tw/login"
;'"prefs":{"credentials_enable_service":false,"credentials_enable_autosignin":false},' & _
