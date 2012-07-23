#!/usr/bin/perl -w

# found on - https://codesamples.projects.dev2dev.bea.com/servlets/ReadMsg?listName=issues&msgNo=423

&smash(".");

sub smash {
      my $dir = shift;
      opendir DIR, $dir or return;
      my @contents =
        map "$dir/$_",
        sort grep !/^\.\.?$/,
        readdir DIR;
      closedir DIR;
      foreach (@contents) {
        next unless !-l && -d;
        &smash($_);
        if ($_ =~ '.svn'){
        print "$_\n";
        cleanup($_);
        }
      }
    }

sub cleanup {
        my $dir = shift;
        local *DIR;

        opendir DIR, $dir or die "opendir $dir: $!";
        my $found = 0;
        while ($_ = readdir DIR) {
                next if /^\.{1,2}$/;
                my $path = "$dir/$_";
                unlink $path if -f $path;
                cleanup($path) if -d $path;
        }
        closedir DIR;
        rmdir $dir or print "error - $!";
}
