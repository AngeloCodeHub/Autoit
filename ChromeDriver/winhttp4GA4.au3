

#include "WinHttp.au3"

$measurementID="G-60THP7KMGN"
$APISecret="dhdHuBRfRTG3v6wkf8weZg"
$events = '{"client_id":"173234776093-savuhgcok3oom0mn4425ea5v16pr4p3r.apps.googleusercontent.com", "events":{"name":"click","params":{ "ComputerName":"A32"}}}'

$payload = "measurement_id=" & $measurementID & "&api_secret=" & $APISecret

; Open needed handles
Local $hOpen = _WinHttpOpen()
Local $hConnect = _WinHttpConnect($hOpen, "www.google-analytics.com")
; Specify the reguest:
Local $hRequest = _WinHttpOpenRequest($hConnect, "POST","/mp/collect?measurement_id=" & $measurementID & "&api_secret=" & $APISecret )

; Send request
;_WinHttpSendRequest($hRequest,Default,$payload)
_WinHttpWriteData($hRequest,Default,$events)

; Wait for the response
;ConsoleWrite(_WinHttpReceiveResponse($hRequest))


; Clean
_WinHttpCloseHandle($hRequest)
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)


#cs
Local $sHeader = _WinHttpQueryHeaders($hRequest) ; ...get full header

; Clean
_WinHttpCloseHandle($hRequest)
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)

; Display retrieved header
MsgBox(0, "Header", $sHeader)
#ce