# tool to add/remove in line comments to a stream of text.  This would be callded from an editor normally
local $/;
$selection = <STDIN>;
$inline_comment_char = '#';
$ext = $ARGV[1];

#now we find out what kind of source code file we have
if ($ext eq "sql") {
	$inline_comment_char = '--';
	}
if ($ext eq "cmd") {
	$inline_comment_char = '::';
	}

if ($ext eq "txt") {
	$inline_comment_char = '* ';
	}
if ($ext eq "ini") {
	$inline_comment_char = ';';
	}


#now do it
if ($ARGV[0] eq "-comment")
{
   $selection =~ s/^/$inline_comment_char/mg;
}
elsif ($ARGV[0] eq "-uncomment")
{
   $selection =~ s/^$inline_comment_char//mg;
}

print $selection;

