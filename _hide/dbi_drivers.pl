    #!/usr/bin/perl

    use strict;
    use DBI;
    my @drivers=DBI->available_drivers();
    print join("\n",@drivers);
    print "n";