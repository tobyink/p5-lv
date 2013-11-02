use 5.008;
use strict;
use warnings;
use Benchmark qw(cmpthese);

use LV ();
use LV::Backend::Magic ();
use LV::Backend::Sentinel ();
use LV::Backend::Tie ();

our ($Magic, $Sentinel, $Tie);

sub Magic :lvalue {
	LV::Backend::Magic::lvalue
		get => sub { $Magic },
		set => sub { $Magic = $_[0] };
}

sub Sentinel :lvalue {
	LV::Backend::Sentinel::lvalue
		get => sub { $Sentinel },
		set => sub { $Sentinel = $_[0] };
}

sub Tie :lvalue {
	LV::Backend::Tie::lvalue
		get => sub { $Tie },
		set => sub { $Tie = $_[0] };
}

cmpthese(-1, {
	Magic    => q[ $::Magic    = 0; ::Magic()    += $_ for 0..100 ],
	Sentinel => q[ $::Sentinel = 0; ::Sentinel() += $_ for 0..100 ],
	Tie      => q[ $::Tie      = 0; ::Tie()      += $_ for 0..100 ],
});

__END__
          Rate      Tie    Magic Sentinel
Tie      150/s       --     -37%     -48%
Magic    239/s      59%       --     -18%
Sentinel 291/s      93%      22%       --
