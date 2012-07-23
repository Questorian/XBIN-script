#!/usr/bin/perl
# 2005-04-30T17:32:40  - Modified by farley b. to handele other language files

#
#  Comment.pl
#
#  Allows EditPlus to comment and uncomment blocks of 
#  perl code. To use this script, you need to set it up
#  as a "User Tool" in EditPlus.
#
#  The editplus setup is as follows:
#
#  - goto menu Tools | Configure User Tools
#  - click Add Tool | Program
#  - fill in Menu Text and Command like this:
#
#    Menu Text: Comment
#    Command: perl [...\Your_Path_Here\...\]comment.pl
#    Argument: -comment
#
#  - leave initial directory blank
#  - select "Run as Text Filter"
#
#  - click Add Tool | Program again
#  - fill in Menu Text and Command like this:
#
#    Menu Text: Uncomment
#    Command: perl [...\Your_Path_Here\...\]comment.pl
#    Argument: -uncomment
#
#  - leave initial directory blank again
#  - select "Run as Text Filter" again
#
#
#  by:   J. Christopher Bare
#         <christopherbare@yahoo.com>
#         12/10/2001
#


local $/;
$selection = <STDIN>;
$comment_char = '#';

if ($ARGV[1] eq "sql") {
	$comment_char = '--';
	}

if ($ARGV[0] eq "-comment")
{
   $selection =~ s/^/$comment_char/mg;
}
elsif ($ARGV[0] eq "-uncomment")
{
   $selection =~ s/^$comment_char//mg;
}

print $selection;

