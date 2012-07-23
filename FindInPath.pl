#   FindInPath.pl
#   -------------
#   Simple program that looks for a file in the path
#   Syntax:
#       perl FindInPath.pl <file name>
#
#   Examples:
#       perl FindInPath.pl cmd.exe
#       perl FindInPath.pl cmd*
#
#   2002.01.20 rothd@roth.net
#
#   Permission is granted to redistribute and modify this code as long as 
#   the below copyright is included.
#
#   Copyright © 2002 by Dave Roth
#   Courtesty of Roth Consulting
#   http://www.roth.net/

use File::DosGlob qw( glob );

if( 0 == scalar @ARGV )
{
    print "$0 file [file2 [file3 [...]]]";
    exit;
}    
@Dirs = split( ";", $ENV{PATH} );
foreach my $File ( @ARGV )
{
    foreach my $Dir ( @Dirs )
    {
        my $Path = "$Dir\\$File";
        # Very pathetic hack to handle spaces in a path. Since
        # the default glob() functions fails with embedded spaces we
        # have to rely on File::DosGlob which forces us to do this crap.
        my $DosGlobPath = $Path;
        $DosGlobPath =~ s#\\#/#g;
        $DosGlobPath =~ s/(\s)/\\$1/g;
        foreach my $Location ( glob( $DosGlobPath ) )
        {
            $Location =~ s#/#\\#g;
            printf( "  % 3d) '%s'\n", ++$iCount, $Location );
        }    
    }
}

