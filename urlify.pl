# usage: perl -n urlify.pl <urlfile.txt>


chomp; print "<a href=\"$_\">$_</a><br>\n";