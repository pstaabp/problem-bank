<template>
<div class="q-ma-md">
	<q-table
		title="Students"
		:rows="students"
		row-key="user_id"
		:columns="columns"
		selection="single"
		v-model:selected="selected_student"
	>
		<template v-slot:top-right>
			<q-btn v-if="selected_student.length > 0"
				color="primary" label="Delete Selected Student" @click="deleteStudent" />
			<q-btn v-if="selected_student.length > 0"
				color="primary" label="Update Selected Student" @click="updateStudent" />
			<q-btn color="primary" label="Add Student" @click="addStudent" />
		</template>
	</q-table>
	<q-dialog v-model="show_dialog">
		<q-card style="width: 700px; max-width: 80vw;">
			<q-card-section v-if="add_student">
				<div class="text-h6">Add a New Student</div>
			</q-card-section>
			<q-card-section v-else>
				<div class="text-h6">Update Student</div>
			</q-card-section>

			<q-card-section class="q-pt-none">
				<div class="row">
					<div class="col">
						<q-input v-model="student_to_edit.username" label="Username" />
					</div>
					<div class="col">
						<q-input v-model="student_to_edit.first_name" label="First Name" />
					</div>
					<div class="col">
						<q-input v-model="student_to_edit.last_name" label="Last Name" />
					</div>
					<div class="col">
						<q-input v-model="student_to_edit.student_id" label="Student ID" />
					</div>
				</div>
			</q-card-section>

			<q-card-actions align="right" class="bg-white text-teal">
				<q-btn flat label="Cancel" v-close-popup />
				<q-btn v-if="add_student" flat label="Save and Add Another" @click="saveAndAddStudent" />
				<q-btn flat label="Save" @click="addOrUpdateStudent" />
			</q-card-actions>
		</q-card>
	</q-dialog>
</div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { useQuasar } from 'quasar';
import { useRoute } from 'vue-router';
import { useStudentStore } from 'src/stores/students';
import { Student } from 'src/models/students';
import { parseRouteCourseID } from 'src/common/utils';

const $q = useQuasar();
const route = useRoute();
const student_store = useStudentStore();
const students = computed(() => student_store.students);
const selected_student = ref<Student[]>([]);
const show_dialog = ref(false);
const student_to_edit = ref(new Student({ course_id: parseRouteCourseID(route)}));
// determine if the dialog is a new or updated student.
const add_student = ref(true);

const saveAndAddStudent = () => {
	student_store.addStudent(student_to_edit.value as Student);
	student_to_edit.value = new Student({ course_id: parseRouteCourseID(route)});
};

const addOrUpdateStudent = async () => {
	if (add_student.value) {
		await student_store.addStudent(student_to_edit.value as Student);
		$q.notify({
			message: 'The student was successfully added.',
			color: 'green'
		});
		show_dialog.value = false;
	} else {
		student_store.updateStudent(student_to_edit.value as Student);
		$q.notify({
			message: 'The student was successfully updated.',
			color: 'green'
		});
		show_dialog.value = false;
		selected_student.value = [];
	}
};

const addStudent = () => {
	add_student.value = true;
	show_dialog.value = true;
	student_to_edit.value = new Student({ course_id: parseRouteCourseID(route)});
}

const updateStudent = () => {
	add_student.value = false;
	show_dialog.value = true;
	student_to_edit.value = selected_student.value[0].clone() as Student;
}

const deleteStudent = async () => {
	const conf = confirm('Do you wish to delete the selected student?');
	if (conf) {
		await student_store.deleteStudent(selected_student.value[0] as Student);
		$q.notify({
			message: 'The student was successfully deleted.',
			color: 'green'
		});
	}
}

const columns = [
	{
		name: 'username',
		label: 'Username',
		field: 'username',
		sortable: true
	},
	{
		name: 'first_name',
		label: 'First Name',
		field: 'first_name',
		sortable: true
	},
	{
		name: 'last_name',
		label: 'Last Name',
		field: 'last_name',
		sortable: true
	},
	{
		name: 'student_id',
		label: 'Student ID',
		field: 'student_id',
		sortable: true
	}
]
</script>