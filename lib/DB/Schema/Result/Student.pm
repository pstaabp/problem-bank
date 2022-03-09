package DB::Schema::Result::Student;
use base qw/DBIx::Class::Core/;
use strict;
use warnings;

=head1 DESCRIPTION

This is the database schema for a Student

=head2 fields

=over

=item *

C<user_id>: database id (autoincrement integer)

=item *

C<course_id>: database id of course the student is in (foreign key)

=item *

C<username>: username of the Student

=item *

C<first_name>: first name of the student

=item *

C<last_name>: last name of the student

=item *

C<student_id>: student id of the student

=back

=cut

__PACKAGE__->table('student');

__PACKAGE__->add_columns(
	user_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	course_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	username => {
		data_type   => 'text',
		size        => 256,
		is_nullable => 1,
	},
	first_name => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
	last_name => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
	student_id => {
		data_type          => 'text',
		size               => 256,
		is_nullable        => 1
	},
);

__PACKAGE__->set_primary_key('user_id');

# set up the relationship to courses
__PACKAGE__->belongs_to(course => 'DB::Schema::Result::Course', 'course_id');

1;
