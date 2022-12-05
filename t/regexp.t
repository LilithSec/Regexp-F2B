#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN {
   use_ok('Regexp::F2B');
}

my $tests_ran=1;
my $object;

# make sure it will replace <HOST>
my $worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <HOST>, dst:.*$']);
	if ($object->{regexp}[0] =~ /\<HOST\>/) {
		die($object->{regexp}[0]);
	}
	$worked=1;
};
ok( $worked eq '1', 'host replace test') or diag("did not replace <HOST>... ".$@);

# make sure pre_regexp won't accept <HOST>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP4>, dst:.*$'],
							 pre_regexp=>['foo <HOST>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test1') or diag("pre_regexp accepted <HOST>");

# make sure pre_regexp won't accept <IP4>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP4>, dst:.*$'],
							 pre_regexp=>['foo <IP4>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test2') or diag("pre_regexp accepted <IP4>");

# make sure pre_regexp won't accept <IP6>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP6>, dst:.*$'],
							 pre_regexp=>['foo <IP6>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test3') or diag("pre_regexp accepted <IP6>");

# make sure pre_regexp won't accept <ADDR>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP6>, dst:.*$'],
							 pre_regexp=>['foo <ADDR>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test4') or diag("pre_regexp accepted <ADDR>");

# make sure pre_regexp won't accept <DNS>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP6>, dst:.*$'],
							 pre_regexp=>['foo <DNS>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test5') or diag("pre_regexp accepted <DNS>");

# make sure pre_regexp won't accept <SUBNET>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP6>, dst:.*$'],
							 pre_regexp=>['foo <SUBNET>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test6') or diag("pre_regexp accepted <SUBNET>");

# make sure pre_regexp won't accept <CIDR>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP6>, dst:.*$'],
							 pre_regexp=>['foo <CIDR>']);
	$worked=1;
};
ok( $worked eq '0', 'pre_regexp bad tag test7') or diag("pre_regexp accepted <CIDR>");

# make sure it will replace <IP4>
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src\:\ <IP4>, dst:.*$']);
	if ($object->{regexp}[0] =~ /\<IP4\>/) {
		die($object->{regexp}[0]);
	}
	$worked=1;
};
ok( $worked eq '1', 'ip4 replace test') or diag("did not replace <IP4>... ".$@);

# host test
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src: <HOST>, dst:.*$']);
	my $line='2022-09-11T05:03:11 auth failed src: foo.bar, dst:5.6.7.8';
	my $matched=$object->proc_line($line);
	if ($matched ne 'foo.bar') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: 1.2.3.4, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '1.2.3.4') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: ::1, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '::1'){
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}
	$worked=1;
};
ok( $worked eq '1', 'host test') or diag("<HOST> testing failed... ".$@);

# ipv4 test
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src: <IP4>, dst:.*$']);
	my $line='2022-09-11T05:03:11 auth failed src: 1.2.3.4, dst:5.6.7.8';
	my $matched=$object->proc_line($line);
	if ($matched ne '1.2.3.4') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}
	$worked=1;
};
ok( $worked eq '1', 'ipv4 test') or diag("<IP4> testing failed... ".$@);

# ipv6 test
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src: <IP6>, dst:.*$']);
	my $line='2022-09-11T05:03:11 auth failed src: ::1, dst:5.6.7.8';
	my $matched=$object->proc_line($line);
	if ($matched ne '::1') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}
	$worked=1;
};
ok( $worked eq '1', 'ipv6 test') or diag("<IP6> testing failed... ".$@);

# addr test
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src: <ADDR>, dst:.*$']);
	my $line='2022-09-11T05:03:11 auth failed src: ::1, dst:5.6.7.8';
	my $matched=$object->proc_line($line);
	if ($matched ne '::1') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: 1.2.3.4, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '1.2.3.4') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}
	$worked=1;
};
ok( $worked eq '1', 'ipv6 test') or diag("<ADDR> testing failed... ".$@);

# cidr test
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src: <CIDR>, dst:.*$']);
	my $line='2022-09-11T05:03:11 auth failed src: ::1/128, dst:5.6.7.8';
	my $matched=$object->proc_line($line);
	if ($matched ne '::1/128') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: 1.2.3.4/32, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '1.2.3.4/32') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}
	$worked=1;
};
ok( $worked eq '1', 'cidr test') or diag("<CIDR> testing failed... ".$@);

# cidr test
$worked=0;
$tests_ran++;
eval{
	$object=Regexp::F2B->new(regexp=>['auth failed src: <SUBNET>, dst:.*$']);
	my $line='2022-09-11T05:03:11 auth failed src: ::1/128, dst:5.6.7.8';
	my $matched=$object->proc_line($line);
	if ($matched ne '::1/128') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: 1.2.3.4/32, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '1.2.3.4/32') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: ::1, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '::1') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}

	$line='2022-09-11T05:03:11 auth failed src: 1.2.3.4, dst:5.6.7.8';
	$matched=$object->proc_line($line);
	if ($matched ne '1.2.3.4') {
		die("returned '".$matched."'\n\n".Dumper($line,$object));
	}
	$worked=1;
};
ok( $worked eq '1', 'subnet test') or diag("<SUBNET> testing failed... ".$@);

done_testing($tests_ran);
