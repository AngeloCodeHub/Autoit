Global Const $0 = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $1 = _1g()
Func _1e(ByRef $2, $3 = 100)
Select
Case UBound($2, 2)
If $3 < 0 Then
ReDim $2[$2[0][0] + 1][UBound($2, 2)]
Else
$2[0][0] += 1
If $2[0][0] > UBound($2) - 1 Then
ReDim $2[$2[0][0] + $3][UBound($2, 2)]
EndIf
EndIf
Case UBound($2, 1)
If $3 < 0 Then
ReDim $2[$2[0] + 1]
Else
$2[0] += 1
If $2[0] > UBound($2) - 1 Then
ReDim $2[$2[0] + $3]
EndIf
EndIf
Case Else
Return 0
EndSelect
Return 1
EndFunc
Func _1g()
Local $4 = DllStructCreate($0)
DllStructSetData($4, 1, DllStructGetSize($4))
Local $5 = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $4)
If @error Or Not $5[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($4, 2), -8), DllStructGetData($4, 3))
EndFunc
Global Const $6 = 'dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]'
Func _45($7 = 0)
If Not $7 Then $7 = @AutoItPID
Local $8 = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
If @error Or($8[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0)
Local $9 = DllStructCreate($6)
Local $a[101][2] = [[0]]
$8 = $8[0]
DllStructSetData($9, 'Size', DllStructGetSize($9))
Local $5 = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $8, 'struct*', $9)
Local $b = @error
While(Not @error) And($5[0])
If DllStructGetData($9, 'ParentProcessID') = $7 Then
_1e($a)
$a[$a[0][0]][0] = DllStructGetData($9, 'ProcessID')
$a[$a[0][0]][1] = DllStructGetData($9, 'ExeFile')
EndIf
$5 = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $8, 'struct*', $9)
$b = @error
WEnd
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $8)
If Not $a[0][0] Then Return SetError($b + 20, 0, 0)
_1e($a, -1)
Return $a
EndFunc
Global $c = DllOpen('kernel32.dll')
Global $d = DllOpen('msvcrt.dll')
Global $e = ""
Func _5r($f, $g)
Local $h = DllCall($c, 'ptr', 'GetProcAddress', 'ptr', $f, 'str', $g)
If @Error Or Not $h[0] Then Return SetError(1, @Error, 0)
Return $h[0]
EndFunc
Func _5s($i)
Local $h = DllCall($c, "handle", "LoadLibraryW", "wstr", $i)
If @Error Then Return SetError(1, @Error, 0)
Return $h[0]
EndFunc
Func _5t($j)
Local $h = DllCall($c, "int", "lstrlenA", "ptr", $j)
If @Error Then Return SetError(1, @Error, 0)
Return $h[0]
EndFunc
Func _5u($k, $l = 0)
Local $m = BinaryLen($k) + $l
Local $h = DllCall($c, "ptr", "VirtualAlloc", "ptr", 0, "ulong_ptr", $m, "dword", 0x1000, "dword", 0x40)
If @Error Or Not $h[0] Then Return SetError(1, @Error, 0)
If BinaryLen($k) Then
Local $n = DllStructCreate("byte[" & $m & "]", $h[0])
DllStructSetData($n, 1, $k)
EndIf
Return $h[0]
EndFunc
Func _5v($j)
Local $n = DllStructCreate("ptr;ptr;dword;uint_ptr;dword;dword;dword")
Local $h = DllCall($c, "int", "VirtualQuery", "ptr", $j, "ptr", DllStructGetPtr($n), "uint_ptr", DllStructGetSize($n))
If @Error Or $h[0] = 0 Then Return SetError(1, @Error, 0)
Return DllStructGetData($n, 4)
EndFunc
Func _5w($j)
Local $h = DllCall($c, "bool", "VirtualFree", "ptr", $j, "ulong_ptr", 0, "dword", 0x8000)
If @Error Or $h[0] = 0 Then
$h = DllCall($c, "bool", "GlobalFree", "ptr", $j)
If @Error Or $h[0] <> 0 Then Return SetError(1, @Error, False)
EndIf
Return True
EndFunc
Func _5y($j, $m, $o)
Static $p
If Not $p Then
If @AutoItX64 Then
$p = _67('0x4883EC084D85C94889C8742C4C39CA72254C29CA488D141131C9EB0848FFC14C39C97414448A1408453A140874EE48FFC04839D076E231C05AC3', '', 0, True, False)
Else
$p = _67('0x5589E58B4D14578B4508568B550C538B7D1085C9742139CA721B29CA8D341031D2EB054239CA740F8A1C17381C1074F34039F076EA31C05B5E5F5DC3', '', 0, True, False)
EndIf
If Not $p Then Return SetError(1, 0, 0)
EndIf
$o = Binary($o)
Local $n = DllStructCreate("byte[" & BinaryLen($o) & "]")
DllStructSetData($n, 1, $o)
Local $h = DllCallAddress("ptr:cdecl", $p, "ptr", $j, "uint", $m, "ptr", DllStructGetPtr($n), "uint", DllStructGetSize($n))
Return $h[0]
EndFunc
Func _5z($q)
Static $p
If Not $p Then
If @AutoItX64 Then
$p = _67('0x41544989CAB9FF000000555756E8BE000000534881EC000100004889E7F3A44C89D6E98A0000004439C87E0731C0E98D0000000FB66E01440FB626FFC00FB65E020FB62C2C460FB62424408A3C1C0FB65E034189EB41C1E4024183E3308A1C1C41C1FB044509E34080FF634189CC45881C08744C440FB6DFC1E5044489DF4088E883E73CC1FF0209C7418D44240241887C08014883C10380FB63742488D841C1E3064883C60483E03F4409D841884408FF89F389C84429D339D30F8C67FFFFFF4881C4000100005B5E5F5D415CC35EC3E8F9FFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000000000000003E0000003F3435363738393A3B3C3D00000063000000000102030405060708090A0B0C0D0E0F101112131415161718190000000000001A1B1C1D1E1F202122232425262728292A2B2C2D2E2F30313233', '', 132, True, False)
Else
$p = _67('0x55B9FF00000089E531C05756E8F10000005381EC0C0100008B55088DBDF5FEFFFFF3A4E9C00000003B45140F8FC20000000FB65C0A028A9C1DF5FEFFFF889DF3FEFFFF0FB65C0A038A9C1DF5FEFFFF889DF2FEFFFF0FB65C0A018985E8FEFFFF0FB69C1DF5FEFFFF899DECFEFFFF0FB63C0A89DE83E630C1FE040FB6BC3DF5FEFFFFC1E70209FE8B7D1089F3881C074080BDF3FEFFFF63745C0FB6B5F3FEFFFF8BBDECFEFFFF8B9DE8FEFFFF89F083E03CC1E704C1F80209F88B7D1088441F0189D883C00280BDF2FEFFFF6374278A85F2FEFFFFC1E60683C10483E03F09F088441F0289D883C0033B4D0C0F8C37FFFFFFEB0231C081C40C0100005B5E5F5DC35EC3E8F9FFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000000000000003E0000003F3435363738393A3B3C3D00000063000000000102030405060708090A0B0C0D0E0F101112131415161718190000000000001A1B1C1D1E1F202122232425262728292A2B2C2D2E2F30313233', '', 132, True, False)
EndIf
If Not $p Then Return SetError(1, 0, Binary(""))
EndIf
$q = String($q)
Local $r = StringLen($q)
Local $s = DllStructCreate("char[" & $r & "]")
DllStructSetData($s, 1, $q)
Local $t = Int(($r + 2) / 4) * 3 + 1
Local $u = DllStructCreate("byte[" & $t & "]")
Local $h = DllCallAddress("uint:cdecl", $p, "ptr", DllStructGetPtr($s), "uint", $r, "ptr", DllStructGetPtr($u), "uint", $t)
If $h[0] = 0 Then Return SetError(2, 0, Binary(""))
Return BinaryMid(DllStructGetData($u, 1), 1, $h[0])
EndFunc
Func _61($q)
Static $p
If Not $p Then
If @AutoItX64 Then
$p = _67(_5z('QVcxwEFWQVVBVFVXSInXVkiJzlMx20iB7OgAAABEiiFBgPzgdgnpyQAAAEGD7C1BiMf/wEGA/Cx38THA6wRBg+wJQYjG/8BBgPwId/GLRglEi24FQQ+2zkyJRCQoRQ+2/0HB5xBBiQFBD7bEAcG4AAMAANPgjYQAcA4AAEhjyOjIBAAATInpSInF6L0EAABIicMxwEyJ8kSI4EyLRCQoiNQl//8A/0QJ+EiF24lFAHQoTYXtdCNIjVfzSI1MJDhIg8YNTIkEJE2J6UmJ2EiJ7+g2AAAAicbrBb4BAAAASInp6IQEAACF9nQKSInZMdvodgQAAEiJ2EiBxOgAAABbXl9dQVxBXUFeQV/DVVNBV0FWQVVBVEFQTQHBQVFNicVRVkgB8lJIieX8SYn0iwdMjX8Eik8Cg8r/0+L30olV6Ijhg8r/0+L30olV5ADBiUXsuAEAAACJReCJRdyJRdhIiUXQRSnJKfaDy/8A0bgAAwAA0+BIjYg2BwAAuAAEAARMif/R6fOrvwUAAADoUAMAAP/PdfdEie9EicgrfSDB4ARBifpEI1XoRAHQTY0cR+hAAwAAD4WTAAAAik3sI33k0+eA6Qj22dPuAfe4AQAAAEiNPH++AAEAAMHnCEGD+QdNjbR/bA4AAHI0TInvSCt90A+2P9HnQYnzIf5BAfNPjRxe6O8CAACJwcHuCIPhATnOvgABAAB1DjnGd9jrDE2J8+jQAgAAOfBy9EyJ76pEiclBg/kEcg65AwAAAEGD+QpyA4PBA0EpyelDAgAAT42cT4ABAADomgIAAHUsi0XcQYP5B4lF4BnAi1XY99CLTdCD4AOJVdxBicGJTdhNjbdkBgAA6akAAABPjZxPmAEAAOhfAgAAdUZEicjB4AREAdBNjZxH4AEAAOhHAgAAdWpBg/kHuQkAAAByA4PBAkGJyUyJ70grfdBIO30gD4L9AQAAigdIA33QqumzAQAAT42cT7ABAADoCgIAAIt12HQhT42cT8gBAADo+AEAAIt13HQJi03ci3XgiU3gi03YiU3ci03QiU3YiXXQQYP5B7kIAAAAcgODwQNBiclNjbdoCgAATYnz6LsBAAB1FESJ0CnJweADvggAAABJjXxGBOs2TY1eAuicAQAAdRpEidC5CAAAAMHgA74IAAAASY28RgQBAADrEUmNvgQCAAC5EAAAAL4AAQAAiU3MuAEAAABJifvoYQEAAInCKfJy8gNVzEGD+QSJVcwPg7kAAABBg8EHuQMAAAA50XICidHB4Qa4AQAAAEmNvE9gAwAAvkAAAABJifvoHwEAAEGJwkEp8nLwQYP6BHJ4RInWRIlV0NHug2XQAf/Og03QAkGD+g5zFYnx0mXQi0XQRCnQTY20R14FAADrLIPuBOi6AAAA0evRZdBBOdhyBv9F0EEp2P/OdedNjbdEBgAAwWXQBL4EAAAAvwEAAACJ+E2J8+ioAAAAqAF0Awl90NHn/8516+sERIlV0P9F0EyJ74tNzEiJ+IPBAkgrRSBIOUXQd1RIif5IK3XQSItVGKyqSDnXcwT/yXX1SYn9D7bwTDttGA+C9fz//+gwAAAAKcBIi1UQTCtlCESJIkiLVWBMK20gRIkqSIPEKEFcQV1BXUFfW13DXli4AQAAAOvSgfsAAAABcgHDweMITDtlAHPmQcHgCEWKBCRJg8QBwynATY0cQ4H7AAAAAXMVweMITDtlAHPBQcHgCEWKBCRJg8QBidlBD7cTwekLD6/KQTnIcxOJy7kACAAAKdHB6QVmQQELAcDDKcvB6gVBKchmQSkTAcCDwAHDSLj////////////gbXN2Y3J0LmRsbHxtYWxsb2MASLj////////////gZnJlZQA='))
Else
$p = _67(_5z('VYnlVzH/VlOD7EyLXQiKC4D54A+HxQAAADHA6wWD6S2I0ID5LI1QAXfziEXmMcDrBYPpCYjQgPkIjVABd/OIReWLRRSITeSLUwkPtsmLcwWJEA+2ReUBwbgAAwAA0+CNhABwDgAAiQQk6EcEAACJNCSJRdToPAQAAItV1InHi0Xkhf+JArgBAAAAdDaF9nQyi0UQg8MNiRQkiXQkFIl8JBCJRCQYjUXgiUQkDItFDIlcJASD6A2JRCQI6CkAAACLVdSJRdSJFCToAQQAAItF1IXAdAqJPCQx/+jwAwAAg8RMifhbXl9dw1dWU1WJ5YtFJAFFKFD8i3UYAXUcVot1FK2SUopO/oPI/9Pg99BQiPGDyP/T4PfQUADRifeD7AwpwEBQUFBQUFcp9laDy/+4AAMAANPgjYg2BwAAuAAEAATR6fOragVZ6MoCAADi+Yt9/ItF8Ct9JCH4iUXosADoywIAAA+FhQAAAIpN9CN97NPngOkI9tnT7lgB916NPH/B5wg8B1qNjH5sDgAAUVa+AAEAAFCwAXI0i338K33cD7Y/i23M0eeJ8SH+AfGNbE0A6JgCAACJwcHuCIPhATnOvgABAAB1DjnwctfrDIttzOh5AgAAOfBy9FqD+gSJ0XIJg/oKsQNyArEGKcpS60mwwOhJAgAAdRRYX1pZWln/NCRRUrpkBgAAsQDrb7DM6CwCAAB1LLDw6BMCAAB1U1g8B7AJcgKwC1CLdfwrddw7dSQPgs8BAACsi338qumOAQAAsNjo9wEAAIt12HQbsOTo6wEAAIt11HQJi3XQi03UiU3Qi03YiU3Ui03ciU3YiXXcWF9ZumgKAACxCAH6Ulc8B4jIcgIEA1CLbczovAEAAHUUi0Xoi33MweADKclqCF6NfEcE6zWLbcyDxQLomwEAAHUYi0Xoi33MweADaghZaghejbxHBAEAAOsQvwQCAAADfcxqEFm+AAEAAIlN5CnAQIn96GYBAACJwSnxcvMBTeSDfcQED4OwAAAAg0XEB4tN5IP5BHIDagNZi33IweEGKcBAakBejbxPYAMAAIn96CoBAACJwSnxcvOJTeiJTdyD+QRyc4nOg2XcAdHug03cAk6D+Q5zGbivAgAAKciJ8dJl3ANF3NHgA0XIiUXM6y2D7gToowAAANHr0WXcOV3gcgb/RdwpXeBOdei4RAYAAANFyIlFzMFl3ARqBF4p/0eJ+IttzOi0AAAAqAF0Awl93NHnTnXs6wD/RdyLTeSDwQKLffyJ+CtFJDlF3HdIif4rddyLVSisqjnXcwNJdfeJffwPtvA7fSgPgnH9///oKAAAACnAjWwkPItVIIt1+Ct1GIkyi1Usi338K30kiTrJW15fw15YKcBA69qB+wAAAAFyAcPB4whWi3X4O3Ucc+SLReDB4AisiUXgiXX4XsOLTcQPtsDB4QQDRegByOsGD7bAA0XEi23IjWxFACnAjWxFAIH7AAAAAXMci0wkOMFkJCAIO0wkXHOcihH/RCQ4weMIiFQkIInZD7dVAMHpCw+vyjlMJCBzF4nLuQAIAAAp0cHpBWYBTQABwI1sJEDDweoFKUwkICnLZilVAAHAg8ABjWwkQMO4///////gbXN2Y3J0LmRsbHxtYWxsb2MAuP//////4GZyZWUA'))
EndIf
If Not $p Then Return SetError(1, 0, Binary(""))
EndIf
$q = Binary($q)
Local $r = BinaryLen($q)
Local $s = DllStructCreate("byte[" & $r & "]")
DllStructSetData($s, 1, $q)
Local $h = DllCallAddress("ptr:cdecl", $p, "ptr", DllStructGetPtr($s), "uint_ptr", $r, "uint_ptr*", 0, "uint*", 0)
If $h[0] Then
Local $u = DllStructCreate("byte[" & $h[3] & "]", $h[0])
Local $v = DllStructGetData($u, 1)
DllCall($d, "none:cdecl", "free", "ptr", $h[0])
Return $v
EndIf
Return SetError(2, 0, Binary(""))
EndFunc
Func _62($w, $x)
Local $y = Int(BinaryMid($x, 1, 2))
For $0z = 3 To BinaryLen($x) Step $y
Local $10 = Int(BinaryMid($x, $0z, $y))
Local $j = $w + $10
DllStructSetData(DllStructCreate("ptr", $j), 1, DllStructGetData(DllStructCreate("ptr", $j), 1) + $w)
Next
EndFunc
Func _63($w, $m)
Local $11, $12, $13, $14, $15
If @AutoItX64 Then
$11 = Binary("0x48B8FFFFFFFFFFFFFFFFFFE0")
$12 = 2
Else
$11 = Binary("0xB8FFFFFFFFFFE0")
$12 = 1
EndIf
$13 = BinaryLen($11)
Do
Local $j = _5y($w, $m, $11)
If $j = 0 Then ExitLoop
Local $16 = $j + $13
Local $17 = _5t($16)
Local $18 = DllStructGetData(DllStructCreate("char[" & $17 & "]", $16), 1)
Local $19 = StringSplit($18, "|")
If $19[0] = 1 Then
$15 = $19[1]
ElseIf $19[0] = 2 Then
If $19[1] Then $14 = $19[1]
$15 = $19[2]
EndIf
If $14 And $15 Then
Local $1a = _5s($14)
If Not $1a Then
$e = "LoadLibrary fail on " & $14
Return SetError(1, 0, False)
EndIf
Local $g = _5r($1a, $15)
If Not $g Then
$e = "GetProcAddress failed on " & $15
Return SetError(2, 0, False)
EndIf
DllStructSetData(DllStructCreate("ptr", $j + $12), 1, $g)
EndIf
Local $1b = Int($j - $w + $13 + $17 + 1)
$w += $1b
$m -= $1b
Until $m <= $13
Return True
EndFunc
Func _64($k)
If Not $k Then Return ""
If IsBinary($k) Then Return $k
$k = String($k)
If StringLeft($k, 2) = "0x" Then Return Binary($k)
If StringIsXDigit($k) Then Return Binary("0x" & $k)
Return _61(_5z($k))
EndFunc
Func _65($p, $1c, $m = Default)
$1c = Binary($1c)
If IsKeyword($m) Then
$m = _5v($p)
EndIf
Local $j = _5y($p, $m, $1c)
If $j = 0 Then Return SetError(1, 0, 0)
Return $j + BinaryLen($1c)
EndFunc
Func _66($p, $1d)
If Not IsArray($1d) Or $p = 0 Then Return SetError(1, 0, 0)
Local $1e = ""
For $0z = 0 To UBound($1d) - 1
$1e &= "ptr " & $1d[$0z] & ";"
Next
Local $1f = DllStructCreate($1e)
If @Error Then Return SetError(1, 0, 0)
For $0z = 0 To UBound($1d) - 1
$p = _65($p, $1d[$0z])
DllStructSetData($1f, $1d[$0z], $p)
Next
Return $1f
EndFunc
Func _67($k, $x = '', $l = 0, $1g = True, $1h = True)
Local $1i = _64($k)
If Not $1i Then Return SetError(1, 0, 0)
Local $1j = BinaryLen($1i)
Local $1k = $1j + $l
Local $p = _5u($1i, $l)
If Not $p Then Return SetError(2, 0, 0)
If $x Then
$x = _64($x)
If Not $x Then Return SetError(3, 0, 0)
_62($p, $x)
EndIf
If $1h Then
If Not _63($p, $1j) Then
_5w($p)
Return SetError(4, 0, 0)
EndIf
EndIf
If $1g Then
_6d($p)
EndIf
Return SetError(0, $1k, $p)
EndFunc
Func _6d($j)
OnAutoItExitRegister('_6e')
_6f($j)
EndFunc
Func _6e()
_6f()
EndFunc
Func _6f($j = Default)
Static $1l
If @NumParams = 0 Then
If IsArray($1l) Then
For $0z = 1 To $1l[0]
_5w($1l[$0z])
Next
EndIf
Else
If Not IsArray($1l) Then
Local $1m[1] = [0]
$1l = $1m
EndIf
If IsPtr($j) Then
Local $1n = $1l
Local $y = UBound($1n)
ReDim $1n[$y + 1]
$1n[$y] = $j
$1n[0] += 1
$1l = $1n
EndIf
EndIf
EndFunc
Func _6g($15 = "")
Static $1f
If Not IsDllStruct($1f) Then
Local $k
If @AutoItX64 Then
$k = 'AwAAAAQfCAAAAAAAAAA1HbEvgTNrvX54gCiWSTVmt5v7RCdoFJ/zhkKmwcm8yVqZPjJBoVhNHHAIzrHWKbZh1J0QAUaHB5zyQTilTmWa9O0OKeLrk/Jg+o7CmMzjEk74uPongdHv37nwYXvg97fiHvjP2bBzI9gxSkKq9Cqh/GxSHIlZPYyW76pXUt//25Aqs2Icfpyay/NFd50rW7eMliH5ynkrp16HM1afithVrO+LpSaz/IojowApmXnBHUncHliDqbkx6/AODUkyDm1hj+AiEZ9Me1Jy+hBQ1/wC/YnuuYSJvNAKp6XDnyc8Nwr54Uqx5SbUW2CezwQQ7aXX/HFiHSKpQcFW/gi8oSx5nsoxUXVjxeNI/L7z6GF2mfu3Tnpt7hliWEdA2r2VB+TIM7Pgwl9X3Ge0T3KJQUaRtLJZcPvVtOuKXr2Q9wy7hl80hVRrt9zYrbjBHXLrRx/HeIMkZwxhmKo/dD/vvaNgE+BdU8eeJqFBJK2alrK2rh2WkRynftyepm1WrdKrz/5KhQPp/4PqH+9IADDjoGBbfvJQXdT+yiO8DtfrVnd+JOEKsKEsdgeM3UXx5r6tEHO9rYWbzbnyEiX7WozZemry+vBZMMtHn1aA63+RcDQED73xOsnj00/9E5Z6hszM5Hi8vi6Hw3iOgf3cHwcXG44aau0JpuA2DlrUvnJOYkNnY+bECeSdAR1UQkFNyqRoH2xm4Y7gYMCPsFtPBlwwleEKI27SsUq1ZHVQvFCoef7DXgf/GwPCAvwDMIQfb3hJtIVubOkASRQZVNIJ/y4KPrn/gcASV7fvMjE34loltTVlyqprUWxpI51tN6vhTOLAp+CHseKxWaf9g1wdbVs0e/5xAiqgJbmKNi9OYbhV/blpp3SL63XKxGiHdxhK1aR+4rUY4eckNbaHfW7ob+q7aBoHSs6LVX9lWakb/xWxwQdwcX/7/C+TcQSOOg6rLoWZ8wur9qp+QwzoCbXkf04OYpvD5kqgEiwQnB90kLtcA+2XSbDRu+aq02eNNCzgkZujeL/HjVISjf2EuQKSsZkBhS15eiXoRgPaUoQ5586VS7t7rhM8ng5LiVzoUQIZ0pNKxWWqD+gXRBvOMIXY2yd0Ei4sE5KFIEhbs3u8vwP7nFLIpZ/RembPTuc0ZlguGJgJ2F5iApfia+C2tRYRNjVCqECCveWw6P2Btfaq9gw7cWWmJflIQbjxtccDqsn52cftLqXSna9zk05mYdJSV8z2W7vM1YJ5Rd82v0j3kau710A/kQrN41bdaxmKjL+gvSRlOLB1bpvkCtf9+h+eVA4XIkIXKFydr1OjMZ8wq2FIxPJXskAe4YMgwQmeWZXMK1KBbLB3yQR1YOYaaHk1fNea9KsXgs5YLbiP/noAusz76oEDo/DJh1aw7cUwdhboVPg1bNq88mRb5RGa13KDK9uEET7OA02KbSL+Q4HOtyasLUoVrZzVyd8iZPoGrV36vHnj+yvG4fq6F/fkug/sBRp186yVZQVmdAgFd+WiRLnUjxHUKJ6xBbpt4FTP42E/PzPw3JlDb0UQtXTDnIL0CWqbns2E7rZ5PBwrwQYwvBn/gaEeLVGDSh84DfW4zknIneGnYDXdVEHC+ITzejAnNxb1duB+w2aVTk64iXsKHETq53GMH6DuFi0oUeEFb/xp0HsRyNC8vBjOq3Kk7NZHxCQLh7UATFttG7sH+VIqGjjNwmraGJ0C92XhpQwSgfAb3KHucCHGTTti0sn6cgS3vb36BkjGKsRhXVuoQCFH96bvTYtl8paQQW9ufRfvxPqmU0sALdR0fIvZwd7Z8z0UoEec6b1Sul4e60REj/H4scb6N2ryHBR9ua5N1YxJu1uwgoLXUL2wT9ZPBjPjySUzeqXikUIKKYgNlWy+VlNIiWWTPtKpCTr508logA=='
Else
$k = 'AwAAAASFBwAAAAAAAAA1HbEvgTNrvX54gCiqsa1mt5v7RCdoAFjCfVE40DZbE5UfabA9UKuHrjqOMbvjSoB2zBJTEYEQejBREnPrXL3VwpVOW+L9SSfo0rTfA8U2W+Veqo1uy0dOsPhl7vAHbBHrvJNfEUe8TT0q2eaTX2LeWpyrFEm4I3mhDJY/E9cpWf0A78e+y4c7NxewvcVvAakIHE8Xb8fgtqCTVQj3Q1eso7n1fKQj5YsQ20A86Gy9fz8dky78raeZnhYayn0b1riSUKxGVnWja2i02OvAVM3tCCvXwcbSkHTRjuIAbMu2mXF1UpKci3i/GzPmbxo9n/3aX/jpR6UvxMZuaEDEij4yzfZv7EyK9WCNBXxMmtTp3Uv6MZsK+nopXO3C0xFzZA/zQObwP3zhJ4sdatzMhFi9GAM70R4kgMzsxQDNArueXj+UFzbCCFZ89zXs22F7Ixi0FyFTk3jhH56dBaN65S+gtPztNGzEUmtk4M8IanhQSw8xCXr0x0MPDpDFDZs3aN5TtTPYmyk3psk7OrmofCQGG5cRcqEt9902qtxQDOHumfuCPMvU+oMjzLzBVEDnBbj+tY3y1jvgGbmEJguAgfB04tSeAt/2618ksnJJK+dbBkDLxjB4xrFr3uIFFadJQWUckl5vfh4MVXbsFA1hG49lqWDa7uSuPCnOhv8Yql376I4U4gfcF8LcgorkxS+64urv2nMUq6AkBEMQ8bdkI64oKLFfO7fGxh5iMNZuLoutDn2ll3nq4rPi4kOyAtfhW0UPyjvqNtXJ/h0Wik5Mi8z7BVxaURTDk81TP8y9+tzjySB/uGfHFAzjF8DUY1vqJCgn0GQ8ANtiiElX/+Wnc9HWi2bEEXItbm4yv97QrEPvJG9nPRBKWGiAQsIA5J+WryX5NrfEfRPk0QQwyl16lpHlw6l0UMuk7S21xjQgyWo0MywfzoBWW7+t4HH9sqavvP4dYAw81BxXqVHQhefUOS23en4bFUPWE98pAN6bul+kS767vDK34yTC3lA2a8wLrBEilmFhdB74fxbAl+db91PivhwF/CR4Igxr35uLdof7+jAYyACopQzmsbHpvAAwT2lapLix8H03nztAC3fBqFSPBVdIv12lsrrDw4dfhJEzq7AbL/Y7L/nIcBsQ/3UyVnZk4kZP1KzyPCBLLIQNpCVgOLJzQuyaQ6k2QCBy0eJ0ppUyfp54LjwVg0X7bwncYbAomG4ZcFwTQnC2AX3oYG5n6Bz4SLLjxrFsY+v/SVa+GqH8uePBh1TPkHVNmzjXXymEf5jROlnd+EjfQdRyitkjPrg2HiQxxDcVhCh5J2L5+6CY9eIaYgrbd8zJnzAD8KnowHwh2bi4JLgmt7ktJ1XGizox7cWf3/Dod56KAcaIrSVw9XzYybdJCf0YRA6yrwPWXbwnzc/4+UDkmegi+AoCEMoue+cC7vnYVdmlbq/YLE/DWJX383oz2Ryq8anFrZ8jYvdoh8WI+dIugYL2SwRjmBoSwn56XIaot/QpMo3pYJIa4o8aZIZrjvB7BXO5aCDeMuZdUMT6AXGAGF1AeAWxFd2XIo1coR+OplMNDuYia8YAtnSTJ9JwGYWi2dJz3xrxsTQpBONf3yn8LVf8eH+o5eXc7lzCtHlDB+YyI8V9PyMsUPOeyvpB3rr9fDfNy263Zx33zTi5jldgP2OetUqGfbwl+0+zNYnrg64bluyIN/Awt1doDCQkCKpKXxuPaem/SyCHrKjg'
EndIf
Local $1d[] = ["jsmn_parse", "jsmn_init", "json_string_decode", "json_string_encode"]
Local $p = _67($k)
If @error Then Exit MsgBox(16, "Json", "Startup Failure!")
$1f = _66($p, $1d)
If @error Then Exit MsgBox(16, "Json", "Startup Failure!")
EndIf
If $15 Then Return DllStructGetData($1f, $15)
EndFunc
Func _6h($18, $1o = 0)
Static $1p = _6g("json_string_encode")
Local $m = StringLen($18) * 6 + 1
Local $n = DllStructCreate("wchar[" & $m & "]")
Local $h = DllCallAddress("int:cdecl", $1p, "wstr", $18, "ptr", DllStructGetPtr($n), "uint", $m, "int", $1o)
Return SetError($h[0], 0, DllStructGetData($n, 1))
EndFunc
Func _6i($18)
Static $1q = _6g("json_string_decode")
Local $m = StringLen($18) + 1
Local $n = DllStructCreate("wchar[" & $m & "]")
Local $h = DllCallAddress("int:cdecl", $1q, "wstr", $18, "ptr", DllStructGetPtr($n), "uint", $m)
Return SetError($h[0], 0, DllStructGetData($n, 1))
EndFunc
Func _6j($1r, $1s = 1000)
Static $1t = _6g("jsmn_init"), $1u = _6g("jsmn_parse")
If $1r = "" Then $1r = '""'
Local $1v, $h
Local $1w = DllStructCreate("uint pos;int toknext;int toksuper")
Do
DllCallAddress("none:cdecl", $1t, "ptr", DllStructGetPtr($1w))
$1v = DllStructCreate("byte[" &($1s * 20) & "]")
$h = DllCallAddress("int:cdecl", $1u, "ptr", DllStructGetPtr($1w), "wstr", $1r, "ptr", DllStructGetPtr($1v), "uint", $1s)
$1s *= 2
Until $h[0] <> -1
Local $1x = 0
Return SetError($h[0], 0, _6k($1r, DllStructGetPtr($1v), $1x))
EndFunc
Func _6k(ByRef $1r, $j, ByRef $1x)
If $1x = -1 Then Return Null
Local $1y = DllStructCreate("int;int;int;int", $j +($1x * 20))
Local $1z = DllStructGetData($1y, 1)
Local $20 = DllStructGetData($1y, 2)
Local $21 = DllStructGetData($1y, 3)
Local $y = DllStructGetData($1y, 4)
$1x += 1
If $1z = 0 And $20 = 0 And $21 = 0 And $y = 0 Then
$1x = -1
Return Null
EndIf
Switch $1z
Case 0
Local $22 = StringMid($1r, $20 + 1, $21 - $20)
Switch $22
Case "true"
Return True
Case "false"
Return False
Case "null"
Return Null
Case Else
If StringRegExp($22, "^[+\-0-9]") Then
Return Number($22)
Else
Return _6i($22)
EndIf
EndSwitch
Case 1
Local $23 = _6q()
For $0z = 0 To $y - 1 Step 2
Local $24 = _6k($1r, $j, $1x)
Local $25 = _6k($1r, $j, $1x)
If Not IsString($24) Then $24 = _6p($24)
If $23.Exists($24) Then $23.Remove($24)
$23.Add($24, $25)
Next
Return $23
Case 2
Local $1n[$y]
For $0z = 0 To $y - 1
$1n[$0z] = _6k($1r, $j, $1x)
Next
Return $1n
Case 3
Return _6i(StringMid($1r, $20 + 1, $21 - $20))
EndSwitch
EndFunc
Func _6l(ByRef $23)
Return(IsObj($23) And ObjName($23) = "Dictionary")
EndFunc
Func _6n($26, $1o = 0)
Local $1r = ""
Select
Case IsString($26)
Return '"' & _6h($26, $1o) & '"'
Case IsNumber($26)
Return $26
Case IsArray($26) And UBound($26, 0) = 1
$1r = "["
For $0z = 0 To UBound($26) - 1
$1r &= _6n($26[$0z], $1o) & ","
Next
If StringRight($1r, 1) = "," Then $1r = StringTrimRight($1r, 1)
Return $1r & "]"
Case _6l($26)
$1r = "{"
Local $27 = $26.Keys()
For $0z = 0 To UBound($27) - 1
$1r &= '"' & _6h($27[$0z], $1o) & '":' & _6n($26.Item($27[$0z]), $1o) & ","
Next
If StringRight($1r, 1) = "," Then $1r = StringTrimRight($1r, 1)
Return $1r & "}"
Case IsBool($26)
Return StringLower($26)
Case IsPtr($26)
Return Number($26)
Case IsBinary($26)
Return '"' & _6h(BinaryToString($26, 4), $1o) & '"'
Case Else
Return "null"
EndSelect
EndFunc
Func _6o($26, $1o, $28, $29, $2a, $2b, $2c = Default, $2d = Default, $2e = "")
Local $2f = $2e, $1r = "", $18 = "", $2g = "", $27 = ""
Local $m = 0
Select
Case IsString($26)
$18 = _6h($26, $1o)
If BitAND($1o, 512) And Not BitAND($1o, 256) And Not StringRegExp($18, "[\s,:]") And Not StringRegExp($18, "^[+\-0-9]") Then
Return $18
Else
Return '"' & $18 & '"'
EndIf
Case IsArray($26) And UBound($26, 0) = 1
If UBound($26) = 0 Then Return "[]"
If IsKeyword($2c) Then
$2c = ""
$2g = StringRegExp($29, "[\r\n]+$", 3)
If IsArray($2g) Then $2c = $2g[0]
EndIf
If $2c Then $2e &= $28
$m = UBound($26) - 1
For $0z = 0 To $m
If $2c Then $1r &= $2e
$1r &= _6o($26[$0z], $1o, $28, $29, $2a, $2b, $2c, $2d, $2e)
If $0z < $m Then $1r &= $29
Next
If $2c Then Return "[" & $2c & $1r & $2c & $2f & "]"
Return "[" & $1r & "]"
Case _6l($26)
If $26.Count = 0 Then Return "{}"
If IsKeyword($2d) Then
$2d = ""
$2g = StringRegExp($2a, "[\r\n]+$", 3)
If IsArray($2g) Then $2d = $2g[0]
EndIf
If $2d Then $2e &= $28
$27 = $26.Keys()
$m = UBound($27) - 1
For $0z = 0 To $m
If $2d Then $1r &= $2e
$1r &= _6o(String($27[$0z]), $1o, $28, $29, $2a, $2b) & $2b & _6o($26.Item($27[$0z]), $1o, $28, $29, $2a, $2b, $2c, $2d, $2e)
If $0z < $m Then $1r &= $2a
Next
If $2d Then Return "{" & $2d & $1r & $2d & $2f & "}"
Return "{" & $1r & "}"
Case Else
Return _6n($26, $1o)
EndSelect
EndFunc
Func _6p($26, $1o = 0, $28 = Default, $29 = Default, $2a = Default, $2b = Default)
If BitAND($1o, 128) Then
Local $2h = BitAND($1o, 256)
If IsKeyword($28) Then
$28 = @TAB
Else
$28 = _6i($28)
If StringRegExp($28, "[^\t ]") Then $28 = @TAB
EndIf
If IsKeyword($29) Then
$29 = "," & @CRLF
Else
$29 = _6i($29)
If $29 = "" Or StringRegExp($29, "[^\s,]|,.*,") Or($2h And Not StringRegExp($29, ",")) Then $29 = "," & @CRLF
EndIf
If IsKeyword($2a) Then
$2a = "," & @CRLF
Else
$2a = _6i($2a)
If $2a = "" Or StringRegExp($2a, "[^\s,]|,.*,") Or($2h And Not StringRegExp($2a, ",")) Then $2a = "," & @CRLF
EndIf
If IsKeyword($2b) Then
$2b = ": "
Else
$2b = _6i($2b)
If $2b = "" Or StringRegExp($2b, "[^\s,:]|[,:].*[,:]") Or($2h And(StringRegExp($2b, ",") Or Not StringRegExp($2b, ":"))) Then $2b = ": "
EndIf
Return _6o($26, $1o, $28, $29, $2a, $2b)
ElseIf BitAND($1o, 512) Then
Return _6o($26, $1o, "", ",", ",", ":")
Else
Return _6n($26, $1o)
EndIf
EndFunc
Func _6q()
Local $23 = ObjCreate('Scripting.Dictionary')
$23.CompareMode = 0
Return $23
EndFunc
Func _6s(ByRef $23, $24)
Local $2i = $23
Local $27 = StringSplit($24, ".")
For $2j = 1 To $27[0]
If $2i.Exists($27[$2j]) Then
If $2j = $27[0] Then
Return $2i.Item($27[$2j])
Else
$2i = _6s($2i, $27[$2j])
EndIf
EndIf
Next
Return SetError(1, 0, '')
EndFunc
Func _6u(ByRef $23, $24)
Local $2i = $23
Local $27 = StringSplit($24, ".")
For $2j = 1 To $27[0]
If $2i.Exists($27[$2j]) Then
If $2j = $27[0] Then
Return True
Else
$2i = _6s($2i, $27[$2j])
EndIf
Else
Return False
EndIf
Next
Return False
EndFunc
Func _70(ByRef $2k, $2l)
Local $2g = StringRegExp($2l, "(^\[([^\]]+)\])|(^\.([^\.\[]+))", 3)
If IsArray($2g) Then
Local $2m
If UBound($2g) = 4 Then
$2m = String(_6j($2g[3]))
$2l = StringTrimLeft($2l, StringLen($2g[2]))
Else
$2m = _6j($2g[1])
$2l = StringTrimLeft($2l, StringLen($2g[0]))
EndIf
Local $2n
If IsString($2m) And _6l($2k) And _6u($2k, $2m) Then
$2n = _6s($2k, $2m)
ElseIf IsInt($2m) And IsArray($2k) And UBound($2k, 0) = 1 And $2m >= 0 And $2m < UBound($2k) Then
$2n = $2k[$2m]
Else
Return SetError(1, 0, "")
EndIf
If Not $2l Then Return $2n
Local $h = _70($2n, $2l)
Return SetError(@error, 0, $h)
EndIf
Return SetError(2, 0, "")
EndFunc
Global Const $2o = DllOpen("winhttp.dll")
DllOpen("winhttp.dll")
Func _75($2p)
Local $2q = DllCall($2o, "bool", "WinHttpCloseHandle", "handle", $2p)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _76($2r, $2s, $2t = Default)
Local $2u = _77($2s), $2v = 0
If @error Then
_8i($2t, 0)
Else
$2s = $2u[2]
$2t = $2u[3]
$2v = $2u[1]
EndIf
Local $2q = DllCall($2o, "handle", "WinHttpConnect", "handle", $2r, "wstr", $2s, "dword", $2t, "dword", 0)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
_7n($2q[0], 45, $2v)
Return $2q[0]
EndFunc
Func _77($2w, $2x = Default)
_8i($2x, 0x80000000)
Local $2y = DllStructCreate("dword StructSize;" & "ptr SchemeName;" & "dword SchemeNameLength;" & "int Scheme;" & "ptr HostName;" & "dword HostNameLength;" & "word Port;" & "ptr UserName;" & "dword UserNameLength;" & "ptr Password;" & "dword PasswordLength;" & "ptr UrlPath;" & "dword UrlPathLength;" & "ptr ExtraInfo;" & "dword ExtraInfoLength")
DllStructSetData($2y, 1, DllStructGetSize($2y))
Local $2z[6]
Local $30 = StringLen($2w)
For $0z = 0 To 5
$2z[$0z] = DllStructCreate("wchar[" & $30 + 1 & "]")
Next
DllStructSetData($2y, "SchemeNameLength", $30)
DllStructSetData($2y, "SchemeName", DllStructGetPtr($2z[0]))
DllStructSetData($2y, "HostNameLength", $30)
DllStructSetData($2y, "HostName", DllStructGetPtr($2z[1]))
DllStructSetData($2y, "UserNameLength", $30)
DllStructSetData($2y, "UserName", DllStructGetPtr($2z[2]))
DllStructSetData($2y, "PasswordLength", $30)
DllStructSetData($2y, "Password", DllStructGetPtr($2z[3]))
DllStructSetData($2y, "UrlPathLength", $30)
DllStructSetData($2y, "UrlPath", DllStructGetPtr($2z[4]))
DllStructSetData($2y, "ExtraInfoLength", $30)
DllStructSetData($2y, "ExtraInfo", DllStructGetPtr($2z[5]))
Local $2q = DllCall($2o, "bool", "WinHttpCrackUrl", "wstr", $2w, "dword", $30, "dword", $2x, "struct*", $2y)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Local $5[8] = [DllStructGetData($2z[0], 1), DllStructGetData($2y, "Scheme"), DllStructGetData($2z[1], 1), DllStructGetData($2y, "Port"), DllStructGetData($2z[2], 1), DllStructGetData($2z[3], 1), DllStructGetData($2z[4], 1), DllStructGetData($2z[5], 1)]
Return $5
EndFunc
Func _7c($31 = Default, $32 = Default, $33 = Default, $34 = Default, $2x = Default)
_8i($31, _8l())
_8i($32, 1)
_8i($33, "")
_8i($34, "")
_8i($2x, 0)
Local $2q = DllCall($2o, "handle", "WinHttpOpen", "wstr", $31, "dword", $32, "wstr", $33, "wstr", $34, "dword", $2x)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
If $2x = 0x10000000 Then _7n($2q[0], 45, 0x10000000)
Return $2q[0]
EndFunc
Func _7d($35, $36 = Default, $37 = Default, $38 = Default, $39 = Default, $3a = Default, $3b = Default)
_8i($36, "GET")
_8i($37, "")
_8i($38, "HTTP/1.1")
_8i($39, "")
_8i($3b, 0x00000040)
Local $3c
If $3a = Default Or Number($3a) = -1 Then
$3c = 0
Else
Local $3d = StringSplit($3a, ",", 2)
Local $3e = DllStructCreate("ptr[" & UBound($3d) + 1 & "]")
Local $3f[UBound($3d)]
For $0z = 0 To UBound($3d) - 1
$3f[$0z] = DllStructCreate("wchar[" & StringLen($3d[$0z]) + 1 & "]")
DllStructSetData($3f[$0z], 1, $3d[$0z])
DllStructSetData($3e, 1, DllStructGetPtr($3f[$0z]), $0z + 1)
Next
$3c = DllStructGetPtr($3e)
EndIf
Local $2q = DllCall($2o, "handle", "WinHttpOpenRequest", "handle", $35, "wstr", StringUpper($36), "wstr", $37, "wstr", StringUpper($38), "wstr", $39, "ptr", $3c, "dword", $3b)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return $2q[0]
EndFunc
Func _7e($3g, ByRef $3h, ByRef $3i, ByRef $3j)
Local $2q = DllCall($2o, "bool", "WinHttpQueryAuthSchemes", "handle", $3g, "dword*", 0, "dword*", 0, "dword*", 0)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
$3h = $2q[2]
$3i = $2q[3]
$3j = $2q[4]
Return 1
EndFunc
Func _7f($3g)
Local $3k = "dword*"
If BitAND(_7h(_7h(_7h($3g, 21), 21), 45), 0x10000000) Then $3k = "ptr"
Local $2q = DllCall($2o, "bool", "WinHttpQueryDataAvailable", "handle", $3g, $3k, 0)
If @error Then Return SetError(1, 0, 0)
Return SetExtended($2q[2], $2q[0])
EndFunc
Func _7g($3g, $3l = Default, $3m = Default, $3n = Default)
_8i($3l, 22)
_8i($3m, "")
_8i($3n, 0)
Local $2q = DllCall($2o, "bool", "WinHttpQueryHeaders", "handle", $3g, "dword", $3l, "wstr", $3m, "wstr", "", "dword*", 65536, "dword*", $3n)
If @error Or Not $2q[0] Then Return SetError(1, 0, "")
Return SetExtended($2q[6], $2q[4])
EndFunc
Func _7h($2p, $3o)
Local $2q = DllCall($2o, "bool", "WinHttpQueryOption", "handle", $2p, "dword", $3o, "ptr", 0, "dword*", 0)
If @error Or $2q[0] Then Return SetError(1, 0, "")
Local $3p = $2q[4]
Local $3q
Switch $3o
Case 93, 0x1001, 0x1003, 0x1002, 34, 0x1000, 41, 81, 82
$3q = DllStructCreate("wchar[" & $3p + 1 & "]")
Case 21, 1, 78
$3q = DllStructCreate("ptr")
Case 3, 2, 1, 0, 83, 4, 24, 9, 74, 73, 89, 7, 6, 2, 31, 36, 5
$3q = DllStructCreate("int")
Case 45
$3q = DllStructCreate("dword_ptr")
Case Else
$3q = DllStructCreate("byte[" & $3p & "]")
EndSwitch
$2q = DllCall($2o, "bool", "WinHttpQueryOption", "handle", $2p, "dword", $3o, "struct*", $3q, "dword*", $3p)
If @error Or Not $2q[0] Then Return SetError(2, 0, "")
Return DllStructGetData($3q, 1)
EndFunc
Func _7i($3g, $3r = Default, $3s = Default, $3t = Default)
_8i($3r, 0)
_8i($3s, 8192)
Local $3q, $3u = ""
If $3r = 2 Then $3u = Binary($3u)
Switch $3r
Case 1, 2
If $3t And $3t <> Default Then
$3q = DllStructCreate("byte[" & $3s & "]", $3t)
Else
$3q = DllStructCreate("byte[" & $3s & "]")
EndIf
Case Else
$3r = 0
If $3t And $3t <> Default Then
$3q = DllStructCreate("char[" & $3s & "]", $3t)
Else
$3q = DllStructCreate("char[" & $3s & "]")
EndIf
EndSwitch
Local $3k = "dword*"
If BitAND(_7h(_7h(_7h($3g, 21), 21), 45), 0x10000000) Then $3k = "ptr"
Local $2q = DllCall($2o, "bool", "WinHttpReadData", "handle", $3g, "struct*", $3q, "dword", $3s, $3k, 0)
If @error Or Not $2q[0] Then Return SetError(1, 0, "")
If Not $2q[4] Then Return SetError(-1, 0, $3u)
If $2q[4] < $3s Then
Switch $3r
Case 0
Return SetExtended($2q[4], StringLeft(DllStructGetData($3q, 1), $2q[4]))
Case 1
Return SetExtended($2q[4], BinaryToString(BinaryMid(DllStructGetData($3q, 1), 1, $2q[4]), 4))
Case 2
Return SetExtended($2q[4], BinaryMid(DllStructGetData($3q, 1), 1, $2q[4]))
EndSwitch
Else
Switch $3r
Case 0, 2
Return SetExtended($2q[4], DllStructGetData($3q, 1))
Case 1
Return SetExtended($2q[4], BinaryToString(DllStructGetData($3q, 1), 4))
EndSwitch
EndIf
EndFunc
Func _7j($3g)
Local $2q = DllCall($2o, "bool", "WinHttpReceiveResponse", "handle", $3g, "ptr", 0)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _7k($3g, $3v = Default, $3w = Default, $3x = Default, $3y = Default)
_8i($3v, "")
_8i($3w, "")
_8i($3x, 0)
_8i($3y, 0)
Local $3z = 0, $40 = 0
If @NumParams > 2 Then
Local $41
$40 = BinaryLen($3w)
$41 = DllStructCreate("byte[" & $40 & "]")
If $40 Then $3z = DllStructGetPtr($41)
DllStructSetData($41, 1, $3w)
EndIf
If Not $3x Or $3x < $40 Then $3x += $40
Local $2q = DllCall($2o, "bool", "WinHttpSendRequest", "handle", $3g, "wstr", $3v, "dword", 0, "ptr", $3z, "dword", $40, "dword", $3x, "dword_ptr", $3y)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _7l($3g, $42, $43, $44, $45)
Local $2q = DllCall($2o, "bool", "WinHttpSetCredentials", "handle", $3g, "dword", $42, "dword", $43, "wstr", $44, "wstr", $45, "ptr", 0)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _7n($2p, $3o, $46, $3p = Default)
If $3p = Default Then $3p = -1
If IsBinary($46) Then
$3p = DllStructCreate("byte[" & BinaryLen($46) & "]")
DllStructSetData($3p, 1, $46)
$46 = $3p
$3p = DllStructGetSize($46)
EndIf
Local $47
Switch $3o
Case 77, 68, 83, 4, 3, 63, 79, 85, 74, 73, 89, 90, 92, 91, 12, 6, 7, 88, 100, 58, 2, 84, 31, 36, 5, 96, 101, 80, 13, 118, 110
$47 = "dword*"
$3p = 4
Case 1, 86
$47 = "ptr*"
$3p = 4
If @AutoItX64 Then $3p = 8
If Not IsPtr($46) Then Return SetError(3, 0, 0)
Case 45
$47 = "dword_ptr*"
$3p = 4
If @AutoItX64 Then $3p = 8
Case 0x1001, 0x1003, 0x1002, 41, 0x1000
$47 = "wstr"
If(IsDllStruct($46) Or IsPtr($46)) Then Return SetError(3, 0, 0)
If $3p < 1 Then $3p = StringLen($46)
Case 47, 97, 98, 59, 38
$47 = "ptr"
If Not(IsDllStruct($46) Or IsPtr($46)) Then Return SetError(3, 0, 0)
Case Else
Return SetError(1, 0, 0)
EndSwitch
If $3p < 1 Then
If IsDllStruct($46) Then
$3p = DllStructGetSize($46)
Else
Return SetError(2, 0, 0)
EndIf
EndIf
Local $2q
If IsDllStruct($46) Then
$2q = DllCall($2o, "bool", "WinHttpSetOption", "handle", $2p, "dword", $3o, $47, DllStructGetPtr($46), "dword", $3p)
Else
$2q = DllCall($2o, "bool", "WinHttpSetOption", "handle", $2p, "dword", $3o, $47, $46, "dword", $3p)
EndIf
If @error Or Not $2q[0] Then Return SetError(4, 0, 0)
Return 1
EndFunc
Func _7p($2p, $48 = Default, $49 = Default, $4a = Default, $4b = Default)
_8i($48, 0)
_8i($49, 60000)
_8i($4a, 30000)
_8i($4b, 30000)
Local $2q = DllCall($2o, "bool", "WinHttpSetTimeouts", "handle", $2p, "int", $48, "int", $49, "int", $4a, "int", $4b)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _7s($4c = Default, $4d = 100)
If $4d <= 0 Then $4d = 100
Local Static $4e = Default, $4f = $4d
If $4c <> Default Then
$4e = $4c
$4f = Ceiling($4d)
ElseIf $4c = 0 Then
$4e = Default
$4f = 1
EndIf
Local $4g[2] = [$4e, $4f]
Return $4g
EndFunc
Func _7t($3g, $3r = Default)
If $3r = Default Then
$3r = 0
If _85(_7g($3g, 1)) = 65001 Then $3r = 1
Else
_8i($3r, 0)
EndIf
If $3r > 2 Or $3r < 0 Then Return SetError(1, 0, '')
Local $4h = Binary('')
If _7f($3g) Then
Do
$4h &= _7i($3g, 2)
Until @error
Switch $3r
Case 0
Return BinaryToString($4h)
Case 1
Return BinaryToString($4h, 4)
Case Else
Return $4h
EndSwitch
EndIf
Return SetError(2, 0, $4h)
EndFunc
Func _7v($35, $47 = Default, $4i = Default, $39 = Default, $4j = Default, $4k = Default, $4l = Default, $3r = Default, $4m = Default, $4n = Default)
_8i($47, "GET")
_8i($4i, "")
_8i($39, "")
_8i($4j, "")
_8i($4k, "")
_8i($4l, False)
_8i($3r, Default)
_8i($4m, "")
_8i($4n, "")
If $3r > 2 Or $3r < 0 Then Return SetError(4, 0, 0)
Local $3g = _7w($35, $47, $4i, $39, $4j, $4k)
If @error Then Return SetError(@error, 0, 0)
_8g($3g, $4k, $4j, $4m, $4n)
Local $4o = _7g($3g, 19)
If $4l Then
Local $2[3] = [_7g($3g), _7t($3g, $3r), _7h($3g, 34)]
_75($3g)
Return SetExtended($4o, $2)
EndIf
Local $4p = _7t($3g, $3r)
_75($3g)
Return SetExtended($4o, $4p)
EndFunc
Func _7w($35, $47 = Default, $4i = Default, $39 = Default, $4j = Default, $4k = Default)
_8i($47, "GET")
_8i($4i, "")
_8i($39, "")
_8i($4j, "")
_8i($4k, "")
Local $3g = _7d($35, $47, $4i, Default, $39)
If Not $3g Then Return SetError(1, @error, 0)
If $47 = "POST" And $4k = "" Then $4k = "Content-Type: application/x-www-form-urlencoded" & @CRLF
_7n($3g, 118, 0x00000003)
_7n($3g, 110, 1)
_7k($3g, $4k, $4j)
If @error Then Return SetError(2, 0 * _75($3g), 0)
_7j($3g)
If @error Then Return SetError(3, 0 * _75($3g), 0)
Return $3g
EndFunc
Func _7x($35, $47 = Default, $4i = Default, $39 = Default, $4j = Default, $4k = Default, $4q = 0)
_8i($47, "GET")
_8i($4i, "")
_8i($39, "")
_8i($4j, "")
_8i($4k, "")
Local $3g = _7d($35, $47, $4i, Default, $39, Default, BitOR(0x00800000, 0x00000040))
If Not $3g Then Return SetError(1, @error, 0)
If $4q Then _7n($3g, 31, BitOR(0x00000100, 0x00002000, 0x00001000, 0x00000200))
If $47 = "POST" And $4k = "" Then $4k = "Content-Type: application/x-www-form-urlencoded" & @CRLF
_7n($3g, 118, 0x00000003)
_7n($3g, 110, 1)
_7k($3g, $4k, $4j)
If @error Then Return SetError(2, 0 * _75($3g), 0)
_7j($3g)
If @error Then Return SetError(3, 0 * _75($3g), 0)
Return $3g
EndFunc
Func _7y($35, $47 = Default, $4i = Default, $39 = Default, $4j = Default, $4k = Default, $4l = Default, $3r = Default, $4m = Default, $4n = Default, $4r = 0)
_8i($47, "GET")
_8i($4i, "")
_8i($39, "")
_8i($4j, "")
_8i($4k, "")
_8i($4l, False)
_8i($3r, Default)
_8i($4m, "")
_8i($4n, "")
If $3r > 2 Or $3r < 0 Then Return SetError(4, 0, 0)
Local $3g = _7x($35, $47, $4i, $39, $4j, $4k, $4r)
If @error Then Return SetError(@error, 0, 0)
_8g($3g, $4k, $4j, $4m, $4n)
If $4l Then
Local $2[3] = [_7g($3g), _7t($3g, $3r), _7h($3g, 34)]
_75($3g)
Return $2
EndIf
Local $4p = _7t($3g, $3r)
_75($3g)
Return $4p
EndFunc
Func _81($3g, $4h, $3r = Default)
_8i($3r, 0)
Local $4s, $4t
If $3r = 1 Then
$4s = BinaryLen($4h)
$4t = DllStructCreate("byte[" & $4s & "]")
DllStructSetData($4t, 1, $4h)
ElseIf IsDllStruct($4h) Then
$4s = DllStructGetSize($4h)
$4t = $4h
Else
$4s = StringLen($4h)
$4t = DllStructCreate("char[" & $4s + 1 & "]")
DllStructSetData($4t, 1, $4h)
EndIf
Local $2q = DllCall($2o, "bool", "WinHttpWriteData", "handle", $3g, "struct*", $4t, "dword", $4s, "dword*", 0)
If @error Or Not $2q[0] Then Return SetError(1, 0, 0)
Return SetExtended($2q[4], 1)
EndFunc
Func _85($4u)
Local $4v = StringRegExp($4u, "(?i).*?\Qcharset=\E(?U)([^ ]+)(;| |\Z)", 2)
If Not @error Then $4u = $4v[1]
If StringLeft($4u, 2) = "cp" Then Return Int(StringTrimLeft($4u, 2))
If $4u = "utf-8" Then Return 65001
EndFunc
Func _8g($3g, $3v = "", $4w = "", $4m = "", $4n = "", $4x = 0)
If $4m And $4n Then
Local $4y = _7g($3g, 19)
If $4y = 401 Or $4y = 407 Then
Local $3h, $3i, $3j
If _7e($3g, $3h, $3i, $3j) Then
If $3i = 0x00000004 And $4y = 407 Then
_7n($3g, 83, 0x10000000)
_7n($3g, 0x1002, $4m)
_7n($3g, 0x1003, $4n)
Else
_7l($3g, $3j, $3i, $4m, $4n)
EndIf
If $4x Then
_8h($3g, $3v, $4w)
Else
_7k($3g, $3v, $4w)
EndIf
_7j($3g)
EndIf
EndIf
EndIf
EndFunc
Func _8h($3g, $3v, $4z)
Local $50 = _7s()
If $50[0] <> Default Then
Local $3p = StringLen($4z), $51 = Floor($3p / $50[1]), $52 = $3p -($50[1] - 1) * $51, $53 = $51
_7k($3g, Default, Default, $3p)
For $0z = 1 To $50[1]
If $0z = $50[1] Then $53 = $52
_81($3g, StringMid($4z, 1 + $51 *($0z -1), $53))
Call($50[0], Floor($0z * 100 / $50[1]))
Next
Else
_7k($3g, Default, $4z)
EndIf
EndFunc
Func _8i(ByRef $54, $55)
If $54 = Default Or Number($54) = -1 Then $54 = $55
EndFunc
Func _8l()
Local Static $56 = "Mozilla/5.0 " & _8m() & " WinHttp/" & _8n() & " (WinHTTP/5.1) like Gecko"
Return $56
EndFunc
Func _8m()
Local $4j = FileGetVersion("kernel32.dll")
$4j = "(Windows NT " & StringLeft($4j, StringInStr($4j, ".", 1, 2) - 1)
If StringInStr(@OSArch, "64") And Not @AutoItX64 Then $4j &= "; WOW64"
$4j &= ")"
Return $4j
EndFunc
Func _8n()
Return "1.6.4.1"
EndFunc
#ignorefunc _WD_IsLatestRelease
Global Const $57 = "element-6066-11e4-a52e-4f735466cecf"
Global Enum $58 = 0, $59, $5a
Global Enum $5b = 0, $5c, $5d, $5e, $5f, $5g, $5h, $5i, $5j, $5k, $5l, $5m, $5n, $5o, $5p, $5q, $5r, $5s
Global Const $5t[$5s] = [ "Success", "General Error", "Socket Error", "Invalid data type", "Invalid value", "Invalid argument", "Send / Recv error", "Timeout", "No match", "Error return value", "Webdriver Exception", "Invalid Expression", "No alert present", "Not found", "Element interaction issue", "Invalid session ID", "Unknown Command" ]
Global Const $5u = "invalid session id"
Global Const $5v = "unknown command"
Global Const $5w = "no such element"
Global Const $5x = "stale element reference"
Global Const $5y = "invalid argument"
Global Const $5z = "element click intercepted"
Global Const $60 = "element not interactable"
Global Const $61 = "WinHTTP request timed out before Webdriver"
Global $62 = ""
Global $63 = ""
Global $64 = "HTTP://127.0.0.1"
Global $65 = 0
Global $66 = ObjCreate("winhttp.winhttprequest.5.1")
Global $67
Global $68 = ""
Global $69 = 4
Global $6a = '\\"'
Global $6b = True
Global $6c = True
Global $6d = 100
Global $6e = True
Global $6f = $5a
Global $6g = Default
Global $6h = True
Global $6i[4] = [0, 60000, 30000, 30000]
Global $6j = "Content-Type: application/json"
Func _8p($6k = Default)
Local Const $6l = "_WD_CreateSession"
Local $6m = ""
If $6k = Default Then $6k = "{}"
Local $6n = _96($64 & ":" & $65 & "/session", $6k)
Local $6o = @error
If $6f = $5a Then
_9e($6l & ': ' & $6n & @CRLF)
EndIf
If $6o = $5b Then
Local $6p = _6j($6n)
$6m = _70($6p, "[value][sessionId]")
If @error Then
Local $6q = _70($6p, "[value][message]")
Return SetError(_98($6l, $5l, $6q), $67, "")
EndIf
Else
Return SetError(_98($6l, $5l, "HTTP status = " & $67), $67, "")
EndIf
$68 = $6n
Return SetError($5b, $67, $6m)
EndFunc
Func _8t($6m, $2w)
Local Const $6l = "_WD_Navigate"
Local $6n = _96($64 & ":" & $65 & "/session/" & $6m & "/url", '{"url":"' & $2w & '"}')
Local $6o = @error
If $6f = $5a Then
_9e($6l & ': ' & $6n & @CRLF)
EndIf
If $6o Then
Return SetError(_98($6l, $6o, "HTTP status = " & $67), $67, 0)
EndIf
Return SetError($5b, $67, 1)
EndFunc
Func _8v($6m, $6r, $6s = Default)
Local Const $6l = "_WD_Window"
Local $6n, $6p, $6t = "", $6o
If $6s = Default Then $6s = ''
$6r = StringLower($6r)
Switch $6r
Case 'window'
If $6s = '' Then
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/" & $6r)
Else
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/" & $6r, $6s)
EndIf
$6o = @error
Case 'handles'
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/window/" & $6r)
$6o = @error
Case 'maximize', 'minimize', 'fullscreen'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/window/" & $6r, "{}")
$6o = @error
Case 'new'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/window/" & $6r, $6s)
$6o = @error
Case 'rect'
If $6s = '' Then
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/window/" & $6r)
Else
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/window/" & $6r, $6s)
EndIf
$6o = @error
Case 'screenshot'
If $6s = '' Then
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/" & $6r)
Else
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/" & $6r & '/' & $6s)
EndIf
$6o = @error
Case 'close'
$6n = _97($64 & ":" & $65 & "/session/" & $6m & "/window")
$6o = @error
Case 'switch'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/window", $6s)
$6o = @error
Case 'frame', 'print'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/" & $6r, $6s)
$6o = @error
Case 'parent'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/frame/parent", $6s)
$6o = @error
Case Else
Return SetError(_98($6l, $5e, "(Window|Handles|Maximize|Minimize|Fullscreen|New|Rect|Screenshot|Close|Switch|Frame|Parent|Print) $sCommand=>" & $6r), 0, "")
EndSwitch
If $6o = $5b Then
If $67 = 200 Then
Switch $6r
Case 'maximize', 'minimize', 'fullscreen', 'close', 'switch', 'frame', 'parent'
$6t = $6n
Case 'new'
$6p = _6j($6n)
$6t = _70($6p, "[value][handle]")
Case Else
$6p = _6j($6n)
$6t = _70($6p, "[value]")
EndSwitch
Else
$6o = $5l
EndIf
EndIf
If $6f = $5a Then
_9e($6l & ': ' & StringLeft($6n, $6d) & "..." & @CRLF)
EndIf
If $6o Then
Return SetError(_98($6l, $6o, "HTTP status = " & $67), $67, "")
EndIf
Return SetError($5b, $67, $6t)
EndFunc
Func _8w($6m, $6u, $6v, $6w = Default, $6x = Default, $6y = Default)
Local Const $6l = "_WD_FindElement"
Local $6z, $70 = '', $6n, $6t, $6o
Local $6p, $71, $72, $73, $74[0]
If $6w = Default Then $6w = ""
If $6x = Default Then $6x = False
If $6y = Default Then $6y = False
If $6w Then
$70 =($6y) ? "/shadow/" : "/element/"
$70 &= $6w
If $6u = "xpath" And StringLeft($6v, 1) <> '.' Then
$6o = $5m
$6n = "Selector must be relative when supplying a starting element"
EndIf
EndIf
If $6o = $5b Then
$6z = '/element' &(($6x) ? 's' : '')
$6v = _9a($6v)
$6n = _96($64 & ":" & $65 & "/session/" & $6m & $70 & $6z, '{"using":"' & $6u & '","value":"' & $6v & '"}')
$6o = @error
EndIf
If $6o = $5b Then
If $67 = 200 Then
If $6x Then
$6p = _6j($6n)
$71 = _70($6p, '[value]')
If UBound($71) > 0 Then
$72 = "[" & $57 & "]"
Dim $74[UBound($71)]
For $75 In $71
$74[$73] = _70($75, $72)
$73 += 1
Next
Else
$6o = $5j
EndIf
Else
$6p = _6j($6n)
$6t = _70($6p, "[value][" & $57 & "]")
EndIf
Else
$6o = $5l
EndIf
EndIf
If $6f = $5a Then
_9e($6l & ': ' & $6n & @CRLF)
EndIf
If $6o Then
Return SetError(_98($6l, $6o, "HTTP status = " & $67), $67, "")
EndIf
Return SetError($5b, $67,($6x) ? $74 : $6t)
EndFunc
Func _8x($6m, $76, $6r, $6s = Default)
Local Const $6l = "_WD_ElementAction"
Local $6n, $6t = '', $6o, $6p
If $6s = Default Then $6s = ''
$6r = StringLower($6r)
Switch $6r
Case 'name', 'rect', 'text', 'selected', 'enabled', 'displayed', 'screenshot', 'shadow', 'comprole', 'complabel'
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/element/" & $76 & "/" & $6r)
$6o = @error
Case 'active'
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/element/" & $6r)
$6o = @error
Case 'attribute', 'property', 'css'
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/element/" & $76 & "/" & $6r & "/" & $6s)
$6o = @error
Case 'clear', 'click'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/element/" & $76 & "/" & $6r, '{"id":"' & $76 & '"}')
$6o = @error
Case 'value'
If $6s Then
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/element/" & $76 & "/" & $6r, '{"id":"' & $76 & '", "text":"' & _9a($6s) & '"}')
Else
$6n = _95($64 & ":" & $65 & "/session/" & $6m & "/element/" & $76 & "/property/value")
EndIf
$6o = @error
Case Else
Return SetError(_98($6l, $5e, "(Name|Rect|Text|Selected|Enabled|Displayed|Active|Attribute|Property|CSS|Clear|Click|Value|Screenshot|Shadow|CompRole|CompLabel) $sCommand=>" & $6r), 0, "")
EndSwitch
If $6o = $5b Then
Switch $67
Case 200
Switch $6r
Case 'clear', 'click'
$6t = $6n
Case 'value'
If $6s Then
$6t = $6n
Else
$6p = _6j($6n)
$6t = _70($6p, "[value]")
EndIf
Case Else
$6p = _6j($6n)
$6t = _70($6p, "[value]")
EndSwitch
Case Else
$6o = $5l
EndSwitch
EndIf
If $6f = $5a Then
_9e($6l & ': ' & StringLeft($6n,$6d) & "..." & @CRLF)
EndIf
If $6o Then
Return SetError(_98($6l, $6o, $6n), $67, "")
EndIf
Return SetError($5b, $67, $6t)
EndFunc
Func _8y($6m, $77, $78 = Default, $79 = Default)
Local Const $6l = "_WD_ExecuteScript"
Local $6n, $4z, $6z
If $78 = Default Then $78 = ""
If $79 = Default Then $79 = False
$77 = _9a($77)
$4z = '{"script":"' & $77 & '", "args":[' & $78 & ']}'
$6z =($79) ? 'async' : 'sync'
$6n = _96($64 & ":" & $65 & "/session/" & $6m & "/execute/" & $6z, $4z)
Local $6o = @error
If $6f = $5a Then
_9e($6l & ': ' & StringLeft($6n,$6d) & "..." & @CRLF)
EndIf
If $6o Then
Return SetError(_98($6l, $6o, "HTTP status = " & $67), $67, $6n)
EndIf
Return SetError($5b, $67, $6n)
EndFunc
Func _92($6s, $7a = Default)
Local Const $6l = "_WD_Option"
If $7a = Default Then $7a = ''
Switch $6s
Case "driver"
If $7a == "" Then Return $62
If Not IsString($7a) Then
Return SetError(_98($6l, $5e, "(string) $vValue: " & $7a), 0, 0)
EndIf
$62 = $7a
Case "driverparams"
If $7a == "" Then Return $63
If Not IsString($7a) Then
Return SetError(_98($6l, $5e, "(string) $vValue: " & $7a), 0, 0)
EndIf
$63 = $7a
Case "baseurl"
If $7a == "" Then Return $64
If Not IsString($7a) Then
Return SetError(_98($6l, $5e, "(string) $vValue: " & $7a), 0, 0)
EndIf
$64 = $7a
Case "port"
If $7a == "" Then Return $65
If Not IsInt($7a) Then
Return SetError(_98($6l, $5e, "(int) $vValue: " & $7a), 0, 0)
EndIf
$65 = $7a
Case "binaryformat"
If $7a == "" Then Return $69
If Not IsInt($7a) Then
Return SetError(_98($6l, $5e, "(int) $vValue: " & $7a), 0, 0)
EndIf
$69 = $7a
Case "driverclose"
If $7a == "" Then Return $6b
If Not IsBool($7a) Then
Return SetError(_98($6l, $5e, "(bool) $vValue: " & $7a), 0, 0)
EndIf
$6b = $7a
Case "driverdetect"
If $7a == "" Then Return $6c
If Not IsBool($7a) Then
Return SetError(_98($6l, $5e, "(bool) $vValue: " & $7a), 0, 0)
EndIf
$6c = $7a
Case "httptimeouts"
If $7a == "" Then Return $6h
If Not IsBool($7a) Then
Return SetError(_98($6l, $5e, "(bool) $vValue: " & $7a), 0, 0)
EndIf
$6h = $7a
Case "debugtrim"
If $7a == "" Then Return $6d
If Not IsInt($7a) Then
Return SetError(_98($6l, $5e, "(int) $vValue: " & $7a), 0, 0)
EndIf
$6d = $7a
Case "console"
If $7a == "" Then Return $6g
If Not(IsString($7a) Or IsInt($7a)) Then
Return SetError(_98($6l, $5e, "(string/int) $vValue: " & $7a), 0, 0)
EndIf
$6g = $7a
Case Else
Return SetError(_98($6l, $5e, "(Driver|DriverParams|BaseURL|Port|BinaryFormat|DriverClose|DriverDetect|HTTPTimeouts|DebugTrim|Console) $sOption=>" & $6s), 0, 0)
EndSwitch
Return 1
EndFunc
Func _93()
Local Const $6l = "_WD_Startup"
Local $7b, $7c, $7d, $7e, $7f
If $62 = "" Then
Return SetError(_98($6l, $5f, "Location for Web Driver not set." & @CRLF), 0, 0)
EndIf
If $6b Then _99()
Local $6r = StringFormat('"%s" %s ', $62, $63)
If $6f = $5a Then
$7b = "_WD_IsLatestRelease"
$7c = Call($7b)
Select
Case @error = 0xDEAD And @extended = 0xBEEF
$7d = ""
Case @error
$7d = " (Update status unknown [" & @error & "])"
Case $7c
$7d = " (Up to date)"
Case Not $7c
$7d = " (Update available)"
EndSelect
Local $7g = _8n()
If $7g < "1.6.4.2" Then
$7g &= " (Download latest source at <https://raw.githubusercontent.com/dragana-r/autoit-winhttp/master/WinHttp.au3>)"
EndIf
_9e("_WDStartup: OS:" & @TAB & @OSVersion & " " & @OSType & " " & @OSBuild & " " & @OSServicePack & @CRLF)
_9e("_WDStartup: AutoIt:" & @TAB & @AutoItVersion & @CRLF)
_9e("_WDStartup: WD.au3:" & @TAB & "0.4.0.1" & $7d & @CRLF)
_9e("_WDStartup: WinHTTP:" & @TAB & $7g & @CRLF)
_9e("_WDStartup: Driver:" & @TAB & $62 & @CRLF)
_9e("_WDStartup: Params:" & @TAB & $63 & @CRLF)
_9e("_WDStartup: Port:" & @TAB & $65 & @CRLF)
Else
_9e('_WDStartup: ' & $6r & @CRLF)
EndIf
$7e = _9d($62)
$7f = ProcessExists($7e)
If $6c And $7f Then
_9e("_WDStartup: Existing instance of " & $7e & " detected!" & @CRLF)
Else
$7f = Run($6r, "",($6f = $5a) ? @SW_SHOW : @SW_HIDE)
EndIf
If @error Then
Return SetError(_98($6l, $5c, "Error launching web driver!"), 0, 0)
EndIf
Return SetError($5b, 0, $7f)
EndFunc
Func _94($7h = Default)
_99($7h)
EndFunc
Func _95($2w)
Local Const $6l = "__WD_Get"
Local $7i = $5b, $7j, $6o
If $6f = $5a Then
_9e($6l & ': URL=' & $2w & @CRLF)
EndIf
$67 = 0
Local $2u = _77($2w)
If IsArray($2u) Then
Local $7k = _7c()
If $6h Then
_7p($7k, $6i[0], $6i[1], $6i[2], $6i[3])
EndIf
Local $35 = _76($7k, $2u[2], $2u[3])
If @error Then
$7i = $5d
Else
Switch $2u[1]
Case 1
$7j = _7v($35, "GET", $2u[6] & $2u[7], Default, Default, $6j)
Case 2
$7j = _7y($35, "GET", $2u[6] & $2u[7], Default, Default, $6j)
Case Else
SetError($5f)
EndSwitch
$6o = @error
$67 = @extended
If $6o Then
$7i = $5h
$7j = $61
Else
_9c($6o, $7j)
$7i = $6o
EndIf
EndIf
_75($35)
_75($7k)
Else
$7i = $5f
EndIf
If $6f = $5a Then
_9e($6l & ': StatusCode=' & $67 & "; $iResult = " & $7i & "; $sResponseText=" & StringLeft($7j,$6d) & "..." & @CRLF)
EndIf
If $7i Then
Return SetError(_98($6l, $7i, $7j), $67, $7j)
EndIf
Return SetError($5b, 0, $7j)
EndFunc
Func _96($2w, $4z)
Local Const $6l = "__WD_Post"
Local $7i, $7j, $6o
If $6f = $5a Then
_9e($6l & ': URL=' & $2w & "; $sData=" & $4z & @CRLF)
EndIf
$67 = 0
Local $2u = _77($2w)
If @error Then
$7i = $5f
Else
Local $7k = _7c()
If $6h Then
_7p($7k, $6i[0], $6i[1], $6i[2], $6i[3])
EndIf
Local $35 = _76($7k, $2u[2], $2u[3])
If @error Then
$7i = $5d
Else
Switch $2u[1]
Case 1
$7j = _7v($35, "POST", $2u[6] & $2u[7], Default, StringToBinary($4z, $69), $6j)
Case 2
$7j = _7y($35, "POST", $2u[6] & $2u[7], Default, StringToBinary($4z, $69), $6j)
Case Else
SetError($5f)
EndSwitch
$6o = @error
$67 = @extended
If $6o Then
$7i = $5h
$7j = $61
Else
_9c($6o, $7j)
$7i = $6o
EndIf
EndIf
_75($35)
_75($7k)
EndIf
If $6f = $5a Then
_9e($6l & ': StatusCode=' & $67 & "; ResponseText=" & StringLeft($7j,$6d) & "..." & @CRLF)
EndIf
If $7i Then
Return SetError(_98($6l, $7i, $7j), $67, $7j)
EndIf
Return SetError($5b, $67, $7j)
EndFunc
Func _97($2w)
Local Const $6l = "__WD_Delete"
Local $7i, $7j, $6o
If $6f = $5a Then
_9e($6l & ': URL=' & $2w & @CRLF)
EndIf
$67 = 0
Local $2u = _77($2w)
If @error Then
$7i = $5f
Else
Local $7k = _7c()
If $6h Then
_7p($7k, $6i[0], $6i[1], $6i[2], $6i[3])
EndIf
Local $35 = _76($7k, $2u[2], $2u[3])
If @error Then
$7i = $5d
Else
Switch $2u[1]
Case 1
$7j = _7v($35, "DELETE", $2u[6] & $2u[7], Default, Default, $6j)
Case 2
$7j = _7y($35, "DELETE", $2u[6] & $2u[7], Default, Default, $6j)
Case Else
SetError($5f)
EndSwitch
$6o = @error
$67 = @extended
If $6o Then
$7i = $5h
$7j = $61
Else
_9c($6o, $7j)
$7i = $6o
EndIf
EndIf
_75($35)
_75($7k)
EndIf
If $6f = $5a Then
_9e($6l & ': StatusCode=' & $67 & "; ResponseText=" & StringLeft($7j,$6d) & "..." & @CRLF)
EndIf
If $7i Then
Return SetError(_98($6l, $5l, $7j), $67, $7j)
EndIf
Return SetError($5b, 0, $7j)
EndFunc
Func _98($7l, $7m, $6q = Default)
Local $7n
If $6q = Default Then $6q = ''
Switch $6f
Case $58
Case $59
If $7m <> $5b Then ContinueCase
Case $5a
$7n = $7l & " ==> " & $5t[$7m]
If $6q <> "" Then
$7n = $7n & ": " & $6q
EndIf
_9e($7n & @CRLF)
If @Compiled Then
If $6e And $7m <> $5b And $7m < 6 Then MsgBox(16, "WD_Core.au3 Error:", $7n)
DllCall("kernel32.dll", "none", "OutputDebugString", "str", $7n)
EndIf
EndSwitch
Return $7m
EndFunc
Func _99($7h = Default)
Local $7e, $2, $7o[2][2]
If $7h = Default Then $7h = $62
If IsInt($7h) Then
$7o[0][0] = 1
$7o[1][1] = $7h
Else
$7e = _9d($7h)
$7o = ProcessList($7e)
EndIf
For $0z = 1 To $7o[0][0]
$2 = _45($7o[$0z][1])
If IsArray($2) Then
For $7p = 0 To UBound($2) - 1
If $2[$7p][1] == 'conhost.exe' Then
ProcessClose($2[$7p][0])
ProcessWaitClose($2[$7p][0], 5)
EndIf
Next
EndIf
ProcessClose($7o[$0z][1])
ProcessWaitClose($7o[$0z][1], 5)
Next
EndFunc
Func _9a($4z)
Local $7q = "([" & $6a & "])"
Local $7r = StringRegExpReplace($4z, $7q, "\\$1")
Return SetError($5b, 0, $7r)
EndFunc
Func _9c(ByRef $6o, $7s)
If $6o or $7s == Null Then Return
If Not IsObj($7s) Then
Local $6p = _6j($7s)
$7s = _70($6p, "[value]")
If @error Or $7s == Null Then Return
EndIf
If(Not IsObj($7s)) Or ObjName($7s, 2) <> 'Scripting.Dictionary' Then Return
If $7s.Exists('error') Then
Switch $7s.item('error')
Case ""
Case $5u
$6o = $5q
Case $5v
$6o = $5r
Case "timeout"
$6o = $5i
Case $5w, $5x
$6o = $5j
Case $5y
$6o = $5g
Case $5z, $60
$6o = $5p
Case Else
$6o = $5l
EndSwitch
EndIf
EndFunc
Func _9d($7t)
Return StringRegExpReplace($7t, "^.*\\(.*)$", "$1")
EndFunc
Func _9e($7n)
If $6g = Default Then
ConsoleWrite($7n)
Else
FileWrite($6g, $7n)
EndIf
EndFunc
Global $7u[11]
Global Const $7v = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($7w, $7x, $7y)
If $7u[3] = $7u[4] Then
If Not $7u[7] Then
$7u[5] *= -1
$7u[7] = 1
EndIf
Else
$7u[7] = 1
EndIf
$7u[6] = $7u[3]
Local $7z = _9p($7y, $7w, $7u[3])
Local $80 = _9p($7y, $7x, $7u[3])
If $7u[8] = 1 Then
If(StringIsFloat($7z) Or StringIsInt($7z)) Then $7z = Number($7z)
If(StringIsFloat($80) Or StringIsInt($80)) Then $80 = Number($80)
EndIf
Local $81
If $7u[8] < 2 Then
$81 = 0
If $7z < $80 Then
$81 = -1
ElseIf $7z > $80 Then
$81 = 1
EndIf
Else
$81 = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $7z, 'wstr', $80)[0]
EndIf
$81 = $81 * $7u[5]
Return $81
EndFunc
Func _9p($7y, $3n, $82 = 0)
Local $3q = DllStructCreate("wchar Text[4096]")
Local $3t = DllStructGetPtr($3q)
Local $83 = DllStructCreate($7v)
DllStructSetData($83, "SubItem", $82)
DllStructSetData($83, "TextMax", 4096)
DllStructSetData($83, "Text", $3t)
If IsHWnd($7y) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $7y, "uint", 0x1073, "wparam", $3n, "struct*", $83)
Else
Local $84 = DllStructGetPtr($83)
GUICtrlSendMsg($7y, 0x1073, $3n, $84)
EndIf
Return DllStructGetData($3q, "Text")
EndFunc
#ignorefunc _HtmlTableGetWriteToArray
Func _bs($6m, $85 = Default, $86 = Default, $76 = Default)
Local Const $6l = "_WD_LoadWait"
Local $6o, $6n, $6p, $87
If $85 = Default Then $85 = 0
If $86 = Default Then $86 = 10000
If $76 = Default Then $76 = ""
If $85 Then Sleep($85)
Local $88 = TimerInit()
While True
If $76 <> '' Then
_8x($6m, $76, 'name')
If $67 = 404 Then $76 = ''
Else
$6n = _8y($6m, 'return document.readyState', '')
$6o = @error
If $6o Then
ExitLoop
EndIf
$6p = _6j($6n)
$87 = _70($6p, "[value]")
If $87 = 'complete' Then ExitLoop
EndIf
If(TimerDiff($88) > $86) Then
$6o = $5i
ExitLoop
EndIf
Sleep(100)
WEnd
If $6o Then
Return SetError(_98($6l, $6o, ""), 0, 0)
EndIf
Return SetError($5b, 0, 1)
EndFunc
Func _WD_IsLatestRelease()
Local Const $6l = "_WD_IsLatestRelease"
Local Const $89 = "https://github.com/Danp2/WebDriver/releases/latest"
Local $8a = Null
Local $8b = $6f
$6f = $58
Local $6t = InetRead($89)
Local $6o = @error
If $6o = $5b Then
Local $8c = StringRegExp(BinaryToString($6t), '<a href="/Danp2/WebDriver/releases/tag/(.*)">', 1)
If Not @error Then
Local $8d = $8c[0]
$8a =("0.4.0.1" == $8d)
EndIf
EndIf
$6f = $8b
If $6f = $5a Then
_9e($6l & ': ' & $8a & @CRLF)
EndIf
Return SetError(_98($6l, $6o), $67, $8a)
EndFunc
Run("Z:\HonrayTools\GA4ClickCount\北GA4ClickCount.exe","Z:\HonrayTools\GA4ClickCount")
Local $6k
$6f = $58
_cb()
_93()
$6m = _8p($6k)
_8t($6m,"")
_bs($6m)
_8y($6m,"return document.getElementById('id_password_toggle').remove();","")
$8e = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/div[3]/div/label"
$76 = _8w($6m, "xpath", $8e)
_8x($6m, $76, 'click')
$8e = "//input[@name='password']"
$76 = _8w($6m, "xpath", $8e)
_8x($6m, $76, 'value',"Xw3GV,yTV/FNtb%")
$8e = "//input[@name='userLoginId']"
$76 = _8w($6m, "xpath", $8e)
_8x($6m, $76, 'value',"y3662756@gmail.com")
Sleep(2000)
$8e = "//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/button"
$76 = _8w($6m, "xpath", $8e)
_8x($6m, $76, 'click')
_8v($6m, "Maximize")
_94()
Func _cb()
_92('Driver','Z:\HonrayTools\chromedriver.exe')
_92('Port',9515)
$6k='{"capabilities":{"alwaysMatch":{"goog:chromeOptions":{"w3c":true,"binary":"D:\\Tool\\ChromeGreen\\App\\Chrome-bin\\chrome.exe","prefs":{"credentials_enable_service":false,"credentials_enable_autosignin":false,"profile":{"avatar_index":26,"content_settings":{"enable_quiet_permission_ui_enabling_method":{"notifications":1},"pattern_pairs":{"https://*,*":{"media-stream":{"audio":"Default","video":"Default"}}},"pref_version":1},"default_content_setting_values":{"geolocation":1,"notifications":2},"default_content_settings":{"geolocation":1,"mouselock":1,"notifications":1,"popups":1,"ppapi-broker":1},"exit_type":"Normal","exited_cleanly":true,"managed_user_id":"","name":"北半球 1","password_manager_enabled":false}},"args":["--user-data-dir=C:\\Windows\\UserProfile","--app=https://www.netflix.com/tw/login"],"excludeSwitches":["enable-automation"],"useAutomationExtension":false}}}}'
EndFunc
