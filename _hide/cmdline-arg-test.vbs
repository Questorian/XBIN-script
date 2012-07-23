

' From the book "Windows Server Cookbook" by Robbie Allen
' ISBN: 0-596-00633-0

set objArgs = WScript.Arguments
WScript.Echo "Total number of arguments: " & WScript.Arguments.Count
for each strArg in objArgs
	WScript.Echo strArg
next

