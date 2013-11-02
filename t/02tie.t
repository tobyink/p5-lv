=pod

=encoding utf-8

=head1 PURPOSE

Test that LV::Backend::Tie works.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use Test::More tests => 7;

BEGIN {
	$ENV{PERL_LV_IMPLEMENTATION} = 'Tie';
};

use LV qw( lvalue get set );

is(LV::implementation(), 'LV::Backend::Tie');

my $var;
sub func :lvalue {
	lvalue get { $var } set { $var = $_[0] }
}

func() = 10;
is($var, 10);

func() *= 2;
is($var, 20);

func() += 3;
is($var, 23);

func() .= 'ski';
is($var, '23ski');

is(func() .= 'doo', '23skidoo');
is($var, '23skidoo');
