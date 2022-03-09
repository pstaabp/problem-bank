package ProblemBank::Controller::Category;
use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub getAllCategories ($self) {
	my @categories = $self->schema->resultset("Category")->search;
	my @cats = map { {$_->get_inflated_columns}; } @categories;
	$self->render(json => \@cats);
	return;
}

sub getCategories ($self) {
	my $course_id = int($self->param('course_id'));
	my @categories = $self->schema->resultset("Category")->search({ course_id => $course_id });
	my @cats = map { {$_->get_inflated_columns}; } @categories;
	$self->render(json => \@cats);
	return;
}

sub addCategory ($self) {
	my $category = $self->req->json;
	# this is a new category, so remove the category_id
	delete $category->{category_id};
	my $new_cat = $self->schema->resultset("Category")->create($category);
	$self->render(json => {$new_cat->get_inflated_columns});
	return;
}

sub updateCategory ($self) {
	my $course_id = int($self->param('course_id'));
	my $category_id = int($self->param('category_id'));
	my $category = $self->schema->resultset('Category')->find({
		course_id => $course_id,
		category_id => $category_id
	});

	my $updated_category = $category->update($self->req->json);
	$self->render(json => {$updated_category->get_inflated_columns});
	return;
}

sub deleteCategory ($self) {
	my $course_id = int($self->param('course_id'));
	my $category_id = int($self->param('category_id'));
	my $category = $self->schema->resultset('Category')->find({
		course_id => $course_id,
		category_id => $category_id
	});
	my $deleted_category = $category->delete;
	$self->render(json => { $deleted_category->get_inflated_columns});
	return;
}
1;
