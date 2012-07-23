@filetypes = qw(*.zip *.mp3 *.pl);
@filedirs = qw(c:/temp //sqsaaa01/inbox/misc);
# @filedirs = qw(c:/temp \\\\sqsaaa01\\inbox\\misc);
@glob_spec = ();

#build-up a complete search spec of pathes and filetypes and assign it to @glob_spec
foreach  $path (@filedirs) { foreach (@filetypes) { push(@glob_spec, join('/',$path,$_))	}}

print "glob filespec: @glob_spec\n";
@flist = <@glob_spec>;
foreach (@flist) {
	# s/\//\\/g; # change the slashes back to what Win32 likes
	print "$_\n";
	}