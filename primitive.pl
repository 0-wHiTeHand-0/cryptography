# Given a pseudo prime number with 9 or more digits, calculate a primitive element.
# Given a function alpha^x, calculates the inverse of your birthdate in AAAAMMDD format.

#!/bin/perl
use strict;
use warnings;
use bigint;

my $primo=100000127;#(primo-1)/2 tambien es primo
#my $primo=17;
my $fecha=19901230;
my $i;

BUCLE: for ($i=2; $i<$primo-1; $i++){
	print "\nProbando -> $i\n";
	
	if (jacobi($i, $primo) == -1){
	print "\n$i es un elemento primitivo de $primo\n";
	last BUCLE;
	}
}
print "El inverso de la fecha es: ".potencia($i,$primo-1-$fecha, $primo)."\n";

sub potencia{
my ($a,$m,$n) = @_;
my $b = 1;
while($m != 1){
        if ($m%2 == 1){
                $b = ($b*$a)%$n;
                }
        $a = ($a*$a)%$n;
        $m = $m/2;
        }
$b = ($a*$b)%$n;
return $b
}

sub jacobi{
my $a=shift;
my $p=shift;
my $res;

if ($a==0){return 0}
if ($a==1){return 1}
if ($a%2 == 0){
	$res = jacobi($a/2, $p);
	if ((($p*$p-1) & 8) != 0){$res = -1*$res}
	}else{
	$res = jacobi($p%$a, $a);
	if ((($a-1)*($p-1) & 4) != 0){$res = -1 * $res}
	}
return $res;
}
