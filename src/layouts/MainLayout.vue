<template>
	<q-layout view="hHh Lpr lFf">
		<menu-bar
			@toggleMenu="left_sidebar_open = !left_sidebar_open"
		/>

		<q-drawer
			v-model="left_sidebar_open"
			:width="240"
			:breakpoint="700"
			bordered
			class="bg-grey-3"
		>
		</q-drawer>

		<q-page-container>
			<router-view />
		</q-page-container>

	</q-layout>
</template>

<script lang="ts">
import { defineComponent, ref, watch } from 'vue';
import { useRoute } from 'vue-router';

import MenuBar from './MenuBar.vue';
import { useCourseStore } from 'src/stores/courses';
import { useLearningObjStore } from 'src/stores/learning_objectives';
import { parseRouteCourseID } from 'src/common/utils';
import { useCategoryStore } from 'src/stores/categories';
import { useProblemStore } from 'src/stores/problems';
import { useStudentStore } from 'src/stores/students';

export default defineComponent({
	components: {
		MenuBar
	},
	setup() {
		const route = useRoute();
		const lo_store = useLearningObjStore();
		const category_store = useCategoryStore();
		const problem_store = useProblemStore();

		watch(() => route.params.course_id, () => {
			const course_id = parseRouteCourseID(route);
			if (course_id > 0) {
				void lo_store.fetchObjectives(course_id);
				void category_store.fetchCategories(course_id);
				void problem_store.fetchProblems(course_id);
			}
		});

		return {
			left_sidebar_open: ref(false),
		};
	},
	created() {
		const route = useRoute();
		const courses = useCourseStore();
		void courses.fetchCourses();

		const lo_store = useLearningObjStore();
		const category_store = useCategoryStore();
		const problem_store = useProblemStore();
		const student_store = useStudentStore();
		const course_id = parseRouteCourseID(route);
		if (course_id > 0) {
			void lo_store.fetchObjectives(course_id);
			void category_store.fetchCategories(course_id);
			void problem_store.fetchProblems(course_id);
			void student_store.fetchStudents(course_id);
		}

	}
});
</script>
