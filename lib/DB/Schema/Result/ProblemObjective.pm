package DB::Schema::Result::ProblemObjective;
use base qw/DBIx::Class::Core/;
use strict;
use warnings;

=head1 DESCRIPTION

This is the many-to-many bridge between Learning objectives and problems.

=head2 fields

=over

=item *

C<prob_obj_id>: database id (autoincrement integer)

=item *

C<obj_id>: database id of the learning objective (foreign key)

=item *

C<problem_id>: database id of the problem (foreign key)


=back

=cut

__PACKAGE__->table('problem_objective');

__PACKAGE__->add_columns(
	problem_obj_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	obj_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
	},
	problem_id => {
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
	}
);

__PACKAGE__->set_primary_key('problem_obj_id');

__PACKAGE__->add_unique_constraint([qw/problem_obj_id obj_id problem_id/]);

__PACKAGE__->belongs_to(objective   => 'DB::Schema::Result::LearningObjective', 'obj_id');
__PACKAGE__->belongs_to(problem => 'DB::Schema::Result::Problem', 'problem_id');

1;
