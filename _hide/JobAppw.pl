my ( $ref, $email, $line, $cc,, $speil, $subject, $url, @buff );
my $file = "C:\\temp\\job.txt";
my $temp = "C:\\temp\\temp_job.txt";
# my $cv   = "P:\\usr\\My Documents\\ITConsultant\\Questor\\Career\\fjbcv.pdf";
# my $cv   = "P:\\usr\\My Documents\\ITConsultant\\Questor\\Career\\fjbcv.doc";
my $cv   = "v:\\_data\\fjbcv.doc";
my $user = "web99p1";
my $pass = "opytri31bm";

$spiel = <<EOS
Hi, I am very interested.  

I have very relevant experience to this post; see attached CV.

Please call me now to progress this application.

Regards,

Farley

---
Farley Balasuriya
Microsoft IPTVe Solutions Consultant, MCSE, MCDBA, MS SMS MCP, CNE

--- job --- 
EOS
  ;

#start of the script
open( JOB, $file ) or die "$! - can't open $file ";
if ( !-r $cv ) { die "Cannot find CV file: $cv" }

while (<JOB>) {
    if (/^Ref: (.*)$/i) {
        $ref = $1;
        print "Ref: $ref\n";
    }
    if (/^Email\s*(.*)$/i) {
        $email = $1;
        print "Email: [$email]\n";
    }
    if (/^Reference\s*(.*)$/i) {
        $subject = $1;
        print "Subject: $subject\n";
    }
    if (/Full Job: (.*)$/i) {
        $url = $1;
        print "URL: $url\n";
    }
    push ( @buff, $_ );
}
close(JOB);

$subject = "Job Application: " . $subject ;
open( NEW, ">" . $temp ) or die "cannot create: $temp";
print NEW "$spiel\n", @buff;
close(NEW);

print "Sending Email and attaching CV...\n";

#copy for me - without the CV - Create Outlook rule to file automatically - I don't want to even see this shit!
system( "blat.exe",
"$temp -u $user -pw $pass -f contracts\@questor.ch -to contracts\@questor.ch -subject \"$subject\""
);

#copy for them - all the trimmings
system( "blat.exe",
"$temp -u $user -pw $pass -f contracts\@questor.ch -to \"$email\" -subject \"$subject\" -attach \"$cv\""
);

# print "Starting FireFox with the url: $url\n";
# system( "ff", "$url" );
