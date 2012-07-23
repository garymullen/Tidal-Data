
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Provides access to tidal data stored in the tidal_data DB.",
  "AUTHOR" => "Gary Mullen <garymullen\@gmail.com>",
  "BUILD_REQUIRES" => {
    "Mojo::DOM" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Tidal-Data",
  "EXE_FILES" => [
    "bin/pull_tidal_data.cron",
    "bin/lookup_tidal_data.example"
  ],
  "LICENSE" => "perl",
  "NAME" => "Tidal::Data",
  "PREREQ_PM" => {
    "DBIx::Class::Candy" => 0,
    "DBIx::Class::ResultSet" => 0,
    "DBIx::Class::Schema" => 0,
    "DateTime" => 0,
    "DateTimeX::Easy" => 0,
    "File::HomeDir" => 0,
    "Geo::Location::TimeZone" => 0,
    "Math::Polygon" => 0,
    "Math::Trig" => 0,
    "Mojo::UserAgent" => 0,
    "Moose" => 0,
    "SQL::Translator" => "0.11010",
    "base" => 0,
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.002",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



