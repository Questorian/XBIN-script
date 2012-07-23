my $lower = shift;
my $upper = shift;

print int (rand ($upper - $lower + 1) + $lower);