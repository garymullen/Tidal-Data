package Tidal::Data::Parser;

# ABSTRACT: Extract website tidal data using provided Mojo::DOM


use Moose;
use DateTimeX::Easy;

has dom => (
	is       => 'ro',
	isa      => 'Mojo::DOM',
	required => 1,
);

has records => (
	traits  => ['Array'],
	is      => 'ro',
	isa     => 'ArrayRef[HashRef]',
	default => sub { [] },
	handles => {
		add_record  => 'push',
		get_records => 'elements',
	},
);

has name => (
	is  => 'rw',
	isa => 'Str',
	lazy_build => 1,
);
sub _build_name {
	return shift->dom->find('h2')->first->text;
}

has location => (
	traits  => ['Hash'],
	is      => 'rw',
	isa     => 'HashRef',
	handles => {
		latitude  => [ get => 'latitude' ],
		longitude => [ get => 'longitude' ],
	}
);
	
sub BUILD {
	my $self = shift;

	foreach my $line ( split(/\n/, $self->dom->at('pre')->text) ) {

		next if ( $line eq '' );

		if ( $line =~ m/^\d+\.\d\d\d\d/ ) {

			$self->location($self->_parse_coordinates($line));

		} elsif ( $line =~ m/Tide$/ ) {

			$self->add_record($self->_parse_tidal_data($line));

		} elsif ( $line =~ m/(Quarter|rise|set)$/ ) {
			# Currently only handling tidal data
		} elsif ( $line =~ m/^Note:/ ) {
			# Todo, maybe add notes to at the location level.
		} else {
			die('Unable to parse line: '.$line);
		}


	}
}

sub _parse_coordinates {
	my ($self, $line) = @_;
	my ($lon, $lat);

	if ( $line =~ m/(\d+\.\d{4}). (N|S), (\d+\.\d{4}). (W|E)/ ) {
		$lat = $2 eq 'N' ? $1 : $1 * -1;
		$lon = $4 eq 'E' ? $3 : $3 * -1;
	} else {
		die "Unable to parse coordinates: ".$line;
	}

	return { longitude => $lon, latitude => $lat }
}

sub _parse_tidal_data {
	my ($self, $line) = @_;
	my $entry = {};

	my ($date, $rest) = split(/  /, $line, 2);
	$entry->{epoch} = $self->_parse_date($date);

	if ( $rest =~ m/(-?\d+\.\d\d) feet  (Low|High) Tide/ ) {
		$entry->{level} = $1;
		$entry->{type}  = $2;
	} else {
		die "Unable to parse tidal data: ".$line;
	}

	return $entry;
}

sub _parse_date {
	my ($self, $date) = @_;

	return DateTimeX::Easy->parse($date)->epoch;
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Tidal::Data::Parser - Extract website tidal data using provided Mojo::DOM

=head1 VERSION

version 0.002

=head1 SYNOPSIS

	my $dom = Mojo::UserAgent->new->get( $URL )->res->dom;
	my $parser = Tidal::Data::Parser->new( dom => $dom );

	foreach my $r ( $parser->get_records ) {
		# Each record is a HashRef with the keys: epoch tide_type level
	}

=head1 METHODS

=head2 get_records 

Return a list of HashRefs each with the keys: epoch tide_type level.

=head2 name

Returns the location name extracted from the DOM.

=head2 longitude

Returns the longitude of the location, extracted from the DOM.

=head2 latitude

Returns the latitude of the location, extracted from the DOM.

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

