package DB::Schema::Result::Course;
use base qw/DBIx::Class::Core/;
use strict;
use warnings;

=head1 DESCRIPTION

This is the database schema for a Course

=head2 fields

=over

=item *

C<course_id>: database id (autoincrement integer)

=item *

C<course_name>: name of the course (string)

=item *

C<semester>: a string representing the semester


=back

=cut

__PACKAGE__->table('course');

__PACKAGE__->add_columns(
	course_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	course_name => {
		data_type   => 'text',
		size        => 256,
		is_nullable => 1,
	},
	semester => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
);

__PACKAGE__->set_primary_key('course_id');

# set up the one to many relationship with problems
__PACKAGE__->has_many(problems => 'DB::Schema::Result::Problem', 'course_id');

# set up the one to many relationship with categories
__PACKAGE__->has_many(categories => 'DB::Schema::Result::Category', 'course_id');

# set up the one to many relationship with students
__PACKAGE__->has_many(students => 'DB::Schema::Result::Student', 'course_id');

1;
