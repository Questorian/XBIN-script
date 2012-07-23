#this does not seem to work!

while (<>) {
    chomp();    #yes! DO NOT FORGET ON FILECHECKS!

    if (-r) { print "ok: $_\n" }
    else {
        print "notok: $_\n";
    }

}
