
#cs
取得目前登錄使用者的SID
#ce

#include <MsgBoxConstants.au3>



$UserSID = _GetSID()
MsgBox (1, "test", $UserSID)

Func _GetSID($sComputerName = @ComputerName, $sUsername = @UserName)
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!//" & $sComputerName & "/root/cimv2")
    Local $oColItems = $oWMIService.ExecQuery("Select * From Win32_UserAccount")
    If IsObj($oColItems) Then
        For $oObjectItem In $oColItems
            If $sUsername = $oObjectItem.Name Then
                Return $oObjectItem.SID
            EndIf
        Next
    EndIf
    Return SetError(1, 0, 0)
EndFunc   ;==>_GetSID


