#!/usr/bin/env perl

# This tests the basic database CRUD functions with courses.

use warnings;
use strict;

my $main_dir;

BEGIN {
	use File::Basename qw/dirname/;
	use Cwd qw/abs_path/;
	$main_dir = abs_path(dirname(__FILE__)) . '/../..';
}

use lib "$main_dir/lib";

use Test::More;
use Test::Exception;
use YAML::XS qw/LoadFile/;

use DB::Schema;

use DB::TestUtils qw/loadCSV removeIDs loadSchema/;

# Load the database
my $config_file = "$main_dir/conf/problem_bank.dev.yml";
my $config = LoadFile($config_file);
my $schema = DB::Schema->connect($config->{database_dsn}, $config->{database_user}, $config->{database_password});

my $course_rs = $schema->resultset("Course");

# Get a list of courses from the CSV file.
my @courses = loadCSV("$main_dir/t/db/sample_data/courses.csv");
for my $course (@courses) {
	delete $course->{course_params};
}
@courses = sortByCourseName(\@courses);

# Check the list of all courses
my @courses_from_db = $course_rs->getCourses;

use Data::Dumper;

print Dumper \@courses_from_db;

for my $course (@courses_from_db) { removeIDs($course); }
@courses_from_db = sortByCourseName(\@courses_from_db);

is_deeply(\@courses_from_db, \@courses, "getCourses: course names");

# Get a single course by name
my $course  = $course_rs->getCourse({ course_name => "Calculus" });
my $calc_id = $course->{course_id};
delete $course->{course_id};
my @calc_courses = grep { $_->{course_name} eq "Calculus" } @courses;
is_deeply($course, $calc_courses[0], "getCourse: get a single course by name");

# Get a single course by course_id
$course = $course_rs->getCourse({ course_id => $calc_id });
delete $course->{course_id};
is_deeply($course, $calc_courses[0], "getCourse: get a single course by id");

# Try to get a single course by sending proper info:
throws_ok {
	$course_rs->getCourse({ course_id => $calc_id, course_name => "Calculus" });
}
"DB::Exception::ParametersNeeded", "getCourse: sends too much info";

throws_ok {
	$course_rs->getCourse({ name => "Calculus" });
}
"DB::Exception::ParametersNeeded", "getCourse: sends wrong info";

# Try to get a single course that doesn't exist
throws_ok {
	$course_rs->getCourse({ course_name => "non_existent_course" });
}
"DB::Exception::CourseNotFound", "getCourse: get a non-existent course";

# Add a course
my $new_course_params = {
	course_name  => "Geometry",
	visible      => 1,
	course_dates => {}
};

my $new_course      = $course_rs->addCourse($new_course_params);
my $added_course_id = $new_course->{course_id};
removeIDs($new_course);

is_deeply($new_course_params, $new_course, "addCourse: add a new course");

# Add a course that already exists
throws_ok {
	$course_rs->addCourse({ course_name => "Geometry", visible => 1 });
}
"DB::Exception::CourseExists", "addCourse: course already exists";

# Update the course name
my $updated_course = $course_rs->updateCourse({ course_id => $added_course_id }, { course_name => "Geometry II" });

$new_course_params->{course_name} = "Geometry II";
delete $updated_course->{course_id};

is_deeply($new_course_params, $updated_course, "updateCourse: update a course by name");

# Try to update an non-existent course
throws_ok {
	$course_rs->updateCourse({ course_name => "non_existent_course" });
}
"DB::Exception::CourseNotFound", "updateCourse: update a non-existent course_name";

throws_ok {
	$course_rs->updateCourse({ course_id => -9 }, $new_course_params);
}
"DB::Exception::CourseNotFound", "updateCourse: update a non-existent course_id";

# Delete a course
my $deleted_course = $course_rs->deleteCourse({ course_name => "Geometry II" });
removeIDs($deleted_course);

is_deeply($new_course_params, $deleted_course, "deleteCourse: delete a course");

# Try to delete a non-existent course by name
throws_ok {
	$course_rs->deleteCourse({ course_name => "undefined_name" })
}
"DB::Exception::CourseNotFound", "deleteCourse: delete a non-existent course_name";

# Try to delete a non-existent course by id
throws_ok {
	$course_rs->deleteCourse({ course_id => -9 })
}
"DB::Exception::CourseNotFound", "deleteCourse: delete a non-existent course_id";

sub sortByCourseName {
	my $course_rs = shift;
	my @new_array = sort { $a->{course_name} cmp $b->{course_name} } @$course_rs;
	return @new_array;
}

done_testing();

