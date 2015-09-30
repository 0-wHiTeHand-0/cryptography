# Geffe generator implementation.

use strict;
use warnings;

my $mensaje = '1000101101011010100101001010101001010111010111000000011111';

my @coef;
my $i;
my $j;
my $sig;
my $res;
my $res_2;

################## Primer LSFR

my $seed='1001';
my @sr_temp = split(//,$seed);
my @taps=(4,2,0);
my $long = 4;
my $lsfr1=LSFR();

################## Segundo

$seed='1101';
@sr_temp = split(//,$seed);
@taps=(4,2,0);
$long = 4;
@coef = ();
my $lsfr2=LSFR();

################# Tercero

$seed='1101';
@sr_temp = split(//,$seed);
@taps=(4,3,2,1,0);
$long = 4;
@coef=();
my $lsfr3=LSFR();

###################

$res = multiplica($lsfr1, $lsfr2);
$res_2 = multiplica($lsfr2, $lsfr3);
$res = suma1($res, $res_2);
$res = suma1($res, $lsfr3);

print "Clave para cifrar: $res\n";
print "Mensaje cifrado: ".suma1($res,$mensaje)."\n";

sub multiplica{
    my @a= split(//,$_[0]);
    my @b= split(//,$_[1]);
    my $z;
    my $m = '';
    
    for ($z=0; $z<@a; $z++){
	if (($a[$z] == '1') && ($b[$z] == '1')){$m = $m.'1'}
	else{$m = $m.'0'}
    }
    return $m;
}

sub suma1{
    my @a= split(//,$_[0]);
    my @b= split(//,$_[1]);
    my $z;
    my $m = '';

    for ($z=0; $z<@a; $z++){
	if ($a[$z] == $b[$z]){$m = $m.'0'}
	else{$m = $m.'1'}
    }
    return $m;
}

sub LSFR{
	my $long = length($seed);
    for ($i=0; $i<@taps-1; $i++){
	push(@coef, $long-$taps[$i]);
    }
    for ($j=0; $j<length($mensaje)-$long; $j++){
	#print "Sumo: ";
	$sig='0';
	for ($i=0; $i<@coef; $i++){
	    $sig = suma($sig, $sr_temp[$coef[$i]]);
	    #print $sr_temp[$coef[$i]]." + ";
	}
        $seed=$seed.$sig;
	desplaza();
    }
    return $seed;
}

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
