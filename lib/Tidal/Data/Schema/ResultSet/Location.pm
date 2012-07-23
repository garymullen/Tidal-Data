package Tidal::Data::Schema::ResultSet::Location;

# ABSTRACT: Resultset class; Provides a method to find the closest Locations to given coordinates.

use strict;
use warnings;

use Math::Trig qw( deg2rad );
use base qw(DBIx::Class::ResultSet);

sub find_closest {
	my ($rs, $latitude, $longitude, $limit) = @_;

	my @locations = map { $_->[1] }
			sort { $a->[0] <=> $b->[0] }
			map { [ _distance($longitude, $latitude,$_->longitude,$_->latitude), $_ ] }
			($rs->all);

	$limit ||= scalar(@locations);

	return wantarray ? @locations[0 .. $limit-1] : [ @locations[0 .. $limit-1] ];
}

# This code uses the Haversine formula to calculate distances between two points on a sphere.
# Adapted from https://metacpan.org/module/Geo::Distance
sub _distance {
	my ($lon1, $lat1, $lon2, $lat2) = @_;

	$lon1 = deg2rad($lon1);
	$lon2 = deg2rad($lon2);
	$lat1 = deg2rad($lat1);
	$lat2 = deg2rad($lat2);

	my $dlon = $lon2 - $lon1;
	my $dlat = $lat2 - $lat1;
	my $a = (sin($dlat/2)) ** 2 + cos($lat1) * cos($lat2) * (sin($dlon/2)) ** 2;
	my $c = 2 * atan2(sqrt($a), sqrt(abs(1-$a)));

	return $c;
}

1;

__END__
=pod

=head1 NAME

Tidal::Data::Schema::ResultSet::Location - Resultset class; Provides a method to find the closest Locations to given coordinates.

=head1 VERSION

version 0.002

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

