use 5.006;
use strict;
use warnings;

package LV::Backend::Tie;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

sub lvalue :lvalue
{
	my %args = @_;
	tie(my $var, 'LV::Backend::Tie::TiedScalar', $args{get}, $args{set});
	$var;
}

package LV::Backend::Tie::TiedScalar;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';
our @CARP_NOT  = qw( LV LV::Backend::Tie );

sub getter { $_[0][0] = $_[1] if @_ > 1; $_[0][0] }
sub setter { $_[0][1] = $_[1] if @_ > 1; $_[0][1] }
sub name   { $_[0][2] = $_[1] if @_ > 1; $_[0][2] }
sub throw  { require Carp; Carp::croak("${\ $_[0]->name } $_[1]") }

sub TIESCALAR
{
	my $class = shift;
	my $self  = bless([undef, undef, (caller(2))[3]], $class);
	
	my ($get, $set) = @_;
	$self->throw("requires ~get or ~set block") unless $get || $set;
	
	$self->getter($get) if $get;
	$self->setter($set) if $set;
	
	return $self;
}

sub FETCH
{
	my $self = shift;
	my $code = $self->getter or $self->throw("is writeonly");
	goto $code;
}

sub STORE
{
	my $self = shift;
	my $code = $self->setter or $self->throw("is readonly");
	goto $code;
}

1;
