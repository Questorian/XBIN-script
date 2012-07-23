 use Win32::AdminMisc;

 my $iCount = 0;
 if( 0 == scalar @ARGV )
 {
   Syntax();
   exit;
 }

 foreach my $File ( @ARGV )
 {
   my %Info;

   $iCount++;
   print "$iCount) $File  ";
   if( -f $File )
   {
     if( Win32::AdminMisc::GetFileInfo( $File, \%Info ) )
     {
       print "\n";
       foreach my $Attr ( sort( keys( %Info ) ) )
       {
         next if( ref $Info{$Attr} );
         Display( $Attr, $Info{$Attr} );
       }

       if( $Info{FileInfo} )
       {
         Display( "Internal Info:" );
         foreach my $Attr ( sort( keys( %{$Info{FileInfo}} ) ) )
         {
           next if( ref $Info{FileInfo}->{$Attr} );
           Display( "  $Attr", $Info{FileInfo}->{$Attr} );
         }
       }
     }
     else
     {
       print "unable to get version.\n";
     }
   }
   else
   {
     print "unable to locate file.\n";
   }

 }

 sub Display
 {
   my( $Attr, $Data ) = @_;

   print "\t$Attr";
   if( "" ne $Data )
   {
     print "." x ( 20 - length( $Attr ) ), "$Data";
   }
   print "\n";
 }

 sub Syntax
 {
   my( $Line ) = "-" x length( $0 );

   print <<EOT;

 $0
 $Line
 Display version information on a particular file.

 Syntax:
   perl $0 File[, File2[, ... ]]]

 EOT
 }