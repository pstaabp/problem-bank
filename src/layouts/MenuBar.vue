<template>
	<div>
	<q-header>
		<div class="row">
			<div class="col col-md-2 col-12 q-my-auto" style="background-color:#1048ae">
				<q-toolbar>
					<q-btn flat @click="$emit('toggle-menu')" round dense icon="menu" />
					<q-toolbar-title>
						Problem Bank
					</q-toolbar-title>
				</q-toolbar>
			</div>

			<div class="col col-md-9 col-12 q-my-auto">
				<q-toolbar>
					<q-btn-dropdown color="magenta" label="Menu">
						<q-item clickable v-close-popup
							v-for="view in views" :key = "view.name"
							@click="changeView(view)" :icon="view.icon">
							<q-item-section avatar>
								<q-icon :name="view.icon" />
							</q-item-section>
							<q-item-section>{{ view.name }}</q-item-section>
						</q-item>
					</q-btn-dropdown>
					<q-space />
					<q-btn-dropdown  color="secondary" icon="person" :label="current_course?.course_name">
						<q-list>
							<q-item clickable v-close-popup
								v-for="course in courses" :key="course.course_id"
								:to="'/courses/' + course.course_id"
							>
								{{ course.course_name }}
							</q-item>
							<q-item clickable v-close-popup> Logout </q-item>
						</q-list>
					</q-btn-dropdown>
				</q-toolbar>
			</div>
		</div>
	</q-header>
	</div>
</template>

<script setup lang="ts">
import { computed, watch, ref, defineEmits } from 'vue';
import { useCourseStore } from 'src/stores/courses';
import { useRoute, useRouter } from 'vue-router';
import { parseRouteCourseID } from 'src/common/utils';
import type { ViewInfo } from 'src/common/utils';

const course_store = useCourseStore();
const courses = computed(() => course_store.courses);
const route = useRoute();
const router = useRouter();
const course_id = ref(parseRouteCourseID(route));

watch(() => route.params.course_id, () => {
	course_id.value = parseRouteCourseID(route);
});

const current_course = computed(() => courses.value.find(c => c.course_id === course_id.value));

defineEmits(['toggle-menu']);

const views = [
	{
		name: 'Objective Categories', icon: 'category', component_name: 'categories',
	},
	{
		name: 'Learning Objectives', icon: 'lightbulb', component_name: 'objectives'
	},
	{
		name: 'Problems', icon: 'calculate', component_name: 'problems'
	},
	{
		name: 'Quizzes', icon: 'functions', component_name: 'quizzes'
	},
	{
		name: 'Grades', icon: 'money', component_name: 'grades'
	},
	{
		name: 'Students', icon: 'person', component_name: 'students'
	}
];

const changeView = (view: ViewInfo) => {
	void router.push({ name: view.component_name, params: route.params });
};

</script>
