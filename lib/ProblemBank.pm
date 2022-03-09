package ProblemBank;
use Mojo::Base 'Mojolicious', -signatures;

use Mojo::File qw(curfile path);
use YAML::XS qw/LoadFile/;

# BEGIN {
# 	$WW3_ROOT = curfile->dirname->dirname->to_string;
# }

use DB::Schema;

# This method will run once at server start
sub startup ($self) {

	# Load configuration from config file
	my $config = $self->plugin('NotYAMLConfig');

	# Configure the application
	$self->secrets($config->{secrets});

	# Load the database and DBIC plugin
	$self->plugin(
		DBIC => {
			schema =>
				DB::Schema->connect($config->{database_dsn}, $config->{database_user}, $config->{database_password})
		}
	);

	# Set up the session
	$self->sessions->cookie_name('ProblemBank');
	$self->sessions->default_expiration($config->{cookie_lifetime});
	$self->sessions->cookie_path('/problem-bank');
	$self->sessions->samesite($config->{cookie_samesite});
	$self->sessions->secure($config->{cookie_secure});



	# Load all routes
	$self->objectiveRoutes();
	$self->courseRoutes();
	$self->categoryRoutes();
	$self->problemRoutes();
	$self->studentRoutes();
	return;
}

sub load_account ($self, $user_id) {
	my $user = $self->schema->resultset("User")->getGlobalUser({ username => $user_id });
	return $user;
}

sub validate ($self, $user, $password) {
	return $self->schema->resultset("User")->authenticate($user, $password);
}

sub objectiveRoutes ($self) {
	$self->routes->get('/problem-bank/api/objectives')->to('LearningObjective#getAllLearningObjectives');
	$self->routes->get('/problem-bank/api/courses/:course_id/objectives')
		->to('LearningObjective#getLearningObjectives');
	$self->routes->post('/problem-bank/api/courses/:course_id/objectives')
		->to('LearningObjective#addLearningObjective');
	$self->routes->put('/problem-bank/api/courses/:course_id/objectives/:obj_id')
		->to('LearningObjective#updateLearningObjective');
	$self->routes->delete('/problem-bank/api/courses/:course_id/objectives/:obj_id')
		->to('LearningObjective#deleteLearningObjective');
	return;
}

sub courseRoutes ($self) {
	$self->routes->get('/problem-bank/api/courses')->to('Course#getAllCourses');
}

sub categoryRoutes ($self) {
	$self->routes->get('/problem-bank/api/categories')->to('Category#getAllCategories');
	$self->routes->get('/problem-bank/api/courses/:course_id/categories')->to('Category#getCategories');
	$self->routes->post('/problem-bank/api/courses/:course_id/categories')->to('Category#addCategory');
	$self->routes->put('/problem-bank/api/courses/:course_id/categories/:category_id')->to('Category#updateCategory');
	$self->routes->delete('/problem-bank/api/courses/:course_id/categories/:category_id')->to('Category#deleteCategory');
	return;
}

sub problemRoutes ($self) {
	$self->routes->get('/problem-bank/api/courses/:course_id/problems')->to('Problem#getProblems');
	$self->routes->post('/problem-bank/api/courses/:course_id/problems')->to('Problem#addProblem');
	$self->routes->put('/problem-bank/api/courses/:course_id/problems/:problem_id')->to('Problem#updateProblem');
	$self->routes->delete('/problem-bank/api/courses/:course_id/problems/:problem_id')->to('Problem#deleteProblem');
	$self->routes->get('/problem-bank/api/courses/:course_id/problems/:problem_id/render')
		->to('Problem#renderProblem');
	return;
}

sub studentRoutes ($self) {
	$self->routes->get('/problem-bank/api/courses/:course_id/students')->to('student#getStudents');
	$self->routes->post('/problem-bank/api/courses/:course_id/students')->to('student#addStudent');
	$self->routes->put('/problem-bank/api/courses/:course_id/students/:user_id')->to('student#updateStudent');
	$self->routes->delete('/problem-bank/api/courses/:course_id/students/:user_id')->to('student#deleteStudent');
	return;
}


1;
