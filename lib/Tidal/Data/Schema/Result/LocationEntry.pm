package Tidal::Data::Schema::Result::LocationEntry;

# ABSTRACT: Result class representing a LocationEntry (High/Low Tide levels for a Location/time).

use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

column location_id => {
	data_type         => 'int',
};

column epoch => {
	data_type => 'int',
};

column level => {
	data_type => 'float',
};

column tide_type => {
	data_type => 'varchar(64)',
};

belongs_to location => 'Tidal::Data::Schema::Result::Location', 'location_id';

primary_key ( 'location_id', 'epoch', 'tide_type' );

1;

__END__
=pod

=head1 NAME

Tidal::Data::Schema::Result::LocationEntry - Result class representing a LocationEntry (High/Low Tide levels for a Location/time).

=head1 VERSION

version 0.002

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

