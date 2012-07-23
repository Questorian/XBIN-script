use Win32::OLE;
use Win32::OLE::Const 'Microsoft Outlook';

$outlook = new Win32::OLE('Outlook.Application');
$mailitem = $outlook->CreateItem(olMailItem);
die "Can't create mailitem, $!, $^E" unless($mailitem);

my $to = shift || die "You must supply a destination\n";
$| = 1;
print "Subject: ";
my $subject = <STDIN>;
chomp $subject;

my $body;
print "Message:\n";
while(<STDIN>)
{
    $body .= $_;
}
$mailitem->{To} = $to;
$mailitem->{Subject} = $subject;
$mailitem->{Body} = $body;
$mailitem->Send();
print "Message queued\n";

