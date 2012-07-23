#!/usr/local/bin/perl
use warnings;
use strict;
use Image::ExifTool qw(:Public);

for (@ARGV) {
    my $info = ImageInfo($_);
    for my $k (sort keys %$info) {
        print "$k => $$info{$k}\n";
    }
}