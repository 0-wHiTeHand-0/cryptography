# Given a primes product number n, a function x^2, and f(37659670402359614687722) = 144 = 12^2, calculate the 2 factors.

#!/bin/perl
use strict;
use warnings;
use bigint;

my $n=48478872564493742276963;
my $y=37659670402359614687722;
my $f1;
my $f2;

print "Potencia: ".potencia_mod2($y,2,$n)."\n";

$f1 = euclides($y-12, $n);
$f2 = euclides($y+12, $n);
print "Factor 1: $f1\n";
print "Factor 2: $f2\n";
print "Resultado: ".$f1*$f2."\n";

sub euclides{
        my $a=shift;
        my $b=shift;

        while($b!=0){
                ($a,$b) = ($b,$a%$b)
                }
        return $a
}

sub potencia_mod2{#Algoritmo de exponenciacion binaria
        my $base=shift;
        my $pot=shift;
        my $mod=shift;
        my $a=1;
        my $i;

        for ($i=1; $i<$pot+1; $i++){
                $a = ($a*$base)%$mod
        }
        return $a
}
