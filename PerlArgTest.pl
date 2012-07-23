#!/usr/bin/env perl -s

use strict;
use warnings;

our ($help, $kill, $boot, $halt);


give_help() if $help;
print "-kill option specified \n" if $kill;
print "-boot option specified \n" if $boot;
print "-halt option specified \n" if $halt;


print "Argments received: @ARGV\n";


sub give_help
{


print <<"END_OF_HELP"
Test command line arguments and switches are working properly

$0 -switch1 -switch2 ... arg1 arg2 arg3 ...
command line switches:

  -help     give this help message
  -kill     do the kill thing
  -boot     do the boot thing
  -halt     do the halt thing

The switches do not really do anything but are there to just
ensure that the 'perl -s' switch is actually working as it should.

Any other arguents will then be printed that are passed and are
not real valid arguments.

END_OF_HELP

  ;

exit 1;

}
