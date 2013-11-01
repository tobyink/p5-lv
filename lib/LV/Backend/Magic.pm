use 5.008;
use strict;
use warnings;

package LV::Backend::Magic;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Carp;
use Variable::Magic qw( wizard cast );

sub lvalue :lvalue
{
	my %args = @_;
	my $caller = (caller(1))[3];
	$args{get} ||= sub { require Carp; Carp::croak("$caller is writeonly") };
	$args{set} ||= sub { require Carp; Carp::croak("$caller is readonly") };
	
	my $var;
	my $wiz  = wizard(
		set => sub { $args{set}->(${ $_[0] }); 0 },
		get => sub { $var = $args{get}->(); 0 },
	);
	cast($var, $wiz);
	$var;
}

1;
