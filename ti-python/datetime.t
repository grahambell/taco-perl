use strict;

use Alien::Taco;

use Test::More tests => 17;

my $taco = new Alien::Taco(lang => 'python');

isa_ok($taco, 'Alien::Taco');

$taco->import_module('datetime');

my $dt = $taco->construct_object('datetime.datetime', args => [2000, 12, 25]);
isa_ok($dt, 'Alien::Taco::Object');
is($dt->get_attribute('__class__')->get_attribute('__name__'),
  'datetime', 'type of dt');

is($dt->get_attribute('year'), 2000, 'get_attribute year');
is($dt->get_attribute('month'), 12, 'get_attribute month');
is($dt->get_attribute('day'), 25, 'get_attribute day');

is($dt->call_method('strftime', args => ['%Y-%m-%d']),
    '2000-12-25', 'strftime');

my $dt_d = $dt->call_method('date');
isa_ok($dt_d, 'Alien::Taco::Object');
is($dt_d->get_attribute('__class__')->get_attribute('__name__'),
  'date', 'type of dt_d');

my $dt_t = $taco->construct_object('datetime.time', args => [15, 0]);
isa_ok($dt_t, 'Alien::Taco::Object');
is($dt_t->get_attribute('__class__')->get_attribute('__name__'),
  'time', 'type of dt_t');

is($dt_t->get_attribute('hour'), 15, 'get_attribute hour');
is($dt_t->get_attribute('minute'), 0, 'get_attribute minute');

my $dt_c = $taco->call_class_method('datetime.datetime', 'combine',
    args => [$dt_d, $dt_t]);
isa_ok($dt_c, 'Alien::Taco::Object');
is($dt_c->get_attribute('__class__')->get_attribute('__name__'),
  'datetime', 'type of dt_c');

my $dt_c2 = $dt_c->call_method('replace', kwargs => {year => 2010});

is($dt_c2->call_method('strftime', args => ['%d/%m/%Y %I:%M %p']),
    '25/12/2010 03:00 PM', 'strftime date plus time');

like($taco->call_function('repr', args => [$dt_c2]),
    qr/^datetime\.datetime\(2010/, 'repr of datetime');
