#-------------------------------------------------------------------------
#
# logGet.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# logGet.pl: collect SCCM log files from clients and servers
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2009-08-26T13:40:18
# TBD:      Files with wildcards - how to represent in INI file?
# History:
#
#       v0.6 - 2010-01-26 - added -group option in INI file, refactored code,
#                               ensure each machine is only processed once
#       v0.5 - 2010-01-18 - INI extensions of 'alias' options - Mainly for
#                               ConfigMgr Site Codes
#                           Removed the default list of servers from run
#                           Removed teh default list of types
#       v0.4 - 2010-01-15 - minor change - renamed -host option (was -server)
#                           This refelcts that tool is for all types of hosts
#       v0.3 - 2010-01-14 - added support for glob filespecs in INI
#		v0.2 - 2009-09-15 - now supports types, and an INI file
#                               types: sql, sccm, iis logs
#		v0.1 - 2009-08-26 - initial version created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2009, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;
use Getopt::Long;
use File::Spec;
use File::Copy;
use DateTime;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Config::Tiny;
use List::MoreUtils qw(uniq);

# global variables - command line args
my $help;
my $host;
my $backup;
my $zip;
my $type;
my $alias;
my $group;

my $folder;

my $debug = 0;
my $ini   = "v:\\_data\\ini\\LogGet.ini";
my $conf;
my $datestr_today;

my @action_hosts;
my @action_logs;
my @action_ext;
my @action_types;

# call the main function
logGet(@ARGV);

### Main Function ###
# Usage     : logGet()
# Purpose   : logGet -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub logGet {
    my ($v) = @_;

    # parse the command line arguments if any
    my $result = GetOptions(
        "help"    => \$help,
        "host=s"  => \$host,
        "alias=s" => \$alias,
        "backup"  => \$backup,
        "zip"     => \$zip,
        "type=s"  => \$type,
        "group=s" => \$group,

    );

    if ($help) {
        give_help();
    }

    # initialise - mainly read the ini file
    initialise($ini);

    if ($host) {
        push( @action_hosts, split /,/, $host );
    }

    if ($alias) {
        push( @action_hosts, resolve_alias($alias) );
    }

    if ($group) {
        push( @action_hosts, resolve_groups($group) );
    }

    if ($type) {
        push( @action_types, split /,/, $type );
    }

    # action it
    get_logs();

    # compress contents if necessary
    if ($zip) {

        zip_folder();

        # remove the folder because now we have a zip folder
        print "removing working folder: $folder\n";
        system("rd /s /q $folder");

    }

    return;
}

sub resolve_groups {
    my ($groups) = @_;
    my @hosts;

    foreach my $gname ( split /,/, $groups ) {
        push( @hosts, ( split /,/, $conf->{groups}->{$gname} ) );
    }

    @hosts;

}

sub resolve_alias {
    my ($alias_string) = @_;
    my @hosts;

    # map the ini file alias to the hostname
    foreach my $alias ( split /,/, $alias_string ) {
        push( @hosts, $conf->{aliases}->{$alias} );
    }

    @hosts;
}

sub get_logs {
    my ($v) = @_;

    # remove duplicates from @action_hosts if they are there
    @action_hosts = uniq(@action_hosts);

    foreach my $hostname (@action_hosts) {

        print "Host: $hostname\n";

        foreach my $type (@action_types) {

            print "processing type: $type\n" if $debug;

            foreach my $file ( split /,/, $conf->{$type}->{logs} ) {

                foreach my $ext ( split /,/, $conf->{$type}->{extensions} ) {

                    # tbd - folders is plural - another loop is needed
                    my $filespec =
                      $conf->{$type}->{folders} . '\\' . $file . $ext;

                    # glob - maybe this filespec
                    print "checking filespec: $filespec\n";
                    my @file_list = get_files( $hostname, $filespec );
                    foreach my $filepath (@file_list) {

                        # replace the ':' with a '$' if present because this
                        # will be UNC administrative path
                        $filepath =~ tr/:/\$/;

                        copy_file( $hostname, $type, $filepath );

                    }

                }

            }

        }

    }

}

sub get_files {
    my $server   = shift;
    my $filepath = shift;

    my $filespec = build_UNC( $server, $filepath );
    $filespec = w2u($filespec);

    glob($filespec);
}

sub w2u {
    my ($path) = @_;

    # convert Windows path to Unix style - usefull for globbing
    $path =~ s|\\|/|g;

    $path;
}

sub u2w {
    my ($path) = @_;

    # convert Unix Style paths to windows
    $path =~ s|/|\\|g;

    $path;
}

sub build_UNC {
    my $server = shift;
    my $path   = shift;

    # replace ':' with '$' if it exists in the pathname
    $path =~ tr/:/\$/;

    # build the path
    '\\\\' . $server . '\\' . $path;

}

sub copy_file {
    my ( $host, $type, $source ) = @_;

    # make a folder for the host
    my $host_dir = $folder . '\\' . $host;
    mkdir($host_dir);

    # now make the type specific directory
    $host_dir .= '\\' . $type;
    mkdir($host_dir);

    if ( !-f $source ) {
        print "WARNING: unable to open file: $source\n";
    }
    else {

        my ( $vol, $path, $fname ) = File::Spec->splitpath($source);
        my $target = $host_dir . '\\' . $fname;
        print "$source -> $target\n";
        copy( $source, $target );
    }

}

sub initialise {
    my ($ini_file) = @_;

    # read the ini file configuration

    # open the config file
    $conf = Config::Tiny->read($ini_file);

    # get the current date into a string for later use
    #timestamp to use with the directory name
    my $dt =
      DateTime->now( time_zone => $conf->{_}->{TimeZone} || 'Europe/Zurich' );
    $datestr_today = $dt->ymd;

    # set some globals
    # ----------------

    # base folder name
    $folder = $conf->{_}->{CacheFolder} || 'c:\\temp';
    $folder .=
      '\\' . ( $conf->{_}->{LogFilePrefix} || 'Logs-' ) . $datestr_today;

    # make the new logGet folder, if it does not already exist
    if ( !-d $folder ) {
        mkdir($folder) or die "unable to create log folder: $folder";
    }

    if ($debug) {

        print "opening ini file: $ini_file\n";
        print "Log Folder: $folder\n";

        print "DateTime str: $datestr_today\n";
    }

}

sub zip_folder {
    my ($v) = @_;

    print "compressing: $folder\n";

    my $zip = Archive::Zip->new();

    print "adding folder: $folder\n";
    $zip->addTree($folder);

    my $fname = $folder . '.zip';
    print "creating new zip archive: $fname\n";
    unless ( $zip->writeToFileNamed($fname) == AZ_OK ) {
        die "write error on archive: $folder";
    }

}

sub prepare_target_folder {
    my ($v) = @_;

    #timestamp to use with the directory name
    # respect the correct TimeZone in INI file or use ZRH if not present
    my $dt =
      DateTime->now( time_zone => $conf->{_}->{TimeZone} || 'Europe/Zurich' );

    # create the target folder
    $folder = $folder . "\\Logs-" . $dt->ymd;
    mkdir($folder) or die "unable to create folder $folder";

}

sub give_help {
    my ($v) = @_;

    print <<"END_OF_HELP";

Options:
  -h    help

END_OF_HELP

    exit 0;
}

__END__

=head1 LogGet.pl - Copy Log files from remote hosts to local machines

=head1 INI File Format

Here is a sample of the INI file format used for the this script. you will
want to add your own types and extend it, and customise for your own personal
operating environment:

    ; LogGet.ini

    ; Global Flags
    ; ------------
    l_use_cache=1
    l_enable_ConfigMgr_site_codes=0
    l_check_and_archive=0


    ; Global Parameters
    ; -----------------
    ;LogFilePrefix=Logs-
    CacheFolder=c:\temp\LogGet
    ArchiveFolder=C:\QS\PERSONA\NESTLE\CONFIG\_Environments\_incidents\2010
    LogViewer=ed
    LogFolder=c:\temp
    TimeZone=Europe/Zurich
    ArchiveAfterDays=28


    ; host-groups - use these to convienently specify clusters of machines
    ; -----------
    [groups]
    core=HQBUSM0100,USPHXM0100,AUBAUM0007,DEMDCM0048
    rcore=HQBUSM0101,HQBUSM0100,USPHXM0100,AUBAUM0007,DEMDCM0048
    central=HQBUSM0101,HQBUSM0100,HQBUSM0100
    tier2=USPHXM0100,AUBAUM0007,DEMDCM0048


    ; file classes - file types parameter
    ; ---------------

    ; A - On Windows workstation machines
    [ccm]
    logs=*
    extensions=.log
    folders=C:\Windows\System32\CCM\Logs

    ; B - On Windows server machines

    [badmifs]
    logs=*
    extensions=.mif
    folders=F:\SMS\inboxes\auth\dataldr.box\BADMIFS

    [dataldr]
    logs=dataldr,ddm
    extensions=.log,.lo_
    folders=F:\sms\logs

    [sql]
    logs=ERRORLOG,SQLAGENT
    extensions= ,.1,.2,.3,.4,.5,.6
    folders=G:\mssql\PSPAC01\MSSQL.1\MSSQL\LOG
    warn_max_size_mb=5

    [cm]
    logs=*
    extensions=.log,.lo_
    folders=F:\sms\logs

    [cmmin]
    logs=Smsdbmon,Hman,Sitectrl,Adsysdis
    extensions=.log,.lo_
    folders=F:\sms\logs

    [iis]
    ;careful! there can be hundreds of these files
    logs=*
    extensions=.log
    folders=F:\LogFiles\W3SVC1

    [nestle]
    logs=c400*
    extensions=.log
    folders=C:\Program Files\Nestle\Logs

    [tsm]
    logs=dsmsched,dsmerror,dsierror
    extensions=.log
    folders=C:\Program Files\Tivoli\Tsm\baclient

    [shop]
    logs=ShoppingCentral,ShoppingCentralSrv
    extensions=.log,.lo_,.log.1,.log.2,.log.3,.log.4,.log.5
    folders=F:\1e\ShoppingCentral\Logs
    servers=DEMDCM0046,USPHXM0104,AUBAUM0005

    [wbem]
    logs=mofcomp,wmiprov,wbemcore,winMgmt,wmiadap,wbemprox,wbemess
    extensions=.log,.lo_
    folders=C:\WINNT\system32\wbem\Logs

    [aliases]
    ; note that aliases are case sensitive - like all INI file entries
    A10=USPHXM0101
    AE1=AEJEBM0000
    AE2=AEDBWM0000

=head1 TBD

Here are the next things to be done in their order of importance:

  * fix - copy fails when there is a space in the pathname - urgent!
  * write some test cases - need more testing routines
  * remove - filepath handling functions to a generic QS library  - reuse
  * remove - get_files() into QSLib too. This is a very useful fucntion
  * generalise the copy_files() function - extract to generic QSLib as well?
  * exit-action - Explorer, Zip, Open in Editor, Attach in Email
  * automatically create an email and add the files to the email
  * no-copy option - just show which files will be copied
  * logging of copies files?
  * ping check if remote host is up before starting copy
  * add a max_age parameter the file specs - i.e. 5 days or younger


=head1 COMPLETED

And here the completed:

  * tidy-up the script
  * Add facility for grouping servers together (i.e. tier1, tier2, shopping, etc)
