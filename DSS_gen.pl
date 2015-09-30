# Generate asymetric DSS keys.

#!/bin/perl
use strict;
use warnings;
use bigint;
use Math::BigInt::Random qw/ random_bigint /;

sub potencia{
my ($a,$m,$n) = @_;
my $b = 1;
while($m != 1){
	if ($m%2 == 1){$b = ($b*$a)%$n}
	$a = ($a*$a)%$n;
	$m = $m/2
	}
$b = ($a*$b)%$n;
return $b
}

sub miller_rabin
{
        my ($n,$k) = @_;
        return 1 if $n == 2;
        return 0 if $n < 2 or $n % 2 == 0;
        my $d = $n - 1;
        my $s = 0;
	my $x; 

        while(!($d % 2))
        {
                $d /= 2;
                $s++
        }
   LOOP: for(1..$k)
        {
                $a = 2 + int(rand($n-2));
                $x = $a->bmodpow($d, $n);
                next if $x == 1 or $x == $n-1;
 
                for(1..$s-1)
                {
                        $x = ($x*$x) % $n;
                        return 0 if $x == 1;
                        next LOOP if $x == $n-1
                }
                return 0
        }
        return 1
}

my $salida_pub="clave_publica.txt";
my $salida_pri="clave_privada.txt";

#my $primo = 10000000000000000000000000000000000000000000023887;#50 digitos. p-1/2 tambien es primo

#my $primo = random_bigint(min => (2**159), max => (2**160));
#while(miller_rabin($primo, 4) == 0){
#	$primo = random_bigint(min => (2**159), max => (2**160));
#	print "Probando: $primo\n"
#}
#print "Comprobacion: ".miller_rabin($primo, 15)."\n";

my $q = random_bigint(min => (2**159), max => (2**160));
while(miller_rabin($q, 10) == 0){$q = random_bigint(min => (2**159), max => (2**160))}
my $c = int(rand(512))+512-160;#Numero aleatorio entre 512 y 1024, restado 160 -> Tamaño de $c
$c = random_bigint(min => (2**($c-1)), max => (2**$c));
if ($c%2 != 0){$c++}
my $p = ($c*$q)+1;
while(miller_rabin($p, 10) == 0){$p += (2*$q); print "Probando...".$p."\n"}
my $g = random_bigint(min => (2), max => ($p-2));
my $alpha = potencia($g, ($p-1)/$q, $p);
if ($alpha == 1){$alpha++}

my $x = random_bigint(min => 2, max => ($q-2));

print "Escribiendo clave publica...\n";
open(PUB, ">$salida_pub") || die "Error al crear el archivo\n";
print PUB "$p\n$q\n$alpha\n".potencia($alpha, $x, $p)."\n";
close(PUB);
print "Escribiendo clave privada...\n";
open(PRI, ">$salida_pri") || die "Error al crear el archivo\n";
print PRI $x."\n";
close(PRI);
