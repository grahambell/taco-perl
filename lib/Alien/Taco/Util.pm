# Taco Perl utility module.
# Copyright (C) 2013-2024 Graham Bell
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 NAME

Alien::Taco::Util - Taco Perl utility module

=head1 DESCRIPTION

This module contains utility subroutines used to implement the
Perl Taco client and server.

=cut

package Alien::Taco::Util;

use strict;

our $VERSION = '0.003';

use Exporter;
use base 'Exporter';
our @EXPORT_OK = qw/filter_struct/;

=head1 SUBROUTINES

=over 4

=item filter_struct($ref, $predicate, $function)

Walk through the given data structure and return a copy with each entry
for which the predicate is true replaced with the result of applying the
function to it.

=cut

sub filter_struct {
    my $x = shift;
    my $pred = shift;
    my $func = shift;

    my $type = ref $x;

    if ($pred->($x)) {
        return $func->($x);
    }
    elsif ($type eq 'HASH') {
        return {map {$_ => filter_struct($x->{$_}, $pred, $func)} keys %$x};
    }
    elsif ($type eq 'ARRAY') {
        return [map {filter_struct($_, $pred, $func)} @$x];
    }

    return $x;
}

1;

__END__

=back

=cut
