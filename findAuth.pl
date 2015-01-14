#!/usr/bin/perl -w

use strict;

my $ip = $ARGV[0];
if ($ip !~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/) { print "Bad IP.\n"; exit;}

my @root_servers;
my $lookup;
my @lines;

foreach my $subdomain ( "a" .. "m") { push @root_servers, $subdomain . ".root-servers.net"; }
my $lserver = $root_servers[rand @root_servers];

&r_lookup ($ip, $lserver);

sub r_lookup {
	
	$ip = shift;
	$lserver = shift;
		
	print "Looking up $ip at $lserver\n";
	$lookup = `nslookup $ip $lserver`;
	if ($lookup =~ /^Authoritative answers can be found from:\n(.*\.)\n/sm ) {
		my $base_string = $1;
		@lines = split(/\n/, $base_string);
		
		if ($lines[rand @lines] =~ /^.*\snameserver\s\=\s(.*)\.$/) {
			$lserver = $1;
			&r_lookup ($ip, $lserver);	
		}
	}	
	elsif ($lookup =~ /.*\sname\s\=\s.*/sm) {
		print "Authority at:\n$lookup";
	} 			
	else { print "No more records.\n"; }
}

exit;
