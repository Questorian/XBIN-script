#
#------------------------------------------------------------------------------
# QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
#------------------------------------------------------------------------------
#
# GenPassword.pl: Generate strong and secure passwords
#
# Project:	
# Author:	Farley Balasuriya,  (qs10001@QUESTOR.INTRA)
# Created:	Mon May 16 01:21:09 2005
# History:
#		v0.2 - 
#		v0.1 - 16/05/05 - initial version created
#            
#------------------------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#------------------------------------------------------------------------------
# Copyright (C) 1998-2005 Farley Balasuriya, Questor Sytems GmbH, Switzerland
# All rights reserved.
#------------------------------------------------------------------------------

# use strict;

# Copyright 2000 - 2004 George Shaffer
# Anyone may use or modify this code for any purpose PROVIDED
# that as long as it is recognizably derived from this code,
# that this copyright notice, remains intact and unchanged.
# No warrantees of any kind are expressed or implied.

# Passwords: There are password generators that generate
# far more random passwords choosing from letters, letters
# and numbers, or the whole keyboard.  These passwords are
# impossible for normal human beings to remember
# assuring that they will be written down in a readily
# accessible location, thus largely defeating the purpose
# of good passwords.  Real security threats are more
# likely to be internal than external.  Some years ago I
# had the opportunity to work with the U.S. State Department's
# Controlled User Environment password generator.  It generated
# 8 character passwords in the form of CVC99CVC or consonant,
# vowel, consonant, digit, digit, consonant, vowel, consonant.

# These passwords had two easily pronounceable pieces separated
# by two digits.  For passwords not subject to dictionary
# attacks or easily associated with personal interests or
# information, these passwords were surprisingly easy to
# remember, making much better practical passwords than true
# randomly generated passwords.  The only problem with this
# approach is that there are only some 400+ million passwords
# which may not be enough with today's computing power and
# brute force attacks.

# I have tried to extend the core concept but keep most
# of it's advantages.  With the defaults, password.pl
# pseudo randomly adds up to two additional
# consonants.  Further the first
# character of either or both letter sequences is pseudo
# randomly upper cased.  Also one of the digits is sometimes
# replaced by a punctuation mark.  Resulting passwords are
# 7 - 10 characters and have at least one digit and one upper
# case character. Many have a punctuation mark or symbol but
# only from those characters that I find relatively easy to
# type without looking at the keyboard. I estimate this
# extends password universe by approximately 1000 times but
# could be way off.  If you change the defaults or logic
# you'll change the number of possible passwords.

# Run with my original settings you get 10 passwords at a time.
# Some should meet virtually any requirements for length,
# letters, numbers and symbols.  Typically a few are fairly
# easy to remember but still much better than those I have
# been choosing for myself and the system admin accounts
# I have been responsible for over the past 10 or so years.

# If $siz = 8, $addConsonants = 0, $firstUpper = 0,
# $mixedCase = 0, and $symbolOdds = 0 you'll see State
# Department style passwords except in lower case.

# I suggest that anyone who makes frequent use of this,
# change the "User Changeable Constants" to fit your tastes
# and environment.  I chose hardcoded values rather than
# command line options in the belief that anyone who can use
# a text editor can easily and permanently adjust the behavior
# of this program more easily than remembering or typing
# command line options.  Each choice is documented.

# Please feel free to change anything from this point forward.

# I experimented at considerable length to find seed logic that
# was very random on Windows NT which generates a very small
# universe of process ID numbers ($$) compared to Unix.
srand(time() ^ ($$ + $$ << 21));

# USER CHANGEABLE CONSTANTS FOLLOW

# Change $howMany to change the number of generated passwords.
my $howMany;
$howMany = 10 unless $howMany;
$howMany = 1000 if ($howMany > 1000);


# Increase the default 8 to change the generated password size
# and extra letters will be added to the end.  Decrease and
# you'll lose some or all of the second string of letters.
# Depending on the value of $addConsonants the actual
# password length may range from $siz to $siz + 2.
# Size interacts with other choices.  If $addConsonants is false
# size will be fixed length and is achieved by truncation after
# checking for upper case and digits so short sizes (3 - 5) may
# not have the variability you desire.
my $siz;
$siz = 8 unless $siz;
# A $siz less than 3 creates an endless loop.
$siz = 3 if ($siz < 3);

# Change $addConsonats to 0 to prevent some extra consonants
# from being tacked on to letter sequences.  Leave $addConsonants
# at 1 to sometimes add an extra consonant to letter sequences.
# If left at 1 the password size will vary from $siz to $siz+2.
my $addConsonants;
$addConsonants = 1 unless ($addConsonants eq "0");

# Change $firstUpper to 0 to prevent the first character of each
# letter sequence from being upper case.  Leave it as 1 if you
# want some of the first characters to be upper case.
my $firstUpper;
$firstUpper = 1 unless ($firstUpper eq "0");

# Change $mixedCase to 1 to mix the case of all letters.
# $mixedCase is not random as subsequent checks force at
# least one upper and one lower case letter in each password.
# Leave it at 0 so all letters will be lower case or only
# the first or each letter sequence may  be upper case.
my $mixedCase;
$mixedCase = 0 unless ($mixedCase == 1);

# By changing $symbolOdds from 0 to 10 you change the likelihood
# of having two numbers or a number and a symbol.  At 0 you will
# always get 2 digits.  At 1 you will usually only get one digit
# but will sometimes get a second digit or a symbol.  At 10 you
# will always get two numbers or a number and a symbol with the
# about even chances that one of the two characters will be a
# symbol.  The odds are affected by what characters are added to
# or removed from the $sym initialization string.
# The default is 7.
my $symbolOdds;
$symbolOdds = 7 if ($symbolOdds eq "");
$symbolOdds = 7 unless ($symbolOdds >= 0 and $symbolOdds <= 10);

# Change $across to a 1 to print passwords across the screen.
# Leave $across as a 0 to print a single column down the screen.
my $across;
$across = 0 unless ($across == 1);

# Add or remove symbols to make passwords easier or harder
# to type.  Delete the second set of digits to increase
# the relative frequency of symbols and punctuation.
# Add some vowels or consonants to really change the patterns
# but these will also get much harder to remember.
# The $ needs to be escaped if it is to be available as a
# password character.
$sym = ",.<>~`!@#\$%^&*()-_+=";
$numb = "56781234901278903456" . $sym;
$lnumb = length($numb);

# USER CHANGEABLE CONSTANTS END - Changing the constants as
# specified above has been fairly well tested.  Any changes
# below here and you are changing the logic of the program.
# You should be familiar with programming if you make changes
# after this point.

# Unless you plan to change the logic in the loop below,
# leave this next alone and control case with $firstUpper and
# $mixedCase above.  $mixedCase supercedes if both are true.
$upr = "BbCcDdFfGgHhJjKkLlMNPXYZmnpqrstvQRSTVWwxyz";
$cons = "bcdrstvwxyzfghjklmnpq";
if ($mixedCase) {
    $vowel = "aAeEiIoOuU";
    $cons = $upr;
} else {
    $vowel = "uoiea";
}
$upr = $cons unless ($firstUpper);
$lvowel = length($vowel);
$lcons = length($cons);
$lupr = length($upr);

$realSize = $siz;
$realSize += 2 if ($addConsonants);
($across) ? ($down = "  ") : ($down = "\n");
$linelen = 0;

$j = 0;
while (1) {
   $pass = "";
   $k = 0;
   for ($i=0; $i<$siz; $i++) {
      # The basic password structure is cvc99cvc.  Depending on
      # how $cons and $upr have been initialized above case will
      # be all lower, first upper or random.
      if ($i==0 or $i==2 or $i==5 or $i==7) {
         if ($i==0 or $i==5) {
            $pass .= substr($upr,int(rand($lupr)),1);
         } else {
            $pass .= substr($cons,int(rand($lcons)),1);
         }
         # The next will conditionally add up to 2 consonants
         # pseudo randomly after the four "standard" consonants.
         if ($addConsonants and (int(rand(4)) == 3) and $k < 2) {
            $pass .= substr($cons,int(rand($lcons)),1);
            $k++;
         }
      }

      # Pad the password with letters if $siz is over 7.
      if ($i > 7) {
          if (int(rand(26)) <= 5) {
             $pass .= substr($vowel,int(rand($lvowel)),1);
          } else {
             $pass .= substr($cons,int(rand($lcons)),1);
          }
      }

      # Put the vowels in cvc99cvc.  Case depends on how $vowel
      # was initialized above.
      $pass .= substr($vowel,int(rand($lvowel)),1)
         if ($i==1 or $i==6);

      # Change $symbolOdds initialization above to affect the
      # number of numbers and symbols and their ratio.
      if ($i==3 or $i==4) {
         # If $symbolOdds is non zero take any character
         # from the $numb string which has digits, symbols
         # and punctuation.
         if ($symbolOdds) {
            $pass .= substr($numb,int(rand($lnumb)),1)
               if (int(rand(10)) <= $symbolOdds);
         } else {
            # If $symbolOdds is zero keep trying until a
            # a digit is found.
            $n = "";
            until ($n =~ /[0-9]/) {
               $n = substr($numb,int(rand($lnumb)),1);
            }
            $pass .= $n;
         }
      }
   }

   # Check the password length.
   $pass = substr($pass,0,$realSize) if (length($pass) > $realSize);

   # Plan to use this password unless . . .
   $skipThisOne = 0;
   # Include at least one digit.
   $skipThisOne = 1 unless ($pass =~ /[0-9]/);
   # Include at least one lower case letter.
   $skipThisOne = 1 unless ($pass =~ /[a-z]/);
   # Conditionally insure at least one upper case character.
   $skipThisOne = 1
      if (!($pass =~ /[A-Z]/) and ($firstUpper or $mixedCase));
   # If any test fails get another password.
   if ($skipThisOne) {
      next;
   }

   # Print the passwords in a single column or across
   # the screen based on $down which is set based on the
   # the value of $across.
   if ($down ne "\n") {
      # Don't wrap passwords or trailing whitespace.
      if ($linelen + length($pass) + length($down) > 59) {
         print "\n";
         $linelen = 0;
      }
      $linelen += length($pass) + length($down);
   }

   print "$pass$down";
   $j++;
   last if ($j >= $howMany);
}
# Be sure to end the last line with an end of line.
print "\n" if $down ne "\n";
#------------------------------------------------------------------------------
# Copyright (C) 1998-2005 Farley Balasuriya, Questor Sytems GmbH, Switzerland
# All rights reserved.
#------------------------------------------------------------------------------