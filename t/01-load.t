#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Regexp::F2B::INI' ) || print "Bail out!\n";
}

diag( "Testing Regexp::F2B::INI $Regexp::F2B::INI::VERSION, Perl $], $^X" );
