import axios from 'axios';
import { defineStore } from 'pinia';

import { Course, ParseableCourse } from 'src/models/courses';

export interface CourseState {
	courses: Course[];
}

export const useCourseStore = defineStore('courses', {
	state: (): CourseState => ({
		courses: []
	}),
	getters: { },
	actions: {
		async fetchCourses() : Promise<void> {
			const response = await axios.get('/problem-bank/api/courses');
			const courses_to_parse = response.data as Course[];
			this.courses = courses_to_parse.map(course => new Course(course));
		},
		async addCourse(course: Course): Promise<Course> {
			const response = await axios.post('/problem-bank/api/courses', course);
			const new_course = new Course(response.data as ParseableCourse);
			this.courses.push(new_course);
			return new_course;
		}
	}
});
