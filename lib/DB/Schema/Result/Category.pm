package DB::Schema::Result::Category;
use base qw/DBIx::Class::Core/;
use strict;
use warnings;

=head1 DESCRIPTION

This is the database schema for a Category

=head2 fields

=over

=item *

C<category_id>: database id (autoincrement integer)

=item *

C<label>: label for the category

=item *

C<description>: a description of the category


=back

=cut

__PACKAGE__->table('category');

__PACKAGE__->add_columns(
	category_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	course_id => {
		data_type => 'integer',
		size => 16,
		is_nullable => 0
	},
	label => {
		data_type   => 'text',
		size        => 256,
		is_nullable => 1,
	},
	description => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
);

__PACKAGE__->set_primary_key('category_id');

__PACKAGE__->belongs_to(course => 'DB::Schema::Result::Course', 'course_id');

__PACKAGE__->has_many(objectives => 'DB::Schema::Result::LearningObjective', 'category_id');

1;
