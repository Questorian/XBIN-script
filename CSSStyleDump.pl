my %css_class;


while(<>){
  if (/class="(.*?)"/ig) {
    $css_class{$1} ++;
  	}
}

foreach my $class (sort (keys (%css_class))) {
  print "$class - $css_class{$class}\n";
	}