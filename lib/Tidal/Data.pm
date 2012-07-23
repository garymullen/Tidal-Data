package Tidal::Data;

# ABSTRACT: Provides access to tidal data stored in the tidal_data DB.



use Moose;
use File::HomeDir;
use DateTime;
use Geo::Location::TimeZone;

use Tidal::Data::Entry;
use Tidal::Data::Schema;

has schema => (
	is  => 'rw',
	isa => 'Tidal::Data::Schema',
	lazy_build => 1,
);
sub _build_schema {
	my $self = shift;
	my $schema = Tidal::Data::Schema->connect('dbi:SQLite:'.$self->database, '', '');

	if ( ! -f $self->database ) {
		$schema->deploy;
	}
	return $schema;
};

has database => (
	is  => 'rw',
	isa => 'Str',
	required   => 1,
	lazy_build => 1,
);
sub _build_database {
	return sprintf('%s/.tidal_data.db', File::HomeDir->my_home);
}

has geo_tz => (
	is  => 'rw',
	isa => 'Geo::Location::TimeZone',
	required => 1,
	default  => sub { return Geo::Location::TimeZone->new },
);

sub find {
	my ($self, $lat, $lon, $epoch) = @_;

	$epoch ||= time;

	my ($loc) = $self->schema->resultset("Location")->find_closest($lat, $lon, 1);
	if ( ! $loc ) {
		return [ Tidal::Data::Entry->new( error => 'No location data available.' )];
	}
	my @entries = $self->schema->resultset('LocationEntry')->find_closest($loc->id, $epoch);
	if ( ! scalar(@entries) ) {
		return [ Tidal::Data::Entry->new( error => 'No tidal data available for time range.' )];
	}

	my $tz = $self->geo_tz->lookup(lat => $loc->latitude, lon => $loc->longitude);

	return [
		map {
			Tidal::Data::Entry->new(
				location_name => $loc->name,
				latitude      => $loc->latitude,
				longitude     => $loc->longitude,
				time => DateTime->from_epoch( epoch => $_->epoch)->set_time_zone( $tz )->strftime('%F %H:%M %Z'),
				info => $_->level . ' feet  ' . $_->tide_type . ' Tide',
			);
		} @entries
	];
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Tidal::Data - Provides access to tidal data stored in the tidal_data DB.

=head1 VERSION

version 0.002

=head1 SYNOPSIS

        my $td = Tidal::Data->new;

	my $data = $td->find(45.583, -122.660);

        foreach my $r ( @{ $data } ) {
                # Each record is a Tidal::Data::Entry object
		# If no data is found the first (and only) record will has an error

		last if ( $r->has_error );

		print join(' ', map { $r->$_ } qw/ location_name latitude longitude time info /)."\n";
        }

=head1 METHODS

=head2 Tidal::Data->new( .. )

The class method accepts the "database" parameter which set the filename which will be used for the SQLite database.  The default file is ~/.tidal_data.db

=head2 find( $latitude, $longitude, $optional_epoch )

Returns an ArrayRef containing Tidal::Data::Entry objects. 

If no data is found, the first (and only) record will contain an error: say $entry->error if ($entry->has_error);

Results will contain data for the 12hrs either side of $optional_epoch (or the current time if not provided).

Results are for the location closest to the provided coordinates.

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

