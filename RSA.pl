# RSA implementation.

#!/bin/perl
use strict;
use warnings;
use bigint;

sub euclides{
        my($a, $b)=@_;
        while($b!=0){($a,$b) = ($b,$a%$b)}
        return $a
}

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

sub inverso{
  my($a,$n) = @_;
  my($t,$nt,$r,$nr) = (0, 1, $n, $a % $n);
  while ($nr != 0) {
    my $quot = int( ($r - ($r % $nr)) / $nr );
    ($nt,$t) = ($t-$quot*$nt,$nt);
    ($nr,$r) = ($r-$quot*$nr,$nr);
  }
  return if $r > 1;
  $t += $n if $t < 0;
  $t;
}

my $primo1=1000000000039;
my $primo2=100000000000031;
my $n = $primo1*$primo2;
my $phi = ($primo1-1)*($primo2-1);
my $e=1;
my $d;
my $chorizo=123456789101112131415;

do{
        #$e = int(rand($primo2))+10000000000000000031+2
        $e++
}while(euclides($e, $phi) != 1);

print "Clave publica: e = $e, n = ".$n."\n";
$d = inverso($e, $phi);
print "Clave privada: ".$d."\n";

my $crip = potencia($chorizo, $e, $n);
print "\nInverso: ".potencia($chorizo, $d, $n)."\n";

print "\nExtra:\nPrueba cifrado: ".$crip."\n";
print "Prueba descifrado: ".potencia($crip, $d, $n)."\n";
#print "Comprobación: ".($d*$e)%$n."\n";
