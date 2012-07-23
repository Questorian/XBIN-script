# twctmag.pl - generate tw (tiddlywiki) markup for annual contents table
# 2012-01-10 14:59:29 - fjb

my $year = shift || 2013;

print "c't Reference - $year\n";

print "link to $year: \n";
print "!Notable Articles - $year\n";

print "|Issue|DVD|Remarks|h\n";
foreach my $edition ( reverse( 1 .. 26 ) ) {
    print "|$edition/$year|||\n";
}

print "tag: ct reference\n";
