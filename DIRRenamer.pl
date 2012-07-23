
my @list = glob("*");
my $cd = 1;

foreach $dir (@list){
	my($part, $section) = split(/\-/,$dir);
	my ($section) = split(/af/, $section);

	# print format statement
	printf ("\nrename $dir \"A Short History of Nearly Everything $part-$section (CD%0.2d)\"", $cd);
	$cd++;
	}
