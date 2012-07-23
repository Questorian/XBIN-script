#!/usr/bin/perl
# Author:	David Ljung Madison <DaveSource.com>
# See License:	http://MarginalHacks.com/License

sub show {
  my ($a) = @_;

  # Handle shifts first
  if ($a =~ /^(.+)(<<|>>)(.+)$/) {
    my ($l,$s,$r) = ($1,$2,$3);
    $l=show($l);
    $a= $s eq "<<" ? $l<<$r : $l>>$r;
  }

  # Type?
  if ($a =~ /^0?b()([01]+)$/i || $a =~ /^([01]*)([01]{32})$/) {
    # Binary
    $a=$2;
    show("0b$1") if ($1);
    $dec=unpack("N",pack("B32",substr(("0"x32).$a,-32)));
  } elsif ($a =~ /^0x[0-9a-f]+$/i || $a =~ /^[0-9a-f]*[a-f][0-9a-f]*$/i) {
    # Hex
    $dec=hex($a);
  } elsif ($a =~ /^0[0-7]+$/) {
    # Octal
    $octal=1;
    $dec=oct($a);
  } elsif ($a =~ /^-?\d+$/) {
    # Decimal
    $dec=$a;
  } else {
    print "[$0]  Error:  Unknown data? [$a]\n";
    exit -1;
  }

  printf "0x%0.8x = ",$dec;
  my $b=unpack("B32",pack("N",$dec));
  my @b=grep(!/^$/, $octal ? split(/(...)/,$b) : split(/(....)/,$b));
  print "@b = ";
  printf "0%o = %d\n",$dec,$dec;
  $dec;
}

map(show($_), @ARGV);

