#-------------------------------------------------------------------------
#
# PrintInvoice.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# PrintInvoice.pl: TimeTraker Invoice printing tool
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-12-02T01:25:20
# History:
#		v0.2 -
#		v0.1 - 2008-12-02 - initial version created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2008, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

use Win32::OLE;
use DBI;
use Carp;
use Config::Tiny;
use File::Copy;
use Questor;

#use DateTime;
#use Getopt::Long;

# ini file - we get the DBI connection parameters (connection string) out of this file
my $ini = "v:/_data/ini/Questor.ini";

# $ini_section - change this to the name of the section you want loaded in the ini file
my $ini_section = "QBase";

# a STANDARD query that will work on any installation - simply query the master database
my $query_1 = q{

  select 
      max(InvoiceNo)as 'Invoice No', sum(Quantity) as 'Quantity'
  from 
      dbo.InvoiceDetails
  Where 
      InvoiceNo = (select max(InvoiceNo) from dbo.Invoices)

};

my $query_2 = q{

select 
AmountGross
FROM
  dbo.Invoices
where 
InvoiceNo = ?

};

# global variables
my $dbh;    # dbi handle for queries used throughout the program
my $config;
my $template;
my $workdir;
my $month = "November";
my $year  = 2010;
my $invoice_no;
my $quantity;

 my $signed_timesheet;
 my $new_invoice;
 my $pdf_printer;

# call the main function
PrintInvoice(@ARGV);

### Main Function ###
# Usage     : PrintInvoice()
# Purpose   : PrintInvoice -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub PrintInvoice {
    my ($v) = @_;

    #check the ini file exist - get the DB location information
    if ( -f $ini ) {
        print "found existing ini file: $ini";
    }
    else {
        croak "unable to find ini file: $ini\n";
    }

    # create a config object
    $config = Config::Tiny->new();

    # open the config file
    $config = Config::Tiny->read($ini);

    #print out the data we want...
    print "\nDumping out INI file parameters:\n";
    print "----------------------------------\n";
    print "persona           : $config->{$ini_section}->{persona}\n";
    print "server            : $config->{$ini_section}->{server}\n";
    print "database          : $config->{$ini_section}->{database}\n";
    print "trusted connection: $config->{$ini_section}->{trusted_connection}\n";
    print "----------------------------------\n";

    # get other values
    $template = $config->{$ini_section}->{invoice_template};
    $workdir  = $config->{$ini_section}->{workdir};
    $pdf_printer = $config->{$ini_section}->{pdf_printer};

    # DBI::ADO connectino string
    # my $sqlite_con_str = "dbi:SQLite:dbname=dbfile.db-sql3";

    # -- SQL Native Client ODBC Driver
    # my $ms_con_str = "dbi:ADO:Driver={SQL Native Client};
    # -- SQL Native Client OLE DB Provider
    # my $ms_con_str = "dbi:ADO:Provider=SQLNCLI;

    my $ms_con_str = "dbi:ADO:Provider=SQLNCLI10;
    Server=$config->{$ini_section}->{server};
    Database=$config->{$ini_section}->{database};
    trusted_connection=$config->{$ini_section}->{trusted_connection}";

    # database handel - connect to the database
    $dbh = DBI->connect( $ms_con_str,,, { TimeOut => 5 } )
      or die $DBI::errstr;

    # statement handel - prepare the statement
    my $sth = $dbh->prepare($query_1);

    # execute the statement handel
    $sth->execute();

    # iterate each row - dump quick and dirty
    ( $invoice_no, $quantity ) = $sth->fetchrow_array;

    # close the statement handle
    $sth->finish;

    # lets use our data
    print "Generating Invoice: $invoice_no, $quantity\n";

    # oiih!! - We need the month name too...
    excel_invoice( $invoice_no, $quantity );

    # disconnect and exit
    $dbh->disconnect;

    return;
}

sub excel_invoice {
    my ( $invoice_no, $quantity ) = @_;

    # check that we have the signed timesheet document there and rename it
    # document should be called 'document.pdf'
    my $timesheet_pdf = $workdir . '\\Document.pdf';
    if ( !-f $timesheet_pdf ) {
        die
"signed timesheet document cannot be found: $timesheet_pdf - please copy to folder and restart!";
    }

    # now - let's rename it
    $signed_timesheet =
      $workdir . "\\Nestle - signed timesheet - $month 2010.pdf";
    move( $timesheet_pdf, $signed_timesheet );

    # make a copy of the template to the workdir with the correct name
    my $datestr     = date();
    $new_invoice = $workdir . "\\QS-Invoice-$invoice_no-$datestr";
    copy( $template, $new_invoice . ".xls" )
      or die "copy of file from: $template -> $new_invoice - failed";

    # we need to start and create a Win32::OLE object
    my $excel = Win32::OLE->GetActiveObject('Excel.Application');

    unless ($excel) {
        $excel = new Win32::OLE('Excel.Application')

          # $excel = new Win32::OLE('Excel.Application', \&QuitApp)
          or die " Could not create Excel Application object ";
    }

    # $excel->->Display();
    $excel->{Visible} = 1;

    # Open File and Worksheet
    my $workbook  = $excel->Workbooks->Open($new_invoice);    # open Excel file
    my $worksheet = $workbook->Worksheets(1);

    # set the invoice no
    my $range = $worksheet->Range('F18:F18');
    $range->{Value} = $invoice_no;

    # set text string for  month name
    my $text_string = "Netlé Standard Day Rate - Month: " . $month . " 2010";
    $range = $worksheet->Range('D24:D24');
    $range->{Value} = $text_string;

    # set the Quantity (the number of days worked)
    $range = $worksheet->Range('C24:C24');
    $range->{Value} = $quantity;

    # $workbook->SaveAs($file);

    # Save as PDF
    print "your current active printer is: ", $excel->{ActivePrinter}, "\n";
    # $excel->{ActivePrinter} = 'CutePDF Writer on CPW2:';
    $excel->{ActivePrinter} = $pdf_printer ;
    print "your current active printer is: ", $excel->{ActivePrinter}, "\n";
    $excel->ActiveWindow->SelectedSheets->PrintOut();

    # close excel
    $excel->Quit();

    # press to contiune
    print "Press any key to continue...";
    my $junk = <>;

    # email the stuff
    send_email( [ $signed_timesheet, $new_invoice . '.pdf' ] );

    # create outlook reminder for 10 days
    create_task($invoice_no);

    # create month-end report

    # backup, save and quit
    backup_files();

}

sub backup_files
{
my ($v)=@_;

    # move new invoice to correct location
    move ($new_invoice . '.pdf', 'Q:\\EO\\QUESTOR\\Admin\\2008\\invoices\\' . $new_invoice . '.pdf');

    # move the timesheet
    move ( $signed_timesheet, 'Q:\\EO\\QUESTOR\\Admin\\2008\\timesheets\\' . $signed_timesheet);
}

sub create_task {
    my ($invoice_number) = @_;

    # get amount of invoice due
    my $sth = $dbh->prepare($query_2);

    my $rows = $sth->execute($invoice_number);

    # retrieve the amount
    my $total = $sth->fetchrow_array();

    # close the statement handle
    $sth->finish();

    # create an outlook task for 10 days from now - to check payment
    my $task = oltask(
        {
            subject => sprintf(
                "QS Invoice %d - CHF %0.2f - Talisman paid?",
                $invoice_number, $total
            ),
            duedate    => 11,
            categories => 'BalaFund',
            body =>
'Update database with date received when payment has arrived for MWST reporting purposes.',
        }
    );

}

sub send_email {
    my ($attachments_ref) = @_;

    print "Email text template: $config->{QBase}->{email_body_file}\n";

    # first get all the parameters we will need from the ini file
    olmail(
        {

            to        => $config->{QBase}->{email_to},
            cc        => $config->{QBase}->{email_cc},
            subject   => $config->{QBase}->{email_subject} . " $invoice_no - $month $year",
            body_file => $config->{QBase}->{email_body_file},
            attachments => $attachments_ref,
            timestamp   => 1,

        }
    );

    # the email should be ready to send

}

sub QuitApp {
    my ($object) = @_;
    $object->Quit();
}

