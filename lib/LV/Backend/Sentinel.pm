use 5.008;
use strict;
use warnings;

package LV::Backend::Sentinel;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.002';

use Sentinel;

sub lvalue :lvalue
{
	my %args = @_;
	my $caller = (caller(1))[3];
	$args{get} ||= sub { "$caller is writeonly" };
	$args{set} ||= sub { "$caller is readonly" };
	
	@_ = %args;
	goto \&sentinel;
}

1;
