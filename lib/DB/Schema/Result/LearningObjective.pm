package DB::Schema::Result::LearningObjective;
use base qw/DBIx::Class::Core/;
use strict;
use warnings;

=head1 DESCRIPTION

This is the database schema for a Learning Objective.

=head2 fields

=over

=item *

C<obj_id>: database id (autoincrement integer)

=item *

C<obj_name>: name of the course (string)

=item *

C<obj_description>: a JSON object of course dates (currently open and closed)


=back

=cut

__PACKAGE__->table('objective');

__PACKAGE__->add_columns(
	obj_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	category_id => {
		data_type   => 'integer',
		size        => 16,
		is_nullable => 1,
	},
	number => {
		data_type => 'integer',
		size => 16,
		is_nullable => 1
	},
	description => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
);

__PACKAGE__->set_primary_key('obj_id');

# set up the many-to-many relationship to problems
__PACKAGE__->has_many(problem_objectives => 'DB::Schema::Result::ProblemObjective', 'obj_id');
__PACKAGE__->many_to_many(problems => 'problem_objectives', 'problem_id');

# __PACKAGE__->belongs_to(course => 'DB::Schema::Result::Course', 'course_id');
__PACKAGE__->belongs_to(category => 'DB::Schema::Result::Category', 'category_id');


1;
