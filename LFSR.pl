# Linear feedback shift register implementation. The output's periodicity is checked using the Golomb postulates.

use strict;
use warnings;

my $seed='1001';
my @taps=(4,1,0);
my $long = 4;

###############################################

my @sr_temp = split(//,$seed);
my @coef;
my $i;
my $j;
my $sig;

for ($i=0; $i<@taps-1; $i++){
    push(@coef, $long-$taps[$i]);
}

print $seed;

for ($j=0; $j<60; $j++){
    #print "Sumo: ";
    $sig='0';
    for ($i=0; $i<@coef; $i++){
	$sig = suma($sig, $sr_temp[$coef[$i]]);
	#print $sr_temp[$coef[$i]]." + ";
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
