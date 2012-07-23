my ( $ref, $email, $line, $cc, $contact, $speil, $subject, $url, @buff );
my $file = "C:\\temp\\job.txt";
my $temp = "C:\\temp\\temp_job.txt";

# my $cv   = "P:\\usr\\My Documents\\ITConsultant\\Questor\\Career\\fjbcv.pdf";
# my $cv   = "P:\\usr\\My Documents\\ITConsultant\\Questor\\Career\\fjbcv.doc";
# my $cv   = "v:\\_data\\fjbcv.doc";

#note: We only mail out PDFs for now - We do not want Muppets storring our CV on their databases
my $cv   = "v:\\_data\\FJBDocs\\fjbcv.pdf";
my $user = "web99p2";
my $pass = "OpytrI31BM";



#start of the script
open( JOB, $file ) or die "$! - can't open $file ";
if ( !-r $cv ) { die "Cannot find CV file: $cv" }

while (<JOB>) {
    if (/^Ref: (.*)$/i) {
        $ref = $1;
        print "Ref: $ref\n";
    }
    if (/^Email: mailto:(.*)$/i) {
        $email = $1;
        print "Email: [$email]\n";
    }
    if (/^Position: (.*)$/i) {
        $subject = $1;
        print "Subject: $subject\n";
    }
    if (/^Contact: (.*)$/i) {
        $contact = $1;
        print "Contact: $contact\n";
    }


    if (/Full Job: (.*)$/i) {
        $url = $1;
        print "URL: $url\n";
    }
    push( @buff, $_ );
}
close(JOB);


$spiel = <<EOS
Hello $contact, 

I am extremely interested in your advertised position and would like to put myself forward - Please review my CV, and I am sure you will find my experience extensive and very relevant.

Call me ASAP, so we may progress this further. 

Please note that I will only consider contract positions.

My current contract is set to finish November 2010 - So I would be free after that.

Call me now on +41 79 285 6482, and I look forward to talking with you very soon.

Thank-you.

Regards,


Farley
--
Farley Balasuriya
contracts\@QuestorSystems.com
www.QuestorSystems.com
Microsoft SCCM Solutions Consultant, 
Microsoft Certified Database Administartor (MCDBA), 
Microsoft Cetified Systems Enginner (MCSE), 
Microsoft Certified System Center Configuration Manager (SCCM)
Microsoft Certified Systems Management Server (SMS)
Novell Certified Novell Enfinner (CNE)
EOS
  ;


$subject = "Job Application: " . $subject . " - " . $ref;
open( NEW, ">" . $temp ) or die "cannot create: $temp";
print NEW "$spiel\n", @buff;
close(NEW);

print "Sending Email and attaching CV...\n";

#copy for me - without the CV - Create Outlook rule to file automatically - I don't want to even see this shit!
system( "blat.exe",
"$temp -u $user -pw $pass -f contracts\@QuestorSystems.com -to contracts\@QuestorSystems.com -subject \"$subject\""
);

#copy for them - all the trimmings
system( "blat.exe",
# "$temp -pu $user -ppw $pass -f contracts\@QuestorSystems.com -to \"$email\" -subject \"$subject\" -attach \"$cv\""
"$temp -u $user -pw $pass -f contracts\@QuestorSystems.com -to \"$email\" -subject \"$subject\" -attach \"$cv\""
);

# print "Starting FireFox with the url: $url\n";
# system( "ff", "$url" );
