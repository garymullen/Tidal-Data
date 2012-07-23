package Tidal::Data::Schema::ResultSet::LocationEntry;

# ABSTRACT: Resultset class; Provides a method to find LocationEntries closest to a given time, within a timerange.

use strict;
use warnings;

use base qw(DBIx::Class::ResultSet);

sub find_closest {
	my ($rs, $location_id, $epoch, $range) = @_;

	$range = $range ? $range / 2 : 12; # default to 12hrs either side
	$range *= 3600;

	return $rs->search({
		location_id => $location_id,
		-and => [
			epoch => { '>=' => $epoch - $range },
			epoch => { '<' => $epoch + $range },
		],
	});
}

1;

__END__
=pod

=head1 NAME

Tidal::Data::Schema::ResultSet::LocationEntry - Resultset class; Provides a method to find LocationEntries closest to a given time, within a timerange.

=head1 VERSION

version 0.002

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

