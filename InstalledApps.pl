#farley b - list all apps installed on the current PC
# 23:07 01.08.2005



use strict;
use warnings;
no warnings qw(uninitialized);

#Optional:  Change the delimiter to '/' to eliminate all of the extra backslashes 
use Win32::TieRegistry (Delimiter => "/");

#%apps will have a list of applications
my %apps;

#$softKey points to the Uninstall key that has 
#the Add/Remove Programs information 
my $softKey = $Registry->{"HKEY_LOCAL_MACHINE/Software/Microsoft/Windows/CurrentVersion/Uninstall"};

#Sort and iterate through the keys under Uninstall 
foreach(keys %{$softKey}){

	#Append the key and DisplayName to the Uninstall key
	#Set the result as a key in the %apps hash
	#This also removes any duplicate entries
	my $name = $softKey->{"$_/DisplayName"};
	$apps{$name} = 1;
}

#Print a list of the keys we got
foreach(sort keys %apps){
	print "$_\n";
}
