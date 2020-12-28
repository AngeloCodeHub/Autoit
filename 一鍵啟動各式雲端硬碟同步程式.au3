
;GoogleOne
Run(@ProgramFilesDir & "\Google\Drive\googledrivesync.exe")

;Dropbox
Run("c:\Program Files (x86)\Dropbox\Client\Dropbox.exe")

;MS OneDrive
;C:\Users\AsureAng\AppData\Local
Run(@ProgramFilesDir & " (x86)\Microsoft OneDrive\OneDrive.exe")
;Run(@LocalAppDataDir & "\Microsoft\OneDrive\OneDrive.exe")

;MEGA
;C:\ProgramData\MEGAsync\MEGAsync.exe
Run(@AppDataCommonDir & "\MEGAsync\MEGAsync.exe")


