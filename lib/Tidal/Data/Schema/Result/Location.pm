package Tidal::Data::Schema::Result::Location;

# ABSTRACT: Result class representing a Location 

use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

unique_column name => {
	data_type => 'varchar',
	size      => 255,
};

column longitude => {
	data_type => 'float',
};

column latitude => {
	data_type => 'float',
};

has_many location_entries => 'Tidal::Data::Schema::Result::LocationEntry', 'location_id';

1;

__END__
=pod

=head1 NAME

Tidal::Data::Schema::Result::Location - Result class representing a Location 

=head1 VERSION

version 0.002

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

