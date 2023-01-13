#!/usr/bin/perl

use strict;
use warnings;

my $chromosome = "";
my %mutationcount;
my %misformatted;

while ( my $line = <STDIN> )
{
	chomp $line;
	my @fields = split /\t/, $line;
	my $chr = $fields[0];
	
	if ( $chromosome ne $chr )
	{
		if ( $chromosome ne "" )
		{
			# print off all values for previous chromosome

			print STDERR "Finished with Chromosome $chromosome\n";
			print "variableStep chrom=$chromosome span=1\n";

			foreach my $pos ( sort {$a <=> $b} keys %mutationcount )
			{
				print "$pos\t$mutationcount{$pos}\n";
			}
		}
		%mutationcount = ();
		$chromosome = $chr;
	}

	my $start = $fields[1];
	my $end = $fields[2];

	# want 1-based start so add 1 to start (assuming input is 0-based start bed file)
	$start++;

	# add to cpd_count hash
	for ( my $i = $start; $i <= $end; $i++ )
	{
		$mutationcount{$i}++;
	}
}

# print off all values of last chromosome

print STDERR "Finished with Chromosome $chromosome\n";
print "variableStep chrom=$chromosome span=1\n";

foreach my $pos ( sort keys %mutationcount )
{
        print "$pos\t$mutationcount{$pos}\n";
}

print STDERR "counts of misformatted lines:\n";
foreach ( sort keys %misformatted )
{
	print STDERR "$_ $misformatted{$_} lines\n";

}
