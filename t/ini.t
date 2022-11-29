#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN {
	use_ok('Regexp::F2B::INI');
}

my $tests_ran = 1;
my $object;

# make sure it will die if no file is specified
my $worked = 0;
$tests_ran++;
eval {
	parse_f2b_ini_file();
	$worked = 1;
};
ok( $worked eq '0', 'undef file check' ) or diag("Did not die when all requirements were undef");

# make sure it will die if no file is specified
$worked = 0;
$tests_ran++;
eval {
	parse_f2b_ini_file('does-not-exist.conf');
	$worked = 1;
};
ok( $worked eq '0', 'non-existent file check' ) or diag("Did not die when file does not exist");

# make sure it will die if no string is specified
$worked = 0;
$tests_ran++;
eval {
	parse_f2b_ini_string();
	$worked = 1;
};
ok( $worked eq '0', 'undef string check' ) or diag("Did not die when all requirements were undef");

# parse a file
$worked = 0;
$tests_ran++;
eval {
	my $conf=parse_f2b_ini_file('t/filter.d/common.conf');
	$worked = 1;
};
ok( $worked eq '1', 'parse file check1' ) or diag("Parsing failed... ".$@);

# make sure we get the expected return type
$worked = 0;
$tests_ran++;
eval {
	my $conf=parse_f2b_ini_file('t/filter.d/common.conf');
	if (!defined($conf)) {
		die('Got undefined return from parse_f2b_ini_file');
	}
	if (ref($conf) ne 'HASH') {
		die('ref($conf) is "'.ref($conf).'" and not HASH');
	}
	$worked = 1;
};
ok( $worked eq '1', 'parse file check2' ) or diag("Parsing failed... ".$@);

# make sure we get the expected return type
$worked = 0;
$tests_ran++;
my @sections=('INCLUDES',
'DEFAULT',
'lt_file',
'lt_short',
'lt_journal',
'lt_rfc5424');
eval {
	my $conf=parse_f2b_ini_file('t/filter.d/common.conf');
	foreach my $item (@sections) {
		if (!defined($conf->{$item})) {
			die('Expected section "'.$item.'" not found... '.Dumper($conf));
		}
	}
	$worked = 1;
};
ok( $worked eq '1', 'parse file check3' ) or diag("Expected section not found... ".$@);

# make sure we get the expected return type
$worked = 0;
$tests_ran++;

eval {
	my $conf=parse_f2b_ini_file('t/filter.d/common.conf');
	if (defined($conf->{INCLUDES}{after})) {
		if ($conf->{INCLUDES}{after}[0] ne 'common.local') {
			die('$conf->{INCLUDES}{after}[0] ne "common.local"... '.Dumper($conf));
		}
	}else {
		die('$conf->{INCLUDES}{after} not defined... '.Dumper($conf));
	}
	$worked = 1;
};
ok( $worked eq '1', 'parse file check3' ) or diag("Expected section not found... ".$@);

done_testing($tests_ran);
