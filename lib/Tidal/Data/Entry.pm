package Tidal::Data::Entry;

# ABSTRACT: Extract website tidal data using provided Mojo::DOM

use Moose;

has location_name => ( is => 'ro', isa => 'Str' );
has latitude      => ( is => 'ro', isa => 'Str' );
has longitude     => ( is => 'ro', isa => 'Str' );
has time          => ( is => 'ro', isa => 'Str' );
has info          => ( is => 'ro', isa => 'Str' );
has error => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_error',
);

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Tidal::Data::Entry - Extract website tidal data using provided Mojo::DOM

=head1 VERSION

version 0.002

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

