package ProblemBank::Controller::Problem;
use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub getProblems ($self) {
	my $course_id = int($self->param('course_id'));
	my @problems = $self->schema->resultset('Problem')->search({ course_id => $course_id });
	my @cats = map { {$_->get_inflated_columns}; } @problems;
	$self->render(json => \@cats);
	return;
}

sub addProblem ($self) {
	my $Problem = $self->req->json;
	# this is a new Problem, so remove the problem_id
	delete $Problem->{problem_id};
	my $new_cat = $self->schema->resultset('Problem')->create($Problem);
	$self->render(json => {$new_cat->get_inflated_columns});
	return;
}

sub updateProblem ($self) {
	my $course_id = int($self->param('course_id'));
	my $problem_id = int($self->param('problem_id'));
	my $Problem = $self->schema->resultset('Problem')->find({
		course_id => $course_id,
		problem_id => $problem_id
	});

	my $updated_problem = $Problem->update($self->req->json);
	$self->render(json => {$updated_problem->get_inflated_columns});
	return;
}

sub deleteProblem ($self) {
	my $course_id = int($self->param('course_id'));
	my $problem_id = int($self->param('problem_id'));
	my $Problem = $self->schema->resultset('Problem')->find({
		course_id => $course_id,
		problem_id => $problem_id
	});
	my $deleted_problem = $Problem->delete;
	$self->render(json => { $deleted_problem->get_inflated_columns});
	return;
}

use Data::Dumper;
use File::Slurp;

sub renderProblem ($self) {
	my $course_id = int($self->param('course_id'));
	my $problem_id = int($self->param('problem_id'));
	my $problem = $self->schema->resultset('Problem')->find({
		course_id => $course_id,
		problem_id => $problem_id
	});
	my $prob_source = $problem->source;

	my $file = '/Users/pstaab/code/problem-bank/data/tmp.tex';

	write_file($file ,$prob_source);

	my $output = `pandoc -f latex --mathjax $file`;

	$self->render(json => { output => $output});
	return;
}


1;
