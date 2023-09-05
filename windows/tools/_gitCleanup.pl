#!/usr/bin/perl

#
# Run git diff on each modified file.
#

use strict;
use warnings;

my $gitStatus = `git status`;
my @gitStatus = split /\n/, $gitStatus;
foreach my $line (@gitStatus) {
    chomp $line;
    if ($line =~ /modified:\s*(.*)$/) {
        my $file = $1; 
		print "Found modified file: $file\n";
		`git diff $file`;
    }
} 

