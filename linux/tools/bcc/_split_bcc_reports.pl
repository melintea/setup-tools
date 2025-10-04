#!/usr/bin/perl

#
# Split the bcc memleak output into individual reports
# Usage: script <main report>
#

use strict;
use warnings;

@ARGV or die "Input file required as command-line parameter\n";
my $bccfile = $ARGV[0];
print "Processing $bccfile \r\n";

my $out;
my $reportNum = 0;

while (<>) {
  if ( /Top 10000 stacks with outstanding allocations/ ) {
      $reportNum++;
      my $reportExt = sprintf("%05d", $reportNum);
      open $out, '>', "$bccfile.$reportExt.txt" or die $!;
      select $out;
      print "$reportExt $_";
  }
  print $_ if $out;
}

