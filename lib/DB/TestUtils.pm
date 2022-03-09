package DB::TestUtils;

use warnings;
use strict;
use feature 'signatures';
no warnings qw(experimental::signatures);

use Text::CSV qw/csv/;

require Exporter;
use base qw(Exporter);
our @EXPORT_OK = qw/buildHash loadCSV removeIDs filterBySetType loadSchema/;

=head1 DESCRIPTION

This is a collection of utilities for testing purposes

=head2 buildHash

This takes a hashref and builds up a params field and a dates field for any
field starting with PARAM: and DATE: respectively.

=cut

sub buildHash ($input) {
	my $output = {};
	for my $key (keys %{$input}) {
		if ($key =~ /^([A-Z_]+):(.*)/x) {
			$output->{ lc($1) } = {} unless defined($output->{ lc($1) });
			$output->{ lc($1) }->{$2} = $input->{$key} if defined($input->{$key});
		} else {
			$output->{$key} = $input->{$key};
		}
	}
	my @date_fields = keys %{ $output->{set_dates} };
	delete $output->{set_dates} if (scalar(@date_fields) == 0);
	return $output;
}

sub loadCSV ($filename) {
	my $items_from_csv = csv(in => $filename, headers => "auto", blank_is_undef => 1);
	my @all_items      = ();
	for my $item (@$items_from_csv) {
		push(@all_items, buildHash($item));
	}
	return @all_items;
}

=head2 removeIDs

Removes all of the fields of an arrayref that ends in _id

Used for testing against items from the database with all id tags removed.

=cut

# Remove any field that ends in _id except student_id.
sub removeIDs ($obj) {
	for my $key (keys %$obj) {
		delete $obj->{$key} if $key =~ /_id$/x && $key ne 'student_id';
	}
	return;
}

sub filterBySetType ($all_sets, $type, $course_name) {
	my $type_hash     = $DB::Schema::ResultSet::ProblemSet::SET_TYPES;
	my @filtered_sets = @$all_sets;

	if (defined($course_name)) {
		@filtered_sets = grep { $_->{course_name} eq $course_name } @filtered_sets;
	}
	if (defined($type)) {
		@filtered_sets = grep { $_->{set_type} eq $type } @filtered_sets;
	}

	return @filtered_sets;
}

1;
