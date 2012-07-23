#! /Users/jj/bin/perl5.10.0

# copyphotos.pl - transfers images from camera or memory card, 
#                 renaming files based on timestamp in EXIF data
#
# Usage: copyphotos.pl [options] <source_path> <destination_path>
#
# Written by Jon Allen <jj@jonallen.info>
# http://perl.jonallen.info/projects/phototools


#--Load required modules and activate Perl's safety features---------------

use strict;
use warnings;
use Convert::NLS_DATE_FORMAT qw/oracle2posix/;
use Cwd;
use English;
use File::Copy;
use File::Find;
use File::Path;
use File::Spec::Functions qw/catfile catdir splitpath file_name_is_absolute/;
use Getopt::Long;
use Image::ExifTool;
use Time::Piece;
use Time::Seconds;

our $VERSION = '0.06';


#--Check command-line options----------------------------------------------

my %options;
GetOptions(\%options,
  'template=s',
  'offset=i',
  'keyword=s@',
);

my $usage           = "Usage: $0 [options] <source_path> <destination_path>";
my $source_dir      = $ARGV[0] or die "$usage\n";
my $destination_dir = $ARGV[1] or die "$usage\n";
my $template        = $options{template} || 'YYYY/MM/DD/YYYY-MM-DD_HH24-MI-SS';
my $offset          = $options{offset} || 0;


#--Define action to take for each file-------------------------------------

my %find_options;
$find_options{no_chdir} = 1;
$find_options{wanted}   = sub { 
  if (/(\.)jpg|jpe|jpeg|tif|tiff$/i) {
    copy_rename(
      source      => $File::Find::name,
      destination => $destination_dir,
      template    => $template,
      offset      => $offset,
      keywords    => $options{keyword} || [],
    );
  }
};

find(\%find_options, $source_dir);

exit(0);


#--------------------------------------------------------------------------
#--------------------------------------------------------------------------

sub copy_rename {
  my %args = @_;
  
  # Get timestamp of source file and apply time zone offset
  my $time = exif_timestamp($args{source}) + $args{offset} * ONE_HOUR;
  # my $time = exif_timestamp($args{source}) + $args{offset} * ONE_MINUTE; 
  print "time is: $time\n";

  # Set target filename based on template
  my $target = $time->strftime(oracle2posix($args{template}));
  
  # Add destination directory
  $target = catfile($args{destination},$target);
  
  # Create target directory (unless it already exists)
  my ($vol,$dir,$file) = splitpath($target);
  my $target_directory = (file_name_is_absolute($target)) ?
                         catdir($vol,$dir) : catdir(getcwd(),$dir);
                         
  unless (-d $target_directory) {
    eval { mkpath $target_directory }
      or die "Could not create directory $target_directory\n";
  }

  # Add file extension
  my $extension   = ($args{source} =~ /\.(\w+)$/) ? $1 : '';
  my $destination = ($extension) ? "$target.$extension" : $target;

  # If destination file exists, append sequence number to filename
  if (-e $destination) {
    my $suffix = 0;
    do {
      $suffix++;
      $destination = ($extension) ? $target."_$suffix.$extension" : $target."_$suffix";
    } while (-e $destination);
  }

  # Print status message and copy file
  {
    local $OUTPUT_AUTOFLUSH = 1;     
    print "Copying $args{source} to $destination ... ";
  }  
  if (copy($args{source},$destination)) {
    print "OK\n";
  } else {
    print "FAILED: $!\n";
    return;
  }
  
  # Set keywords of destination file
  set_keywords($destination,$args{keywords});
}


#--------------------------------------------------------------------------

sub exif_timestamp {
  my $filename = shift;
  my $format   = '%Y:%m:%d:%H:%M:%S';
  my $exif     = Image::ExifTool->new();
  my $tags     = $exif->ImageInfo($filename,{DateFormat=>$format});
  
  return Time::Piece->strptime("2010:04:21:17:30:30",$format);
}


#--------------------------------------------------------------------------

sub set_keywords {
  my ($filename,$keywords) = @_;
  return unless @$keywords;
  
  my $exif = Image::ExifTool->new();
  $exif->SetNewValuesFromFile($filename);
  $exif->SetNewValue('Keywords',$keywords);
  $exif->SetNewValue('XPKeywords',join ', ',@$keywords);
  $exif->WriteInfo($filename);
}

