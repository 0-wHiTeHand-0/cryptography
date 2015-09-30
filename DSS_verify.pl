# Given a sign, a message, and a public DSS key, it checks if the sign is or is not right.

#!/bin/perl
use strict;
use warnings;
use bigint;
use Math::BigInt;
use Math::BigInt::Random qw/ random_bigint /;
use Digest::SHA::PurePerl;

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

print "Cargando firma...";
open(FIR, "<firma.txt") || die "Error al cargar el archivo de firma\n";
my @entrada = <FIR>;
my $r = Math::BigInt->new($entrada[0]);
my $s = Math::BigInt->new($entrada[1]);
close(FIR);
print "Hecho\n";

print "Cargando fichero...";
open(DATA, "<$ARGV[0]") || die "Error al cargar el archivo para firmar. Pasa el nombre del archivo como parametro en la linea de comandos\n";
my $sha = Digest::SHA::PurePerl->new(1);
$sha->addfile(*DATA);
$sha = $sha->hexdigest;#La salida del hash es en hexadecimal
$sha = hex('0x'.$sha);#Conversion a decimal
close(DATA);
print "Hecho\n";

print "Cargando clave publica...";
open(PUB, "<clave_publica.txt") || die "Error al cargar el archivo\n";
@entrada = <PUB>;
my $p = Math::BigInt->new($entrada[0]);
my $q = Math::BigInt->new($entrada[1]);
my $alpha = Math::BigInt->new($entrada[2]);
my $y = Math::BigInt->new($entrada[3]);
close(PUB);
print "Hecho\n";

my $u = $sha % $q;
$u *= inverso($s, $q);
$u = $u % $q;
my $v = $r % $q;
$v *= inverso($s, $q);
$v = $v % $q;
my $r_prima = potencia($alpha, $u, $p);
$r_prima *= potencia($y, $v, $p);
$r_prima = $r_prima % $p;
$r_prima = $r_prima % $q;

if ($r == $r_prima){print "Firma VALIDA\n"}
else{print "Firma NO valida\n"}
