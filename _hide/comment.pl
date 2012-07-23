#!/usr/bin/perl

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

if ($ARGV[0] eq "-comment")
{
   $selection =~ s/^/\#/mg;
}
elsif ($ARGV[0] eq "-uncomment")
{
   $selection =~ s/^\#//mg;
}

print $selection;

