	wscript.echo "Retrieving MACAddress and UUID locally"
	strComputer = "."
	wscript.echo "connecting to WMI..."
	err.clear
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	if err.number = 0 then
		wscript.echo "Connected to WMI"
	else
		wscript.echo "failed to connect to WMI. Exit script"
		wscript.quit
	end if

	Set colItems = objWMIService.ExecQuery ("Select * from Win32_NetworkAdapter")
	wscript.echo "Enumerating MACAddresses..."

	For Each objItem in colItems
		GetMACAddress = objItem.MACAddress
		if len(lcase(GetMACAddress)) > 0 then
			wscript.echo "Found MACAddress"
			Exit For
		end if
	Next

	wscript.echo "Enumerating UUID's"

	Set colItems = objWMIService.ExecQuery ("Select * from Win32_ComputerSystemProduct")

	For Each objItem in colItems
		GetUUID = objItem.UUID
		if len(lcase(GetUUID)) > 0 then
			wscript.echo "Found UUID"
			Exit For
		end if
	Next
	sMacAddress = GetMACAddress
	sUUID = GetUUID
	wscript.echo "MACAddress: " & sMacAddress
	wscript.echo "UUID: " & GetUUID


'	strNameSpace    = "root/Dellomci"
'	strComputerName = "."
'	strClassName    = "Dell_SystemSummary"
'	strKeyName      = "Name"
'	strWQLQuery = "SELECT * FROM " & strClassName & " WHERE " & strKeyName & "=" & Chr(34) & strComputerName & Chr(34)
'	Set colInstances = GetObject("WinMgmts:{impersonationLevel=impersonate}//" & strComputerName & "/" & strNameSpace).ExecQuery(strWQLQuery, "WQL", NULL)
'	For Each objInstance in colInstances
'		wscript.echo objInstance.Properties_.Item("AssetTag").Value
'		Exit For
'	Next


strComputer = "." 
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\"& strComputer & "\root\cimv2") 
Set colSMBIOS = objWMIService.ExecQuery ("Select * from Win32_SystemEnclosure") 
For Each objSMBIOS in colSMBIOS 
	Wscript.Echo "Part Number: " & objSMBIOS.PartNumber 
	Wscript.Echo "Serial Number: " & objSMBIOS.SerialNumber 
	Wscript.Echo "Asset Tag: " & objSMBIOS.SMBIOSAssetTag 
Next 
