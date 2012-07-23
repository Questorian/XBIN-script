use Win32::Env;

my $drv_xbin = 'v';
my %path;
my $pathfile = 'V:\\_data\\PathAdd.txt';
my $newpath;



# Retrieving value
my $sys_path=GetEnv(ENV_SYSTEM, 'PATH');

foreach my $element ( split(/;/,$sys_path)) {

  #increment count
  $path{$element} ++;
  print "$element\n";
	}

# add the elements from the file
open($F, $pathfile);
while (<$F>) {
  chomp();
  my $new = $drv_xbin . ":\\" . $_;
  print "from the file: $new\n";
  $path{$new} ++;

	}

# add the root of XBIN drive itself
  $path{$drv_xbin . ":\\"} ++;

# now print out the completed path
foreach my $element  (sort (keys (%path))) {
  $newpath .= $element .';';
	}
print "new completed PATH: $newpath\n";

# Retrieving value
SetEnv(ENV_SYSTEM, 'PATH', $newpath, 1);

BroadcastEnv();
