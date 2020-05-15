
#include <MsgBoxConstants.au3>

$DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")
$CDS_TEST = 0x00000002

MsgBox($MB_OK,"", @error)

$Test = DllCall("user32.dll", "int", "ChangeDisplaySettingsEx", _
"ptr", DllStructGetPtr($DEVMODE), _
"hwnd", 0, _
"dword", $CDS_TEST, _
"lparam", 0)

 MsgBox($MB_OK,"測試DLLCall", _
$Test[0] & @CRLF & _ ;這是註解
$Test[1] & @CRLF & _
$Test[2] & @CRLF & _
$Test[3] & @CRLF & _
$Test[4] & @CRLF & _
@error)




