use utf8;
package Tidal::Data::Schema;

#ABSTRACT: Schema class for the Tidal::Data

use strict;
use warnings;

use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_namespaces();
 
1;

__END__
=pod

=head1 NAME

Tidal::Data::Schema - Schema class for the Tidal::Data

=head1 VERSION

version 0.002

=head1 AUTHOR

Gary Mullen <garymullen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Gary Mullen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

