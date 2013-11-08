use 5.008;
use strict;
use warnings;
use Benchmark qw(cmpthese);

use LV qw( lvalue get set );

our $x;

sub no_sugar :lvalue {
	lvalue
		get => sub { $x },
		set => sub { $x = $_[0] };
}

sub sugar :lvalue {
	lvalue
		get { $x },
		set { $x = $_[0] };
}

print LV::implementation, "\n";

cmpthese(-1, {
	sugar    => q[ sugar()    = 0;  sugar()    += $_ for 0..100 ],
	no_sugar => q[ no_sugar() = 0;  no_sugar() += $_ for 0..100 ],
});

__END__
LV::Backend::Sentinel
          Rate    sugar no_sugar
sugar    186/s       --     -65%
no_sugar 526/s     183%       --
