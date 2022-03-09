import axios from 'axios';
import { defineStore } from 'pinia';

import { ParseableStudent, Student } from 'src/models/students';

export interface StudentsState {
	students: Student[];
}

export const useStudentStore = defineStore('students', {
	state: (): StudentsState => ({
		students: []
	}),
	actions: {
		async fetchStudents(course_id: number) : Promise<void> {
			const response = await axios.get(`/problem-bank/api/courses/${course_id}/students`);
			const students_to_parse = response.data as ParseableStudent[];
			this.students = students_to_parse.map(obj => new Student(obj));
		},
		async addStudent(student: Student) : Promise<Student> {
			const url = `/problem-bank/api/courses/${student.course_id}/students`;
			const response = await axios.post(url, student.toObject());
			const new_Student = new Student(response.data as ParseableStudent);
			this.students.push(new_Student);
			return new_Student;
		},
		async updateStudent(student: Student): Promise<Student> {
			const url = `/problem-bank/api/courses/${student.course_id}/students/${student.user_id}`;
			const response = await axios.put(url, student.toObject());
			const updated_Student = new Student(response.data as ParseableStudent);
			const index = this.students.findIndex(student => student.user_id === updated_Student.user_id);
			this.students.splice(index, 1, updated_Student);
			return updated_Student;
		},
		async deleteStudent(student: Student): Promise<Student> {
			const url = `/problem-bank/api/courses/${student.course_id}/students/${student.user_id}`;
			const response = await axios.delete(url, student.toObject());
			const deleted_Student = new Student(response.data as ParseableStudent);
			const index = this.students.findIndex(student => student.user_id === deleted_Student.user_id);
			this.students.splice(index, 1);
			return deleted_Student;
		}
	}
});
