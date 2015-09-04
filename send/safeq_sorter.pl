#!/usr/bin/perl

use strict;
use warnings;

sub sortOperations;
sub sortEntitiesInAddOperation;
sub sortEntitiesInDeleteOperation;

my $SCRIPT_VERSION = "3.0.0";
local $/ = '';

my @sortedOutput = sortOperations(<STDIN>);
foreach my $data (@sortedOutput) {
	print $data, "\n\n";
}

##############################################################################
#   Only subs definitions down there
##############################################################################

sub sortOperations {
	my @data = @_;
	my @sortedData;

	my @addOperations;
	my @modifyOperations;
	my @deleteOperations;

	foreach my $record (@data) {
		# remove trailing whitespaces from record
		$record =~ s/\s+$//;

		# if record contains substring "changetype: add"
		if ($record =~ "changetype: add") {
			push @addOperations, $record;
		}

		# if record contains substring "changetype: delete"
		elsif ($record =~ "changetype: delete") {
			push @deleteOperations, $record;
		}

		# if record contains substring "changetype: modify"
		elsif ($record =~ "changetype: modify"){
			push @modifyOperations, $record;
		}
	}

	@addOperations = sortEntitiesInAddOperation(@addOperations);
	@deleteOperations = sortEntitiesInDeleteOperation(@deleteOperations);

	push @sortedData, @addOperations;
	push @sortedData, @modifyOperations;
	push @sortedData, @deleteOperations;

	return @sortedData;
}

# first costcenters, second roles, third users
sub sortEntitiesInAddOperation {
	my @array = @_;
	my @sortedArray;

	my @costcenters;
	my @roles;
	my @users;

	foreach my $record (@array) {
		# if record contains substring "objectclass: ysqcostcenter"
		if ($record =~ "objectclass: ysqcostcenter") {
			push @costcenters, $record;
		}

		# if record contains substring "objectclass: ysquser"
		elsif ($record =~ "objectclass: ysquser") {
			push @users, $record;
		}

		# if record contains substring "objectclass: ysqrole"
		elsif ($record =~ "objectclass: ysqrole") {
			push @roles, $record;
		}
	}

	push @sortedArray, @costcenters;
	push @sortedArray, @roles;
	push @sortedArray, @users;

	return @sortedArray;
}

# first users, second roles, third costcenters
sub sortEntitiesInDeleteOperation {
	my @array = @_;
	my @sortedArray;

	my @costcenters;
	my @roles;
	my @users;

	foreach my $record (@array) {
		# if record contains substring "dn: costcenterno"
		if ($record =~ "dn: costcenterno") {
			push @costcenters, $record;
		}

		# if record contains substring "dn: username"
		elsif ($record =~ "dn: username") {
			push @users, $record;
		}

		# if record contains substring "dn: rolename"
		elsif ($record =~ "dn: rolename") {
			push @roles, $record;
		}
	}

	push @sortedArray, @users;
	push @sortedArray, @roles;
	push @sortedArray, @costcenters;

	return @sortedArray;
}
