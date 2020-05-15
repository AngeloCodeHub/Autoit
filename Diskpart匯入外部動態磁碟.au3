
#cs
Diskpart.txt 內容
select disk 1
import
exit

#ce


#RequireAdmin
Run("diskpart.exe /s Diskpart.txt")
