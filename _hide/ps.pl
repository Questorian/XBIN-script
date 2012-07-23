# From the book "Windows XP Cookbook"
# ISBN: 0596007256
# http://techtasks.com/code/viewbookcode/101

# ------ SCRIPT CONFIGURATION ------

use Win32::OLE qw(in);

$strComputer = '.';
# Can be a hostname or "." to target local host
# ------ END CONFIGURATION ---------
$objWMI = Win32::OLE->GetObject('winmgmts:\\\\' . $strComputer . '\\root\\cimv2');
$colProcesses = $objWMI->InstancesOf('Win32_Process');
foreach my $objProcess (in $colProcesses) {
    printf ("%-30s  -  %d\n", $objProcess->Name, $objProcess->ProcessID );
}

