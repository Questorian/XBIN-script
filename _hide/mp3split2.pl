#!/usr/local/bin/perl
require 5;
package Audio::MP3Split;  # Yes, it's also a module!
$VERSION = '1.01';

use strict;
use warnings;
use integer;
use vars ('$K');

unless(defined $K) { # default chunk size, in kilobytes
  $K = 1000;
  if(($ENV{'MP3SPLITKLENGTH'} || '') =~ m/^(\d+)$/) {
    $K = (0 + $1) || $K;
  }
}

unless(caller) {
  if( @ARGV and $ARGV[0] =~ m/^-[kK](\d+)$/s ) {
    $K = 0 + $1;
    shift @ARGV;
    die "Can't have a 0K MP3 file!\n" unless $K;
  }

  @ARGV or die "Usage:
mp3split files...
mp3split -kNUMBER files...
 Split mp3 files into roughly NUMBER kilobyte long segments.

Example:
  mp3split -k5000 speech.mp3
...splits speech.mp3 into roughly five-meg-long mp3s named
like speech.mp3.000, speech.mp3.001, speech.mp3.002, etc.

This program performs a simple binary split (so you can just cat the
chunks together, in order!, and get the original file back), except
that it only splits on MP3 frame boundaries, so that each segment is
a playable MP3 file on its own.

sburke\x40cpan.org
\n";

  foreach my $x (@ARGV) {
    print "$x\n";
    mp3_chunk($x);
  }
  print "Done.\n";
}

sub mp3_chunk {
  use Carp;
  my $in = $_[0];
  my $byte_limit = $K * 1024;
  croak "undef isn't a good filespec" unless defined $in;
  croak "empty-string isn't a good filespec" unless length $in;
  croak "$in isn't a readable file\n" unless -e $in and -f $in and -r $in;
  if(-s $in  < $byte_limit) {
    print "$in is already under $byte_limit bytes long!  Skipping.\n";
    return;
  }
  
  open(MP3IN, "< $in") or croak "Can't read-open $in: $!";
  binmode(MP3IN);
  
  my $byte_count;
  my $this_file_name;
  my $new_in = $in;
    $new_in =~ s/.mp3$//i;
  my $next_file = do {   # a lambda to kick open a new file
    my $counter = '000';
    sub {
      # $this_file_name = sprintf "%s.%03d", $in, $counter++;
      $this_file_name = sprintf "%s - %03d.mp3", $new_in, $counter++;
      close(MP3OUT) if fileno(MP3OUT);
      #print "Write-opening $this_file_name...\n";
      open(MP3OUT, "> $this_file_name")
       || carp "Can't write-open to $this_file_name: $!";
      binmode(MP3OUT);
      $byte_count = 0;
      return;
    }
  };
  
  $next_file->(); # start us out.
  
  my $buffer = '';

  #Frame starts on two bytes:
  #  AAAAAAAA AAAxxxx
  #  11111111 111xxxx

  while(1) {
    read(MP3IN, $buffer, 4096, length($buffer))
      || do {print MP3OUT $buffer if length $buffer; last};
    
    if($buffer =~ m/\A([^\xFF]*)(\xFF)(.*)\z/s) {
      unless(length $3) {  # We end on what might be a start-of-frame!
        if(length $1) {
          $byte_count += length($1);
          print MP3OUT $1;
          substr($buffer, 0,length($1)) = '';
        }
        next;
      }
      unless(ord($3) >= 224) {  # 0b1110_0000
        # Not really the start of a frame.  Ahwell.
        $byte_count += length($1) + length($2);
        print MP3OUT $1, $2;
        substr($buffer, 0, 1 + length($1)) = '';
        next;
      }

      # Otherwise it's a start-of-frame!
      if(length $1) {
        $byte_count += length($1);
        print MP3OUT $1;
      }
      # Only place we get to split is here!
      $next_file->() if $byte_count > $byte_limit;
      print MP3OUT $2, $3;
      $byte_count += length($2) + length($3);
      $buffer = '';
      
    } else {
      # No synch in this buffer
      $byte_count += length($buffer);
      print MP3OUT $buffer if length $buffer;
    }
  }
  close(MP3OUT) if fileno(MP3OUT);
  close(MP3IN);
  return;
}
1;

__END__

=head1 NAME

mp3split -- split an mp3 into smaller mp3s, with no data lost or added

=head1 SYNOPSIS

  c:\music> dir L*
       3,204,288  04-01-2002 12:22a Lomec (Spring Anthem).mp3

  c:\music> mp3split -k450 "Lomec (Spring Anthem).mp3"
  Lomec (Spring Anthem).mp3
  Done.

  c:\music> dir L*
       3,204,288  04-01-2002 12:22a Lomec (Spring Anthem).mp3
         462,877  04-11-2002  5:18a Lomec (Spring Anthem).mp3.000
         462,856  04-11-2002  5:18a Lomec (Spring Anthem).mp3.001
         462,812  04-11-2002  5:18a Lomec (Spring Anthem).mp3.002
         462,856  04-11-2002  5:18a Lomec (Spring Anthem).mp3.003
         462,839  04-11-2002  5:18a Lomec (Spring Anthem).mp3.004
         463,232  04-11-2002  5:18a Lomec (Spring Anthem).mp3.005
         426,816  04-11-2002  5:18a Lomec (Spring Anthem).mp3.006

=head1 DESCRIPTION

If you use just any splitter program (like Unix C<split>) to split up
an mp3 file, the chunks are not themselves valid MP3 files.  But
C<mp3split> splits an mp3 file into chunks which I<are> each valid
mp3 files.

=head1 SWITCHES

C<-kI<number>> sets the chunk size to that many kilobytes.
For example, C<-k5000> means to try generating 5M chunks.

=head1 ENVIRONMENT

If the environment variable C<MP3SPLITKLENGTH> is set to a number, then
it's used as the default size, in K, to use.  (Otherwise it defaults
to 1000, i.e., one meg.)

=head1 BUG REPORTS

Email me any bug reports!  But don't attach MP3 files to the
email and say "Your program split this up wrong!".

=head1 DISCLAIMER

C<mp3split> is distributed in the hope that it will be useful,
but B<without any warranty>; without even the implied warranty of
B<merchantability> or B<fitness for a particular purpose>.

=head1 COPYRIGHT

Copyright 2002 Sean M. Burke.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

Sean M. Burke, E<lt>sburkeE<64>cpan.orgE<gt>

=head1 README

Takes any mp3 file and performs a simple binary split (so you can just
cat the chunks together to get the original) -- except that it only
splits on MP3 frame boundaries, so that each segment is a valid playable
MP3 file on its own.

=head1 SCRIPT CATEGORIES

Audio/MP3

=head1 CHANGE LOG

=over

=item v1.01 2002-04-11

First public release.

=back

=cut


