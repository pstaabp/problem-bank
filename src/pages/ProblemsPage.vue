<template>
<div class="q-ma-md">
	<div class="row">
		<div class="col-2">
			<q-btn color="primary" label="Add Problem" @click="addProblem" />
			<q-list bordered separator dense>
				<q-item v-for="problem in problems"
					clickable
					:key="problem.problem_id"
					@click="selectProblem(problem.problem_id)"
				>
					{{ problem.description }}
				</q-item>
			</q-list>
		</div>
		<div class="col-5 q-ma-md">
			<div class="row">
				<div class="col-12">
					<q-input v-model="selected_problem.description"
						:disable="!editable"
						label="Description"
						@blur="updateProblem"/>
				</div>
			</div>
			<div class="row">
				<div class="col-12">
					<h5>Learning Objectives</h5>
				</div>
			</div>
			<div v-if="editable">
				<div class="row" v-for="cat in categories" :key="cat.category_id">
					<div class="col" v-for="obj in objectivesByCategories(cat.category_id)" :key="obj.obj_id">
						<q-checkbox v-model="los[cat.category_id][obj.obj_id]"
							:disable="!editable"
							:label="`${cat.label}${obj.number}`" />
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12" id="problem-source">
					<q-input
						:disable="!editable"
						v-model="selected_problem.source"
						outlined type="textarea" @blur="updateProblem"/>
				</div>
			</div>
		</div>
		<div class="col-4 q-ma-md">
			<problem-view :problem="(problem_to_render as Problem)" />
		</div>
	</div>
</div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { useRoute } from 'vue-router';

import { useProblemStore } from 'src/stores/problems';
import { Problem } from 'src/models/problems';

import ProblemView from 'src/components/ProblemView.vue';
import { useLearningObjStore } from 'src/stores/learning_objectives';
import { useCategoryStore } from 'src/stores/categories';
import { parseRouteCourseID } from 'src/common/utils';

const route = useRoute();
const problem_store = useProblemStore();
const lo_store = useLearningObjStore();
const category_store = useCategoryStore();

const categories = computed(() => category_store.categories);
const objectives = computed(() => lo_store.objectives);
const problems = computed(() => problem_store.problems);
const selected_problem = ref<Problem>(new Problem());
const problem_to_render = ref<Problem>(new Problem());
const editable = ref(false);
const los = ref<{[key: number]: {[key: number]: boolean}}>({ 1: { 1: true } });
const description = ref('');

const objectivesByCategories = (cat_id: number) => objectives.value.filter(obj => obj.category_id == cat_id);

const selectProblem = (problem_id: number) => {
	const prob = problems.value.find(p => p.problem_id === problem_id)?.clone();

	if (prob) {
		updateLearningObjectives();
		selected_problem.value = prob;
		description.value = selected_problem.value.description;
		problem_to_render.value = selected_problem.value.clone();

		editable.value = true;
	}
};

const updateLearningObjectives = () => {
	categories.value.forEach(cat => {
		const vals = objectivesByCategories(cat.category_id).reduce(
			(current: {[key: number]: boolean}, obj) => {
				const key = obj.obj_id;
				current[key] = true;
				return current;
			}, {});
		los.value[cat.category_id] = vals;
	});
};

updateLearningObjectives();

watch(() => objectives.value, updateLearningObjectives);

const addProblem = () => {
	editable.value = true;
	selected_problem.value = new Problem({
		course_id: parseRouteCourseID(route),
		description: 'New Problem'
	});
	void problem_store.addProblem(selected_problem.value as Problem);
};

const updateProblem = () => {
	void problem_store.updateProblem(selected_problem.value as Problem);
	problem_to_render.value = selected_problem.value.clone();
};
</script>

<style>
	textarea {
		height: 400px;
	}
</style>