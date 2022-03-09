#!/usr/bin/env perl

# This file fills a database with sample data for testing.

use warnings;
use strict;

my $main_dir;

BEGIN {
	use File::Basename qw/dirname/;
	use Cwd qw/abs_path/;
	$main_dir = abs_path(dirname(__FILE__)) . '/../..';
}

use lib "$main_dir/lib";

use Carp;
use feature "say";

use Clone qw/clone/;
use DateTime::Format::Strptime;
use YAML::XS qw/LoadFile/;
use JSON;

use DB::Schema;
use DB::TestUtils qw/loadCSV/;

use Data::Dumper;


my $verbose = 1;

# Load the database
my $config_file = "$main_dir/conf/problem_bank.dev.yml";
# $config_file = "$main_dir/conf/ww3-dev.dist.yml" unless (-e $config_file);
my $config = LoadFile($config_file);
my $schema = DB::Schema->connect($config->{database_dsn}, $config->{database_user}, $config->{database_password});
my $course_rs = $schema->resultset("Course");
my $obj_rs = $schema->resultset("LearningObjective");
my $category_rs = $schema->resultset("Category");

# $schema->storage->debug(1);  # Print out the SQL commands.

say "restoring the database with dbi: $config->{database_dsn}" if $verbose;

# Create the database based on the schema.
$schema->deploy({ add_drop_table => 1 });

# Get a list of courses from the CSV file.
my @courses = loadCSV("$main_dir/t/db/sample_data/courses.csv");
say "Adding Courses" if $verbose;
for my $course (@courses) {
	$course_rs->find_or_create($course);
}

# Add the Learning Objective Categories
my @categories = loadCSV("$main_dir/t/db/sample_data/categories.csv");
say "Adding Catgories" if $verbose;
for my $category (@categories) {
	my $course = $course_rs->find({
		course_name => $category->{course_name},
		semester => $category->{semester}
	});

	for my $key (qw/course_name semester/) {
		delete $category->{$key};
	}
	$course->add_to_categories($category);

}

# Add the Learning Objectives
my @objectives = loadCSV("$main_dir/t/db/sample_data/objectives.csv");
say "Adding Objectives" if $verbose;
for my $objective (@objectives) {
	my $course = $course_rs->find({
		course_name => $objective->{course_name},
		semester => $objective->{semester}
	});
	my @str = split(//,$objective->{name});

	my $category = $category_rs->find({
		course_id => $course->course_id,
		label => $str[0]
	});

	for my $key (qw/course_name semester name/) {
		delete $objective->{$key};
	}
	$objective->{number} = $str[1];


	$category->add_to_objectives($objective);
}

# Add the Problems
my @problems = loadCSV("$main_dir/t/db/sample_data/problems.csv");
say "Adding Problems" if $verbose;
for my $problem (@problems) {
	my $course = $course_rs->find({
		course_name => $problem->{course_name},
		semester => $problem->{semester}
	});

	for my $key (qw/course_name semester/) {
		delete $problem->{$key};
	}

	my @objs = ();
	for my $i (1..3) {
		my @str = defined($problem->{"obj$i"}) ? split(//,$problem->{"obj$i"}): ();
		# print Dumper \@str;
		if (scalar(@str) == 2) {
			push(@objs, {cat => $str[0], num => $str[1]});
		}
		delete $problem->{"obj$i"};
	}

	my @los = ();
	for my $objective (@objs) {
		my $cat = $category_rs->find({course_id => $course->course_id, label => $objective->{cat}});
		my $obj_in_db = $obj_rs->find({category_id => $cat->category_id, number => $objective->{num}});
		push(@los,$obj_in_db->obj_id);
	}
	$problem->{learning_objectives} = \@los;
	my $problem_in_db = $course->add_to_problems($problem);

	for my $objective (@objs) {
		my $cat = $category_rs->find({course_id => $course->course_id, label => $objective->{cat}});
		my $obj_in_db = $obj_rs->find({category_id => $cat->category_id, number => $objective->{num}});
		$problem_in_db->add_to_objectives({ obj_id => $obj_in_db->obj_id });
	}
}

1;
