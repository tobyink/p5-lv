use 5.006;
use strict;
use warnings;

package LV;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

BEGIN {
	*subname = eval { require Sub::Name }
		? \&Sub::Name::subname
		: sub { $_[1] }
};

use Exporter ();
our @ISA       = qw( Exporter );
our @EXPORT    = qw( lvalue );
our @EXPORT_OK = qw( get set );

sub get (&;@) { my $caller = (caller(1))[3]; get => subname("$caller~get", shift), @_ }
sub set (&;@) { my $caller = (caller(1))[3]; set => subname("$caller~set", shift), @_ }

if ( $ENV{PERL_LV_IMPLEMENTATION} )
{
	my $module = sprintf('LV::Backend::%s', $ENV{PERL_LV_IMPLEMENTATION});
	eval "require $module; 1" or do {
		require Carp;
		Carp::croak("Could not load LV backend $module");
	};
	*lvalue = $module->can('lvalue');
}

else
{
	my @implementations = qw(
		LV::Backend::Magic
		LV::Backend::Sentinel
		LV::Backend::Tie
	);
	
	for my $module (@implementations)
	{
		eval "require $module; 1" or next;
		*lvalue = $module->can('lvalue');
		last;
	}
}

unless (__PACKAGE__->can('lvalue'))
{
	require Carp;
	Carp::croak("No suitable backend found for lv");
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

LV - LV ♥ lvalue

=head1 SYNOPSIS

   use LV qw( lvalue get set );
   
   my $xxx;
   sub xxx :lvalue {
      lvalue
         get { $xxx }
         set { $xxx = $_[0] }
   }
   
   xxx() = 42;
   say xxx();    # says 42

=head1 DESCRIPTION

This module makes lvalue subroutines easy and practical to use.
It's inspired by the L<lvalue> module which is sadly problematic
because of the existance of another module on CPAN called L<Lvalue>.
(They can get confused on filesystems that have case-insensitive
file names.)

LV comes with three different implementations, based on
L<Variable::Magic>, L<Sentinel> and C<tie>; it will choose and
use the best available one. You can force LV to pick a particular
implementation using:

   $ENV{PERL_LV_IMPLEMENTATION} = 'Magic'; # or 'Sentinel' or 'Tie'

The tie implementation is the slowest, but will work on Perl 5.6
with only core modules.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=LV>.

=head1 SEE ALSO

L<lvalue>, L<Sentinel>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

