# Test client subroutines.
#
# This script tests the client module's subroutines.

use strict;

use IO::String;

use Test::More tests => 11;

BEGIN {use_ok('Alien::Taco');}
BEGIN {use_ok('Alien::Taco::Object');}

my $in = '';
my $out = '';

my $in_io = new IO::String($in);
my $out_io = new IO::String($out);


# Create Taco client without invoking a server script.

my $t = bless
    {xp => new Alien::Taco::Transport(in => $in_io, out => $out_io)},
    'Alien::Taco';


# Test interaction method.

$in = "{\"action\": \"result\", \"result\": 46}\n// END\n";
is($t->_interact({action => 'test'}), 46, 'read result');

is($out, "{\"action\":\"test\"}\n// END\n", 'write test action');

$in = "{\"action\": \"non-existant action\"}\n// END\n";
$in_io->seek(0);
eval {$t->_interact({action => 'test'});};
ok($@, 'detect unknown action error');
like($@, qr/unknown action/, 'raise unknown action error');

$in = "{\"action\": \"exception\", \"message\": \"test_exc\"}\n// END\n";
$in_io->seek(0);
eval {$t->_interact({action => 'test'});};
ok($@, 'receive exception');
like($@, qr/test_exc/, 're-raise exception');


# Test object handling.

my %hash = (x => new Alien::Taco::Object(undef, 78));
Alien::Taco::_replace_objects(\%hash);
is_deeply($hash{'x'}, {_Taco_Object_ => 78}, 'replace object');

%hash = (z => {_Taco_Object_ => 678});
$t->_interpret_objects(\%hash);
my $res = $hash{'z'};
isa_ok($res, 'Alien::Taco::Object');
is($res->_number(), 678, 'interpret object number');
