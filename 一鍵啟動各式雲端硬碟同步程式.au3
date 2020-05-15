
;GoogleOne
Run(@ProgramFilesDir & "\Google\Drive\googledrivesync.exe")
;Dropbox
Run("c:\Program Files (x86)\Dropbox\Client\Dropbox.exe")
;C:\Users\AsureAng\AppData\Local
Run(@LocalAppDataDir & "\Microsoft\OneDrive\OneDrive.exe")
;C:\ProgramData\MEGAsync\MEGAsync.exe
Run(@AppDataCommonDir & "\MEGAsync\MEGAsync.exe")


