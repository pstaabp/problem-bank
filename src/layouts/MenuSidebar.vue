<template>
	<template v-for="view in views" :key="view">
		<q-item clickable v-close-popup @click="changeView(view)" :icon="view.icon">
			<q-item-section avatar>
				<q-icon :name="view.icon" />
			</q-item-section>
			<q-item-section>{{ view.name }}</q-item-section>
		</q-item>
	</template>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';

interface ViewInfo {
	name: string;
	icon: string;
	component_name: string;
}

export default defineComponent({
	name: 'MenuSidebar',
	setup() {
		const route = useRoute();
		const router = useRouter();
		const sidebar_open = ref<boolean>(false);
		return {
			sidebar_open,
			views: [{
				name: 'Courses', icon: 'help', component_name: 'courses'
			},
			{
				name: 'Learning Objectives', icon: 'lightbulb', component_name: 'objectives'
			},
			{
				name: 'Problems', icon: 'calculate', component_name: 'problems'
			},
			{
				name: 'Grades', icon: 'money', component_name: 'grades'
			}],
			changeView: (view: ViewInfo) => {
				void router.push({ name: view.component_name, params: route.params });
			}
		};
	}
});
</script>
