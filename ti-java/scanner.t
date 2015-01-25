use strict;

use Alien::Taco;

use Test::More tests => 10;

my $taco = new Alien::Taco(lang => 'java');

isa_ok($taco, 'Alien::Taco');

my $sb = $taco->constructor('java.lang.StringBuilder')->();

isa_ok($sb, 'Alien::Taco::Object');

my $append = $sb->method('append');
$append->('1 1 2 ');
$append->('3 5 8');
my $seq = $sb->call_method('toString');

is($seq, '1 1 2 3 5 8');

my $sc = $taco->constructor('java.util.Scanner')->(
    $taco->construct_object('java.io.StringReader', args => [$seq]));

isa_ok($sc, 'Alien::Taco::Object');

my $next = $sc->method('nextInt');

is($next->(), 1);
is($next->(), 1);
is($next->(), 2);
is($next->(), 3);
is($next->(), 5);
is($next->(), 8);
