#!/usr/bin/env perl
use Test::More tests => 5;
use strict;
use warnings;

# We need to stub out the clock before we 'use' the code that uses the clock;
# in this case, we set up our intention to control time() before loading
# Tidal::Data.
our $mock_time;
BEGIN {
  *CORE::GLOBAL::time = sub () {
    defined $mock_time ? $mock_time : CORE::time;
  };
}

use Tidal::Data;
use Tidal::Data::Entry;
use Tidal::Data::Parser;
use Mojo::DOM;

my $TD  = Tidal::Data->new( database => ':memory:' );

is_deeply($TD->find(1,1), [Tidal::Data::Entry->new( error => 'No location data available.' )], 'Missing location data');

$TD->schema->storage->dbh_do(
        sub {
                my ( undef, $dbh ) = @_;
                foreach my $sql (<DATA>) {
                        $sql =~ s/;//;
                        $dbh->do($sql);
                }
        }
);
is_deeply($TD->find(1,1), [Tidal::Data::Entry->new( error => 'No tidal data available for time range.' )], 'Missing tidal data');

my $r = Tidal::Data::Entry->new(
	'location_name' => 'Peavine Pass, Washington',
	'latitude'      => '48.6',
	'longitude'     => '-122.8',
	'info'          => '0.02 feet  Low Tide',
	'time'          => '2012-07-13 11:07 PDT',
);
is_deeply($TD->find(48, -122, 1342202820)->[0], $r, 'Tidal data');

{
  local $mock_time = 1342202820;
  is( time, $mock_time, "We're in charge of the clock now" );
  is($TD->find(46, -123)->[0]->location_name, 'Harrington Point, Washington', 'find_closest');
}


__DATA__
INSERT INTO "locations" VALUES(1,'Peavine Pass, Washington',-122.8,48.6);
INSERT INTO "locations" VALUES(2,'Harrington Point, Washington',-123.65,46.2667);
INSERT INTO "location_entries" VALUES(1,1342202820,0.02,'Low');
INSERT INTO "location_entries" VALUES(1,1342218180,0.89,'High');
INSERT INTO "location_entries" VALUES(1,1342235040,0.05,'Low');
INSERT INTO "location_entries" VALUES(2,1342202820,1.02,'Low');
INSERT INTO "location_entries" VALUES(2,1342218180,2.89,'High');
INSERT INTO "location_entries" VALUES(2,1342235040,1.05,'Low');
