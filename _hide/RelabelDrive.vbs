' Re-lable a drive 
' Farley B. 2005-10-05T10:06:57 - Windows Server Hacks #7

'note: you need the "\" in the strDrive variable
strDrive = "q:\"
strLabel = "Big-BOB"


set oShell = CreateObject("Shell.Application")
oShell.NameSpace(strDrive).Self.Name = strLabel
