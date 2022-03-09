package ProblemBank::Controller::Student;
use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;

sub getStudents ($self) {
	my $course_id = int($self->param('course_id'));
	my @students = $self->schema->resultset('Student')->search({ course_id => $course_id });
	my @students_to_return = map { {$_->get_inflated_columns}; } @students;
	$self->render(json => \@students_to_return);
	return;
}

sub addStudent ($self) {
	my $student = $self->req->json;
	# this is a new student, so remove the user_id
	delete $student->{user_id};
	my $new_student = $self->schema->resultset('Student')->create($student);
	$self->render(json => {$new_student->get_inflated_columns});
	return;
}

sub updateStudent ($self) {
	my $course_id = int($self->param('course_id'));
	my $student_id = int($self->param('user_id'));
	my $student = $self->schema->resultset('Student')->find({
		course_id => $course_id,
		user_id => $student_id
	});

	my $updated_student = $student->update($self->req->json);
	$self->render(json => {$updated_student->get_inflated_columns});
	return;
}

use Data::Dumper;

sub deleteStudent ($self) {
	my $course_id = int($self->param('course_id'));
	my $student_id = int($self->param('user_id'));
	print Dumper { course_id => $course_id,
		user_id => $student_id };
	my $student = $self->schema->resultset('Student')->find({
		course_id => $course_id,
		user_id => $student_id
	});
	my $deleted_student = $student->delete;
	$self->render(json => { $deleted_student->get_inflated_columns});
	return;
}

1;
