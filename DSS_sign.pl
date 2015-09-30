# Given the keys created with DSS_gen, signs the SHA1 hash of a message

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

print "Cargando clave publica...";
open(PUB, "<clave_publica.txt") || die "Error al cargar el archivo\n";
my @entrada = <PUB>;
my $p = Math::BigInt->new($entrada[0]);
my $q = Math::BigInt->new($entrada[1]);
my $alpha = Math::BigInt->new($entrada[2]);
my $y = Math::BigInt->new($entrada[3]);
close(PUB);
print "Hecho\n";

print "Cargando clave privada...";
open(PRI, "<clave_privada.txt") || die "Error al cargar el archivo\n";
@entrada = <PRI>;
my $x = Math::BigInt->new($entrada[0]);
close(PRI);
print "Hecho\n";

print "Cargando fichero...";
open(DATA, "<$ARGV[0]") || die "Error al cargar el archivo para firmar. Pasa el nombre del archivo como parametro en la linea de comandos\n";
my $sha = Digest::SHA::PurePerl->new(1);
$sha->addfile(*DATA);
$sha = $sha->hexdigest;#La salida del hash es en hexadecimal
$sha = hex('0x'.$sha);#Conversion a decimal
close(DATA);
print "Hecho\n";

my $k = random_bigint(min => 2, max => ($q-2));
my $r = (potencia($alpha, $k, $p)) % $q;
my $s = ($sha+($x*$r)) % $q;
$s *= inverso($k, $q);
$s = $s % $q;

print "Escribiendo firma...";
open(FIR, ">firma.txt") || die "Error al crear el archivo de firma\n";
print FIR "$r\n$s\n";
close(FIR);
print "Hecho\n";
