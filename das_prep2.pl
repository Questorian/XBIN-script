# script to go only one dir lever down and check that all the files are
# named correctly (i.e. according to the directory name)

use strict;
use File::Copy;

my (@dirlist, $dir, @subdirlist, $file, @buff, $num, $count, $newname);

#set the renamed files count 
$count = 0;

@dirlist = <*>;
foreach $dir (@dirlist) {
	if (-d $dir) {
		print "\nchecking: $dir";
		chdir($dir);

		#check each of the files in the subdirectory so that they are correctly named
		@subdirlist = (<*.mp3>,<*.wma>);
		foreach $file (@subdirlist) {
			print "\n $file";

		#split the name down, if we do not get two then ignore it..
		@buff = split(/-/, $file);
		$num = @buff;
		if ($num == 2) {
			#it is a valid two part music filename, we want to check now that the first part (i.e. the 
			#artists name is exactly the same as the current directories name and if not, then to make it
			#so, number one.


			# take trailing space off name before making comparision
			$buff[0] =~ s/\s+$//;

			# print ", artist name: $buff[0], title: $buff[1]";

			if ($buff[0] ne $dir) {
				#the file does not match the directory name so we must rename it
				$count ++;
				$newname = $dir." -".$buff[1];
				move($file, $newname);
				print " -> $newname";
				}

			}

		}
	chdir ("..");
	}


}