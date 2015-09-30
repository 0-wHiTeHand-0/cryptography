# Check if a number sequence is periodic using the 3 Golomb postulates.

use strict;
use warnings;

my $secuencia='100100011110101';
my @sec_temp;
my $i;
my $unos=0;
my $ceros=0;

######################## Primer postulado

@sec_temp = split(//,$secuencia);
for ($i=0; $i<length($secuencia); $i++){
if ($sec_temp[$i] == '1'){$unos++}
else{$ceros++}
}

if (abs($unos-$ceros)>1){
print "La secuencia no satisface el primer postulado.\n";
exit;
}

######################### Segundo postulado

$ceros=0;
my @rachas;

for ($i=0; $i<length($secuencia)-1; $i++){
    if ($sec_temp[$i] == $sec_temp[$i+1]){
	$ceros++;
    }else{
	push(@rachas, $ceros);
	$ceros = 0;
    }
}
push(@rachas, $ceros);

#if ($sec_temp[length($secuencia)-1] != $sec_temp[length($secuencia)-2]){$unos++}

$i=0;
$ceros = n_rachas($i);
$i++;
$unos = n_rachas($i);

while ($unos != 0){
    #print $ceros." ".$unos."\n";
    if ((2*$unos != $ceros) && ($unos != 1)){
	print "No se cumple el segundo postulado.\n";
	exit;
    }
    $ceros=$unos;
    $i++;
    $unos=n_rachas($i);
}

###################### Tercer postulado

my @temporal = desplaza(@sec_temp);
my $hamming = dif(@temporal);
#my $k;
for ($i=1; $i<@sec_temp-1; $i++){
    @temporal = desplaza(@temporal);

    #for ($k=0; $k<@temporal;$k++){
#	print $temporal[$k]." ";
    #}
   # print "H: ".dif(@temporal);
    #print "\n";

    if (dif(@temporal) != $hamming){
	print "No se cumple el tercer postulado.\n";
	exit;
    }
}

print "Enhorabuena, se cumplen los 3 postulados :)\n";

sub desplaza{
    my @temp1 = @_;
    my @temp2;
    my $cont;
    push(@temp2, $temp1[@temp1-1]);
    for ($cont=0; $cont<@temp1-1; $cont++){
	push(@temp2,$temp1[$cont]);
    }
    return @temp2;
}

sub dif{
    my @mov = @_;
    my $cont;
    my $ham = 0;
    for ($cont = 0; $cont<@sec_temp; $cont++){
	if ($sec_temp[$cont] ne $mov[$cont]){$ham++}
    }
    return $ham;
}

sub n_rachas{
    my $j = shift;
    my $temp = 0;
    my $z;
    for ($z=0; $z<@rachas; $z++){
	if ($j == $rachas[$z]){$temp++}
    }
    return $temp;
}
