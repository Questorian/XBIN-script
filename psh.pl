BEGIN {
  $prompt = "\$ psh> ";
  printf $prompt;
  system ("title psh");
}

eval;

$@ ne "" and warn $@;

printf $prompt;


END {
  ! defined and print "";

}