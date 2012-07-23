my $factorial = 1;

foreach my $num ( $factorial .. $ARGV[0] ) {
    $factorial *= $num;
}

print "$factorial\n";
