#!/usr/bin/env perl

use strict;
use warnings;

use Module::Build;

my $build = new Module::Build(
    module_name => 'Alien::Taco',
    dist_abstract => 'Taco Perl module',
    dist_author => 'Graham Bell <graham.s.bell@gmail.com>',
    license => 'gpl',
    requires => {
        'JSON' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
);

$build->create_build_script();
