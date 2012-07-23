use strict;
use warnings;

use Getopt::Long;

my $input_file;
my @items;
my $linkable
  ;    # when a file is passed should they put in the table as links to Tiddlers
my $no_header;     # we do NOT want a header row

my $res = GetOptions(
    'input_file=s' => \$input_file,
    'linkable'     => \$linkable
);

if ( $input_file && -f $input_file ) {

    # slurp in the file
    open( my $f, '<', $input_file );
    while (<$f>) {
        chomp;
        my $item = $_;

        # do we want to create Tiddler links?
        if ($linkable) {
            $item = '[[' . $item . ']]';
        }
        push( @items, $item );
    }

}

#tbd - get this working with options
#GetOptions('number' => \$number);
my $columns   = shift || 2;
my $rows      = shift || 2;
my $direction = shift || 'a';    # a = ascending; d = descending

if (@items) {
    $rows = @items;
}

$columns++;

# print the header row
if (! $no_header) {
  print '|#|', '|' x ($columns - 2), 'h', "\n";
	}

if ( lc($direction) eq 'd' ) {
    do {
        if (@items) {

            # print the item from the input file
            print "|$rows|", shift @items, '|' x ( $columns - 2 ), "\n";
        }
        else {

            #print normal empty table
            print "|$rows", '|' x ( $columns - 1 ), "\n";
        }
    } while ( $rows-- > 1 );
}

# we want ascending order
else {
    for ( my $i = 1 ; $i <= $rows ; $i++ ) {
        if (@items) {

            # we have a list of items
            # print "|$i|", shift @items, '|' x ( $columns - 2 ), "\n";
            print "|", shift @items, '|' x ( $columns - 2 ), "\n";
        }
        else {

            print "|$i", '|' x ( $columns - 1 ), "\n";
        }
    }
}

