#!/usr/bin/perl
#
# install with perl -MCPAN -e shell  ==> C:\Perl\site\lib
# https://metacpan.org/pod/File::PCAP
#
# alternative:
# https://osqa-ask.wireshark.org/questions/12896/perl-netpcap-can-not-parse-wireshark-saved-pcap-file
# https://metacpan.org/pod/Net::Pcap
#

#use lib qw(C:/Perl/site/lib);
use File::PCAP::Reader;

my $fname = "C:\\Temp\\_.pcap";
my $fpr = File::PCAP::Reader->new( $fname );

my $gh = $fpr->global_header();

while(my $np = $fpr->next_packet()) {
    # ... do something with $np
}
