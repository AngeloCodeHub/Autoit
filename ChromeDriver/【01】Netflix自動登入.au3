#include "wd_core.au3"
#include "wd_helper.au3"

_WD_Option('Driver', 'chromedriver.exe')
_WD_Option('Port', 9515)
_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\chrome.log"')

$sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true, "binary":"D:\\GoogleChromePortable64\\App\\Chrome-bin\\Chrome.exe" }}}}'

_WD_Startup()

$sSession = _WD_CreateSession($sDesiredCapabilities)

_WD_Navigate($sSession, "https://www.netflix.com/tw/login")
_WD_Window($sSession, "Maximize")

;ConsoleWrite("URL=" & _WD_Action($sSession, 'url') & @CRLF)
;_WD_Attach($sSession, "google.com", "URL")
;ConsoleWrite("URL=" & _WD_Action($sSession, 'url') & @CRLF)
;_WD_Attach($sSession, "yahoo.com", "URL")
;ConsoleWrite("URL=" & _WD_Action($sSession, 'url') & @CRLF)

;_WD_DeleteSession($sSession)
_WD_Shutdown()
