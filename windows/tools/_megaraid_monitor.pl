#!/usr/bin/perl

# 
# A tool to check MegaRAID status and send email alerts
#

use strict;
use warnings;

use Cwd qw(cwd);
use DateTime;
use File::pushd;
use Net::SMTP;
use POSIX qw(strftime);
use Term::ANSIColor qw(:constants);


# Cmd prompt must be run as admin (properties => compatibility)
my $storcliDir = "/cygdrive/c/Program\ Files\ \(x86\)/LSI/Unified_storcli_all_os/Windows/";

# Need to run as admin; use https://github.com/mattn/sudo
my $storcli64  = "./sudo.exe ./storcli64.exe /c0 show";


#
#
#
chdir $ENV{HOME};
{
    chdir $storcliDir;
    my $crtDir = cwd;
    print "In $crtDir\n";

    while (1)
    {
        my $result = qx{$storcli64};   # qx{}

        my $now = strftime "%a %b %e %H:%M:%S %Y", localtime;
        print "\n[ $now ]====================\n$result\n";

        if (  (index($result, "98:8     1   DRIVE Onln") == -1)
           || (index($result, "98:9     2   DRIVE Onln") == -1)
           )
        {
            print BLINK BOLD BRIGHT_RED ON_WHITE "\a\n*** [$now] Drive error ***\n", RESET;

            my $smtp = Net::SMTP->new('smtp.inin.com');
            $smtp->mail('aurelian.melinte@genesys.com');
            if ($smtp->to('aurelian.melinte@genesys.com'))
            {
                $smtp->data();
                $smtp->datasend("Subject: MegaRAID drive error");
                $smtp->datasend("\n");
                $smtp->datasend($result);
                $smtp->dataend();
                $smtp->quit();

                sleep 10;
                exit;
            }
            else
            {
                print "SMTP error: ", $smtp->message();
            }
        }

        print BOLD BRIGHT_BLUE ON_WHITE "\n*** [$now] Normal ***\n", RESET;
        sleep 10*60;
    } #while

    #popd;
}

print BLINK BOLD BRIGHT_RED ON_WHITE "\n*** Done ***\n", RESET;
sleep 10;

