package DB::Schema::Result::Problem;
use base qw/DBIx::Class::Core/;
use strict;
use warnings;

=head1 DESCRIPTION

This is the database schema for a Learning Objective.

=head2 fields

=over

=item *

C<problem_id>: database id (autoincrement integer)

=item *

C<course_id>: The id of the course the problem belongs to (foreign key)

=item *

C<description>: name of the course (string)

=item *

C<source>: a JSON object of course dates (currently open and closed)


=back

=cut

__PACKAGE__->table('problem');

__PACKAGE__->load_components(qw/InflateColumn::Serializer Core/);

__PACKAGE__->add_columns(
	problem_id => {
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
	description => {
		data_type   => 'text',
		size        => 256,
		is_nullable => 1,
	},
	learning_objectives => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 0,
		default_value      => '',
		serializer_class   => 'JSON',
		serializer_options => { utf8 => 1 },
	},
	source => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
);

__PACKAGE__->set_primary_key('problem_id');

# set up the many-to-many relationship to learning objectives
__PACKAGE__->has_many(problem_objectives => 'DB::Schema::Result::ProblemObjective', 'problem_id');
__PACKAGE__->many_to_many(objectives => 'problem_objectives', 'objective');

# a course has many problems

__PACKAGE__->belongs_to(course => 'DB::Schema::Result::Course', 'course_id');

1;
