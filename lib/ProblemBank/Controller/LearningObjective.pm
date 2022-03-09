package ProblemBank::Controller::LearningObjective;
use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub getAllLearningObjectives ($self) {
	my @objectives = $self->schema->resultset("LearningObjective")->search;
	my @objs = map { {$_->get_inflated_columns}; } @objectives;
	$self->render(json => \@objs);
	return;
}

sub getLearningObjectives ($self) {
	my $course_id = int($self->param('course_id'));
	my @objectives = $self->schema->resultset("LearningObjective")->search({
		'category.course_id' => $course_id
	},
	{
		prefetch => 'category'
	});
	my @objs = map { {$_->get_inflated_columns}; } @objectives;
	$self->render(json => \@objs);
	return;
}

sub addLearningObjective ($self) {
	my $objective = $self->req->json;
	# this is a new learning objective, so remove the obj_id
	delete $objective->{obj_id};
	my $new_obj = $self->schema->resultset('LearningObjective')->create($objective);
	$self->render(json => {$new_obj->get_inflated_columns});
	return;
}

sub updateLearningObjective ($self) {
	my $course_id = int($self->param('course_id'));
	my $objective_id = int($self->param('obj_id'));
	my $objective = $self->schema->resultset('LearningObjective')->find({
		obj_id => $objective_id
	});

	my $updated_objective = $objective->update($self->req->json);
	$self->render(json => {$updated_objective->get_inflated_columns});
	return;
}

sub deleteLearningObjective ($self) {
	my $course_id = int($self->param('course_id'));
	my $objective_id = int($self->param('obj_id'));
	my $objective = $self->schema->resultset('LearningObjective')->find({
		obj_id => $objective_id
	});
	my $deleted_objective = $objective->delete;
	$self->render(json => { $deleted_objective->get_inflated_columns});
	return;
}

1;
