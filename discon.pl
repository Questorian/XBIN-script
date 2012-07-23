#clean up lagging drives - Could this be the cause of my slow machine?

my @buff = `net use`;

foreach (@buff) {
  if (/^[Disconnected¦Unavailable]/) {
    ($waste, $drv) = split(/\s+/);
    system("net use $drv /del\n");
  	}
	}
