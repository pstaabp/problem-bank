<template>
	<h3>Select a Course </h3>
	<div class="q-pa-md row items-start q-gutter-md">
		<q-card v-for="course in courses" :key="course.course_id">
			<q-card-actions>
				<q-btn :to="'/courses/'+course.course_id + '/objectives'">{{ course.course_name }}</q-btn>
			</q-card-actions>
		</q-card>
	</div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useCourseStore } from 'src/stores/courses';

const course_store = useCourseStore();
const courses = computed(() => course_store.courses);
</script>