use strict;

use Alien::Taco;
use File::Spec;
use Math::Trig qw/pi/;

use Test::More tests => 7;
use Test::Number::Delta;

my $bliblib = File::Spec->catdir('blib', 'lib');
$ENV{'PERL5LIB'} = $bliblib;
my $taco = new Alien::Taco(script => 'bin/taco-perl');

isa_ok($taco, 'Alien::Taco');

delta_ok($taco->call_function('CORE::sin', args => [30 * pi / 180]),
         0.5, 'sin(30)');

my @r = $taco->call_function('CORE::gmtime', args => ['35']);
is_deeply(\@r, [35, 0, 0, 1, 0, 70, 4, 0, 0], 'list gmtime');

my $r = $taco->call_function('CORE::gmtime', args => ['35']);
is($r, 'Thu Jan  1 00:00:35 1970', 'scalar gmtime');

my @r = $taco->get_value('@INC');
is($r[0], $bliblib, 'first element of @INC');

$taco->import_module('IO::String');
my $s = $taco->construct_object('IO::String');
$s->call_method('print', args => ['a', 'b']);
$s->call_method('seek', args => [0]);
is($s->call_method('getline'), 'ab', 'print without $,');
$taco->set_value('$,', ':');
$s->call_method('seek', args => [0]);
$s->call_method('print', args => ['a', 'b']);
$s->call_method('seek', args => [0]);
is($s->call_method('getline'), 'a:b', 'print with $,=":"');
