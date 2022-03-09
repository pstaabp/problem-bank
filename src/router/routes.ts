import DashboardPage from 'src/pages/DashboardPage.vue';
import MainLayout from 'src/layouts/MainLayout.vue';
import CourseLayout from 'src/layouts/CourseLayout.vue';
import LearningObjectives from 'src/pages/LearningObjectives.vue';
import ProblemsPage from 'src/pages/ProblemsPage.vue';
import CoursesPage from 'src/pages/CoursesPage.vue';
import GradesPage from 'src/pages/GradesPage.vue';
import StudentsPage from 'src/pages/StudentsPage.vue';
import QuizzesPage from 'src/pages/QuizzesPage.vue';

import { RouteRecordRaw } from 'vue-router';
import CategoryPage from 'src/pages/CategoryPage.vue';

const routes: RouteRecordRaw[] = [
	{
		path: '/',
		redirect: 'dashboard'
	},
	{
		path: '/',
		component: MainLayout,
		children: [
			{
				path: 'dashboard',
				component: DashboardPage
			},
			{
				path: 'courses/:course_id',
				component: CourseLayout,
				children: [
					{
						name: 'categories',
						path: 'categories',
						component: CategoryPage
					},
					{
						name: 'objectives',
						path: 'objectives',
						component: LearningObjectives
					},
					{
						name: 'courses',
						path: 'courses',
						component: CoursesPage
					},
					{
						name: 'problems',
						path: 'problems',
						component: ProblemsPage
					},
					{
						name: 'students',
						path: 'students',
						component: StudentsPage
					},
					{
						name: 'grades',
						path: 'grades',
						component: GradesPage
					},
					{
						name: 'quizzes',
						path: 'quizzes',
						component: QuizzesPage
					}
				]
			}
		]
	},
];

export default routes;