use strict;

use Alien::Taco;
use File::Spec;

use Test::More tests => 12;

$ENV{'PERL5LIB'} = File::Spec->catdir('blib', 'lib');
my $taco = new Alien::Taco(script => 'bin/taco-perl');

isa_ok($taco, 'Alien::Taco');

$taco->import_module('DateTime');

my $dt = $taco->construct_object('DateTime',
    kwargs => {year => 2000, month => 4, day => 1});

isa_ok($dt, 'Alien::Taco::Object');

is($dt->call_method('ymd', args => ['/']), '2000/04/01');

my $strftime = $dt->method('strftime');

is($strftime->('%d-%m-%Y'), '01-04-2000');

$taco->import_module('Data::Dumper');
my $dumper = $taco->function('Dumper');

unlike($dumper->($dt), qr/_taco_test_attr/);
$dt->set_attribute('_taco_test_attr', 12345);
like($dumper->($dt), qr/_taco_test_attr/);
is($dt->get_attribute('_taco_test_attr'), 12345);

$taco->import_module('DateTime::Duration');
my $dur_cons = $taco->constructor('DateTime::Duration');
my $dur = $dur_cons->(days => 3);

isa_ok($dur, 'Alien::Taco::Object');

$taco->import_module('Storable', args => [qw/dclone/]);
my $dt_orig = $taco->call_function('dclone', args => [$dt]);
isa_ok($dt_orig, 'Alien::Taco::Object');

$dt->call_method('add_duration', args => [$dur]);

is($strftime->('%d-%m-%Y'), '04-04-2000');
my $dur_diff = $dt_orig->call_method('delta_days', args => [$dt]);

is($dur_diff->call_method('days'), 3, 'subtract dates');

my $dt2 = $taco->call_class_method('DateTime', 'from_epoch',
    kwargs => {epoch => 15});
is($dt2->call_method('datetime'), '1970-01-01T00:00:15',
    'from_epoch class method');
