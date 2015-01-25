use Alien::Taco;

use Test::More tests => 7;

my $taco = new Alien::Taco(lang => 'java');

isa_ok($taco, 'Alien::Taco');

my $dt = $taco->construct_object('java.util.Date', args => [115, 3, 1]);

isa_ok($dt, 'Alien::Taco::Object');

is($dt->call_method('getYear'), 115);
is($dt->call_method('getMonth'), 3);
is($dt->call_method('getDate'), 1);

my $df = $taco->call_class_method('java.text.DateFormat', 'getDateInstance',
    args => [
        $taco->get_class_attribute('java.text.DateFormat', 'SHORT'),
        $taco->construct_object('java.util.Locale', args => ['en', 'US'])
    ]);

isa_ok($df, 'Alien::Taco::Object');

is($df->call_method('format', args => [$dt]), '4/1/15');
