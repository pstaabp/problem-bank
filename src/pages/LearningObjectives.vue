<template>
	<div class="q-pa-md">
		<q-tabs
			v-model="tab"
			class="text-teal"
		>
			<q-tab v-for="cat in categories" :name="cat.label" :label="cat.label" :key="cat.label">
			</q-tab>
		</q-tabs>
		<q-tab-panels v-model="tab">
			<q-tab-panel v-for="cat in categories" :name="cat.label" :key="cat.label">
				<q-table
					title="Learning Objectives"
					:rows="selected_objectives"
					:columns="columns"
					selection="single"
					v-model:selected="selected_objective"
					:row-key="row => row.obj_id"
				>
					<template v-slot:top-right>
						<q-btn v-if="selected_objective.length>0"
							color="primary" label="Delete Selected Category" @click="deleteObjective" />
						<q-btn v-if="selected_objective.length>0"
							color="primary" label="Edit Selected Category" @click="updateObjective" />
						<q-btn label="Add Learning Objective" color="primary" @click="addObjective"/>
					</template>
				</q-table>
			</q-tab-panel>
		</q-tab-panels>
	</div>
	<q-dialog
      v-model="edit_objective_dialog"
    >
      <q-card style="width: 700px; max-width: 80vw;">
        <q-card-section>
          <div class="text-h6">Add a New Category</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
					<q-input v-model="objective_to_edit.number" label="Number" />
        </q-card-section>
				<q-card-section class="q-pt-none">
					<q-input v-model="objective_to_edit.description" label="Description" />
        </q-card-section>

        <q-card-actions align="right" class="bg-white text-teal">
					<q-btn flat label="Cancel" v-close-popup />
          <q-btn flat label="Save" @click="addOrUpdateObjective" />
        </q-card-actions>
      </q-card>
    </q-dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useQuasar } from 'quasar';
import { useLearningObjStore } from 'src/stores/learning_objectives';
import { computed } from 'vue';
import { useCategoryStore } from 'src/stores/categories';
import { LearningObjective } from 'src/models/learning_objectives';

const $q = useQuasar();

const lo_store = useLearningObjStore();
const category_store = useCategoryStore();
const edit_objective_dialog = ref(false);
const objective_to_edit = ref(new LearningObjective());
const selected_objective = ref<LearningObjective[]>([]);
// Used to determine if an objective is being added or updated.
const add_objective = ref(true);

const categories = computed(() => category_store.categories);
const category_id = computed(() => {
	const cat = category_store.categories.find(cat => cat.label === tab.value);
	return cat ? cat.category_id : 0;
});
const selected_objectives = computed(() =>
	lo_store.objectives.filter(obj => obj.category_id === category_id.value)
);
const tab = ref(categories.value.length === 0 ? '' : categories.value[0].label);
const columns = [ {
	name: 'number',
	label: 'Number',
	field: 'number'
}, {
	name: 'description',
	label: 'Description',
	field: 'description'
}];

const addObjective = () => {
	add_objective.value = true;
	objective_to_edit.value = new LearningObjective({
		number:  selected_objectives.value.length + 1,
		category_id: category_id.value
	});
	edit_objective_dialog.value = true;
};

const updateObjective = () => {
	add_objective.value = false;
	objective_to_edit.value = selected_objective.value[0].clone();
	edit_objective_dialog.value = true;
};

const addOrUpdateObjective = async () => {
	if (add_objective.value) {
		await lo_store.addObjective(objective_to_edit.value as LearningObjective);
		$q.notify({
			message: 'The learning objective was successfully added.',
			color: 'green'
		});
	} else {
		await lo_store.updateObjective(objective_to_edit.value as LearningObjective);
		$q.notify({
			message: 'The category was successfully updated.',
			color: 'green'
		});
	}
	edit_objective_dialog.value = false;
};

const deleteObjective = async () => {
	const msg = 'Are you sure you want to delete the selected objective?';
	const conf = confirm(msg);
	if (conf) {
		await lo_store.deleteObjective(selected_objective.value[0] as LearningObjective);
		$q.notify({
			message: 'The objective was successfully deleted.',
			color: 'green'
		});
	}
};
</script>