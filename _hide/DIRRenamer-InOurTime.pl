
my @list = glob("inourtime*.mp3");
my $cd = 0;

foreach $dir (@list){
	my($waste, $keep) = split(/[-_]/,$dir);

	# print format statement
	printf ("\nrename \"$dir\" \"In Our Time - $keep - .mp3\"", $cd++);
	}
