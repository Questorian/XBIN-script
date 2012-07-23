@rem = ' 
@echo off 
perl -S %0.cmd 
goto endofperl 
@rem '; 

# a Perl script that thinks it's  a batch 

print "Hello World\n"; 
exit (0); 

# end script. 
# these lines required. 
__END__ 
:endofperl 
