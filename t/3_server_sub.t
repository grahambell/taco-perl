# Test server subroutines.
#
# This script tests the server module's subroutines.

use strict;

use DateTime;

use Test::More tests => 9;

BEGIN {use_ok('Alien::Taco::Server');}


# Test parameter handling.

foreach ([
                {},
                [],
                'get param empty',
        ],
        [
                {args => [qw/a b c/]},
                [qw/a b c/],
                'get param args',
        ],
        [
                {kwargs => {w => 1}},
                [qw/w 1/],
                'get param kwargs',
        ],
        [
                {args => [qw/x y z/], kwargs => {n => 2}},
                [qw/x y z n/, 2],
                'get param mixed',
        ]
        ) {
    is_deeply([Alien::Taco::Server::_get_param($_->[0])], $_->[1], $_->[2]);
}


# Test object handling.

my $obj = DateTime->now();

my %hash = (test_object => $obj);

Alien::Taco::Server::_replace_objects(\%hash);

is_deeply($hash{'test_object'}, {_Taco_Object_ => 1}, 'replace object');

isa_ok(Alien::Taco::Server::_get_object(1), 'DateTime');

Alien::Taco::Server::_interpret_objects(\%hash);

isa_ok($hash{'test_object'}, 'DateTime');

Alien::Taco::Server::_delete_object(1);

is(Alien::Taco::Server::_get_object(1), undef, 'delete object');
