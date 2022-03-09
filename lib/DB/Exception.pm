package DB::Exception;
use warnings;
use strict;

use Exception::Class (
	'DB::Exception::UndefinedCourseField' => {
		fields      => ['message'],
		description => 'There is an undefined course setting field'
	},
	'DB::Exception::InvalidCourseField' => {
		fields      => ['message'],
		description => 'There is an invalid parameter'
	},
	'DB::Exception::InvalidCourseFieldType' => {
		fields      => ['message'],
		description => 'There is an invalid field type'
	},
	'DB::Exception::UndefinedParameter' => {
		fields      => ['field_names'],
		description => 'There is an undefined parameter'
	},
	'DB::Exception::InvalidParameter' => {
		fields      => ['field_names'],
		description => 'There is an invalid parameter'
	},
	'DB::Exception::CourseNotFound' => {
		fields      => ['course_name'],
		description => 'The given course is not found.'
	},
	'DB::Exception::CourseExists' => {
		fields      => ['course_name'],
		description => 'The course already exists.'
	},
	'DB::Exception::ParametersNeeded' => {
		description => 'Parameters are needed that were not included.'
	},
	'DB::Exception::TooManyParameters' => {
		description => 'Too many parameters are passed in.'
	},
);

DB::Exception::UndefinedCourseField->Trace(1);
DB::Exception::InvalidCourseField->Trace(1);
DB::Exception::InvalidParameter->Trace(1);
DB::Exception::UndefinedParameter->Trace(1);
DB::Exception::ParametersNeeded->Trace(1);

1;
