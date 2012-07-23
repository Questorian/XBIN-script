
use strict;
use File::Find ();

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

#number of days to hold a new track for
my $age = 3;

# check the command line args and use that for the age
if ($#ARGV == -1 ) {
	#print "No file age specified will use default age: $age";
}
else {
	$age = $ARGV[0];
	# print "age set to $age";
}


# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, '.');
exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    ( /^.*\.wma\z/s ||
	/^.*\.mp3\z/s ) &&
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    (int(-C _) < $age) &&
    print("$name\n");
}

