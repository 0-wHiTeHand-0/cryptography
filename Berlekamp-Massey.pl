# Given a periodic sequence, checks its lineal complexity and its conection polinomial, using the Berlekamp-Massey algorithm.

use strict;
use warnings;

my $secuencia =  '10111100010011';
my $i;

sub pr_complejidad {
    my @C = (1);
    my $c_len = 0;
    my @B = (1);
    my $b_len = -1;

    foreach my $bit (0..(@_-1)) {
	my $disc = $_[$bit];

	foreach my $i (1..$c_len) {
	    no warnings 'uninitialized';
	    $disc += $C[$i] * $_[$bit-$i];
	}
	$disc = $disc % 2;

	if ($disc == 1) {
	    my @T = @C;

	    foreach my $i (0..(@B-1)) {
		no warnings 'uninitialized';
		$C[$i+($bit-$b_len)] += $B[$i];
		$C[$i+($bit-$b_len)] %= 2;
	    }
	    if ($c_len <= $bit / 2) {
		$c_len = $bit + 1 - $c_len;
		$b_len = $bit;
		@B = @T;
	    }
	}
    }
    return ($c_len, @C);
}

my @sequence = split("", $secuencia);
my ($complejidad, @tap) = pr_complejidad(@sequence);

print "Complejidad: ".$complejidad."\nPolinomio: ";
for ($i=0; $i<@tap; $i++){
    if (defined $tap[$i]){print $tap[$i]}
    else{print '0'}
}
#print @tap;
print "\n";
