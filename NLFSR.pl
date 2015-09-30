# Nonlinear feedback shift register implementation.

use strict;
use warnings;

my $seed='1011';
my @taps=(['0','0','0','0'],['0','0','0','1'],['0','0','1','0'],['1','1','1','0']);
my $k = 20;

###############################################

my @sr_temp = split(//,$seed);
my @coef;
my $i;
my $j;
my $z;
my $sig;
my @sig_1=();
my $sig2;

print $seed;

for ($j=0; $j<$k-@sr_temp; $j++){
    #print "Sumo: ";
    $sig='0';
    for ($i=0; $i<@taps; $i++){
	@sig_1=();
	for ($z=0; $z<@{$taps[$i]}; $z++){
	    if ($taps[$i][$z] == '0'){push(@sig_1, '1')}
	    else{push(@sig_1, $sr_temp[$z])}
	}
	$sig2 = $sig_1[0];
	for ($z=1; $z<@sig_1; $z++){
	    if ($sig_1[$z] == '0') {$sig2 = '0'}
	}
	$sig = suma($sig, $sig2);
    }
    print $sig;
    desplaza();
}
print "\n";

sub suma{
    my $uno = shift;
    my $dos = shift;

    if ($uno == $dos){return '0'}
    else{return '1'}
}

sub desplaza{
    my @temp2 = @sr_temp;
    my $cont;

    @sr_temp = ();
    for ($cont=1; $cont<@temp2; $cont++){
	push(@sr_temp,$temp2[$cont]);
    }
    push(@sr_temp, $sig);
}
