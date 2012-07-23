use Test::More tests => 8;
use strict;
use warnings;

use Tidal::Data::Parser;
use Mojo::DOM;

my $DOM = Mojo::DOM->new( do { local $/; <DATA>; } );
isa_ok($DOM, 'Mojo::DOM');

my $PARSER = Tidal::Data::Parser->new( dom => $DOM );
isa_ok($PARSER, 'Tidal::Data::Parser');

is($PARSER->name, 'Vancouver, Columbia River, Washington', 'Location name');
is($PARSER->latitude, '45.6317', 'Location latitude');
is($PARSER->longitude, '-122.6967', 'Location longitude');

my ($entry) = $PARSER->get_records;
is($entry->{epoch}, '1341991260', 'DateTime conversion');
is($entry->{type}, 'High', 'Tidal type');
is($entry->{level}, '2.25', 'Tidal level');

__DATA__
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
<head>
<title>Tide/Current Predictor</title>
</head>
<h2>Vancouver, Columbia River, Washington</h2><h2>11 July 2012 - 15 July 2012</h2><pre>45.6317X N, 122.6967X W

2012-07-11 Wed 00:19 PDT   Moonrise
2012-07-11 Wed 00:21 PDT   2.25 feet  High Tide
2012-07-11 Wed 05:33 PDT   Sunrise
2012-07-11 Wed 08:31 PDT   0.37 feet  Low Tide
2012-07-11 Wed 12:33 PDT   1.08 feet  High Tide
2012-07-11 Wed 14:31 PDT   Moonset
2012-07-11 Wed 18:36 PDT  -0.17 feet  Low Tide
2012-07-11 Wed 20:59 PDT   Sunset
</pre><hr><p>This page is simplified for mobile devices.<br />
</body>
</html>
