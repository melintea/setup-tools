#!/usr/bin/perl
#
# Fake STUN
#
# Usage: ./stun.pl
#

use strict;

use File::Basename;
use lib dirname (__FILE__);
use STUN::RFC_5389; # https://metacpan.org/pod/distribution/STUN-RFC_5389/lib/STUN/RFC_5389.pod
use IO::Socket;     # https://docstore.mik.ua/orelly/perl/cookbook/ch17_06.htm

my $srvport = 5005;
my $sock = IO::Socket::INET->new(LocalPort => $srvport, Proto => 'udp') or die "socket: $@";
print "Listening on: $srvport\n";

my $recvbuf;
while ($sock->recv($recvbuf, 2048)) {
    my($rport, $ripaddr) = sockaddr_in($sock->peername);
    my $rhost  = gethostbyaddr($ripaddr, AF_INET);
    my $answer = server_process_message($rport, $ripaddr, $recvbuf);

    my $hexanswer = sprintf("%v02X", $answer);
    print "\n<--\n$hexanswer\n";
    $sock->send($answer);
}

die "--- Done: $!\n";


sub server_process_message
{
    my ($rport, $ripaddr, $recvbuf) = @_;

    my $hexrecvbuf = sprintf("%v02X", $recvbuf);
    print "\n--> Received from $rport:$ripaddr\n$hexrecvbuf\n";

    my $answer = STUN::RFC_5389->Server( $recvbuf, $rport, $ripaddr );
    if ( defined $answer && ! $answer )
    {
        print $STUN::RFC_5389::error;
    }
    my $answerhash = STUN::RFC_5389->Client( $answer );

    return $answer;
}

## create a STUN-message you can then send through your client
#$stun_request = STUN::RFC_5389->Client( { request => 1 } );

