use strict;
use File::Copy;
use File::Basename;

# global variables to the package
my @artist_list;

# prepare files for importation to DAS INBOX

my ($debug, $lib, @lartist, $special_folder);

#directory where we start
#my $dir_start = "C:\\TEMP\\TESTING";
my $dir_start = "C:\\DATA\\CACHE\\P2P";

#directory to place results
my $dir_out = "C:\\DATA\\CACHE\\P2P\\AUDIO\\RTS";

#set the special folder name
$special_folder = "_New_Artists";


my $log = "DAS_prep.log";

my $runtime;

my $split_char = "-";

$debug = 1;
$lib = "\\\\SQSAAA01\\AUDIO\\MUSIC";

# -- start of program

my ($count , @filelist);


my ($artist, $title, $name, @buf, $num, $dir, $dir2, $fname, $pad, $inst, $base, $ext, $lartist, $ret);

$runtime = localtime;

#open the music store library
DAS_OpenLibrary($lib);

#find the new local files..
chdir($dir_start);
@filelist = <*.mp3>;
$count = @filelist;

#open the log
open(LOG, ">>".$log);
print LOG "\n\n*** $runtime\nfound $count files.";
foreach (@filelist) { print LOG "\n$_";}
print LOG "\n --- processing ---";



# create the directory is not there..
mkdir($dir = $dir_out."\\".$special_folder);


#work on those files
$count = 0;
foreach $name (@filelist){

	$count ++;

	#split the name up, and determind how many components we have (seperated by '-' signs)
	@buf = split($split_char, $name,0);
	$num = @buf;

	if ($num <= 1){
		$artist = "unknown";
		$title = $buf[0] ;
		$title = $name ;
		}
	elsif ($num > 2){
		$artist = $buf[0] ;
		$title = $name;
		}
	else{
		$artist = $buf[0] ;
		$title = $buf[1] ;
		}

	# tidy-up the strings
	$title = DAS_StrScrub($title);
	$artist = DAS_StrScrub($artist);
	#first check if the artist is known to us
	$lartist = DAS_IsArtistInLibrary($artist);
	if ($lartist) {
		# we already have music from this guy, and thus the 'correct' was to write the Artists name, so lest use that
		$artist = $lartist;
		#compute target directory name
		$dir = $dir_out."\\".$artist;	
	}
	else {
		# DAS has not yet seen this artist, or more likely the name is slightly wrongly spelt
		# either way we want to move it off to the _New_Artists folder

		# Tidy-up the name, make it presentable
		$artist = DAS_StrScrub($artist);
		#compute target directory name
		$dir = $dir_out."\\".$special_folder."\\".$artist;	

	}


	# Create the directory
	if (-e $dir ){
		# do nothing
		}
	else{
		# make the new dir
		print "\ncreating directory: $dir";
		mkdir ($dir);
		}
	
	# generate the name and move it.. add collision check later...
	$fname = $dir."\\".$artist." - ".$title;
#C:\DATA\P2PCACHE\AUDIO\RTS\_New_Artists\Black Sabath
	print "\nmoving file ($name, $fname)";
	$ret = move($name, $fname);
	print "\nrest = $ret, string $!";
	

	#update the log
	print LOG "\n<$artist> <$title> ($name)";

	
	}

print "\n $count files processed";

###
### DAS (Digital Audio Servies) - API Library functions
###



sub DAS_StrScrub($;)
{
my ($str) = @_;

	#a data scrubbing function par excelence.
	#enforce our data standards here

	# Replace any underscores with spaces
	$str =~ s/_/ /g;


	#take bracketed numbers )(i.e. file name clash), out from the string
	$str =~ s/\(\d+\)//g;


	# 'real' case the string - i.e. capitalise the first letter of each word
	$str =~ s/(\w+)/\u\L$1/g;


	#Fix bugette with letters following an apostrophe
	#str =~ s/'(\w+)/'\l$1/g;


	# handle bugette where letter still capitalised after an apostrophe
	$str =~ s/('\w+)/'\L$1/g;

	
	# regular spacing..That means one space between each 'word'
	$str =~ s/(\s+)/ /g;


	# replace the often occuring pattern of '', with only one '
	$str =~ s/'+/'/g;
	

	# force the .mp3 at the end of the file name into lower case
	$str =~ s/(\.mp3)/\.mp3/i;


	# remove white space at the end of the file name but before the .mp3 extension
	$str =~ s/(\s+)\.mp3/\.mp3/i;


	# same for .wma at the end of the file name into lower case (although this hardly happens)
	$str =~ s/(\.wma)/\.wma/i;


	#future scrubbing to go here


	# remove leading whie space
	$str =~ s/^\s+//;


	# remove trailing white space
	$str =~ s/\s+$//;

	$str;	

}	

sub DAS_OpenLibrary($;)
{
my ($path,$num, $s) = @_;

#check the location and enumerate all 'known' artists
print "\nDAS_OpenLibrary() - Library location: $path" if $debug;

#enumerate list of artists...
chdir($path);
@artist_list = <*>;
$num = @artist_list;
print "\nDAS_OpenLibrary() - Enumerated $num artists in library if $debug";
if ($debug) { foreach $s (@artist_list) { print "<$s> ";}}

#return the array
@artist_list;

}


sub DAS_IsArtistInLibrary($)
{
my($xartist, $found, $entry, $num) = @_;

$num = @artist_list;

print "\nDAS_IsArtistInLibrary() - Current number of artists: $num, Looking for:$xartist" if $debug;

# $found = "";
foreach $entry (@artist_list){
	if ($entry =~ /$xartist/i){
		$found = $entry;
		# break;
		}
	}
print "\nDAS_IsArtistInLibrary() - Lookup result string <$found>" if $debug ;
#reutn the value
$found;
}
