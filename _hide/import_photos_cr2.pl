#! C:\Program Files\Perl\bin\perl.exe -w
eval 'exec C:\Program Files\Perl\bin\perl.exe -S $0 ${1+"$@"}'
  if 0;    #$running_under_some_shell

use strict;
use File::stat;
use File::Find ();
use File::Basename;
use File::Copy;
use Win32::File();

# pnl = PhotoNameList
my @PNL;

#all of the new photos on the input queue
my @NNL;

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

#now look to the environment for these values.
# these have seen initialised in the previous batch file ImportPhotos.cmd
my $input_path   = $ENV{"PHOTODIR"};
my $album_root   = $ENV{"QS_TARGET_ALBUM"};
my $workflow_dir = $ENV{"QS_PHOTO_WORKFLOW_DIR"};

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name  = *File::Find::name;
*dir   = *File::Find::dir;
*prune = *File::Find::prune;

#traverse the existing photoalbum and build an array to check for collisions

# Traverse desired filesystems

print "\nsource of photos (CR2 version): $input_path";
print "\nCurrent album (used to check for name collisions): $album_root";
print "\nWorking directory for photos: $workflow_dir";
print "\nLooking all the existing photos in the photoalbum ($workflow_dir)";

#process the output directory to build list of photo names already in existence
BuildPNL();
my $num = @PNL;

#print "we have $num photos in the album, and here they are:";
#foreach $name (@PNL) {
#	print "\nfile: $name";
#}

#process the input directory
File::Find::find( { wanted => \&wanted }, $input_path );

#now sort the data that we want
my $file;
@NNL = sort(@NNL);
foreach $file (@NNL) {
    MovePhoto($file);
}
print "\n";
exit;

sub BuildPNL() {

    print
"\nbuilding list of names of photos already existing in photo album library: ";

    print "\n\tchecking: $album_root";
    File::Find::find( { wanted => \&wantedPNL }, $album_root );

    print "\n\tchecking: $workflow_dir";
    File::Find::find( { wanted => \&wantedPNL }, $workflow_dir );

}

sub wantedPNL() {

    #note that this one is case-insensitive.
    #we are not looking for JPG and CR2 (Canon RAW format)

    /^.*\.(jpg|cr2)\z/is && 
      push ( @PNL, basename($name) );
}

sub wanted {
    /^.*\.(jpg|cr2)\z/is &&

      # push(@NNL, basename($name))
      push ( @NNL, $name );
}

sub MovePhoto() {
    my ( $file, $file_created, $ctime, $seq, $target_filename, $basename, $path,
        $new_filename, $bpath, $suffix )
      = @_;
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $syear, $lyear );

    # print "\nprocessing: $file";
    if ( $file =~ /THM/ ) { ; }
    else {
        $ctime = stat($file)->mtime;
        ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) =
          gmtime($ctime);

        #short year for photo name
        $syear = $year - 100;

        #long year for album path
        $lyear = $year + 1900;
        $mon += 1;
        $seq      = 1;
        # $basename = basename($file);
        ($basename, $bpath, $suffix) = fileparse ($file, (".jpg", ".JPG", ".cr2", ".CR2"));

        #make sure that the YEAR, MONTH, directories exist..
        $path = $workflow_dir . "\\" . $lyear;
        mkdir($path);
        $path = sprintf( "%s\\%02d", $path, $mon );
        mkdir($path);

        #generate a unique name - PID - Photo ID
        do {
#            $target_filename =
#              sprintf( "%02d%02d%02d%03d.jpg", $syear, $mon, $mday, $seq );
            $target_filename =
              sprintf( "%d-%02d-%02d--P%03d\l%s", $lyear, $mon, $mday, $seq, $suffix );
            $seq++;
        } while ( IsFileInPNL($target_filename) );

        #move the file
        $new_filename = $path . "\\" . $target_filename;
        print("\nmoving $basename: --> $new_filename");
        # move( $file, $new_filename );
        copy( $file, $new_filename );

        #push the new name onto the PNL so that it will not be used again
        push ( @PNL, $target_filename );

    }
}

sub IsFileInPNL()

  # function to check if that name is already in use in the photoalbum
  # retuns: 1 - yes name is in use
  #         0 - name is not in use
{
    my ( $name, $ret, $fname ) = @_;

    $ret = 0;
    foreach $fname (@PNL) {
        if ( $fname =~ /$name/i ) {
            $ret = 1;

            # print "\nWe have found a match!!! $name and $fname";
        }
    }
    $ret;
}

# --- NOT USED
sub create_year() {
    my ( $year, $sub, $i, $path ) = @_;

    $path = $album_root . "\\" . $year;
    mkdir($path);

    #now make the months
    for ( $i = 1 ; $i < 13 ; $i++ ) {
        $sub = sprintf( "%s\\%02d", $path, $i );
        mkdir($sub);
    }
}
