package ProblemBank::Controller::Course;
use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub getAllCourses ($self) {
	my @courses = $self->schema->resultset("Course")->search;
	my @courses_to_return = map { {$_->get_inflated_columns}; } @courses;
	$self->render(json => \@courses_to_return);
	return;
}

sub getCourse ($self) {
	my $course = $self->schema->resultset("Course")->getCourse({ course_id => int($self->param("course_id")) });
	$self->render(json => $course);
	return;
}

# Update the course given by course_id with given params.

sub updateCourse ($self) {
	my $course = $self->schema->resultset("Course")
		->updateCourse({ course_id => int($self->param("course_id")) }, $self->req->json);
	$self->render(json => $course);
	return;
}

sub addCourse ($self) {
	my $course = $self->schema->resultset("Course")->addCourse($self->req->json);
	$self->render(json => $course);
	return;
}

sub deleteCourse ($self) {
	my $course = $self->schema->resultset("Course")->deleteCourse({ course_id => int($self->param("course_id")) });
	$self->render(json => $course);
	return;
}

1;
