<template>
	<div class="q-ma-lg">
		<q-table
			title="Categories"
			:columns="columns"
			:rows="categories"
			selection="single"
			v-model:selected="selected_category"
			:row-key="row => row.category_id"
		>
			<template v-slot:top-right>
				<q-btn v-if="selected_category.length>0"
					color="primary" label="Delete Selected Category" @click="deleteCategory" />
				<q-btn v-if="selected_category.length>0"
					color="primary" label="Edit Selected Category" @click="setCategoryToUpdate" />
				<q-btn color="primary" label="Add Category" @click="setCategoryToAdd" />
			</template>
		</q-table>
	</div>
	<q-dialog
			v-model="add_category_dialog"
		>
			<q-card style="width: 700px; max-width: 80vw;">
				<q-card-section>
					<div class="text-h6">Add a New Category</div>
				</q-card-section>

				<q-card-section class="q-pt-none">
					<q-input v-model="category_to_edit.label" label="Label" />
				</q-card-section>
				<q-card-section class="q-pt-none">
					<q-input v-model="category_to_edit.description" label="Description" />
				</q-card-section>

				<q-card-actions align="right" class="bg-white text-teal">
					<q-btn flat label="Cancel" v-close-popup />
					<q-btn flat label="Save" @click="addOrUpdateCategory" />
				</q-card-actions>
			</q-card>
		</q-dialog>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { useQuasar } from 'quasar';
import { useRoute } from 'vue-router';

import { useCategoryStore } from 'src/stores/categories';
import { Category } from 'src/models/categories';
import { parseRouteCourseID } from 'src/common/utils';

const route = useRoute();
const $q = useQuasar();
const category_store = useCategoryStore();
const categories = computed(() => category_store.categories);
const add_category_dialog = ref(false);

const selected_category = ref<Category[]>([]);
// This determines if the dialog adds a new category (true) or
// updates the current category.
const add_category = ref(true);
const category_to_edit = ref<Category>(new Category());

const addOrUpdateCategory = async () => {
	if (add_category.value) {
		await category_store.addCategory(category_to_edit.value as Category);
		$q.notify({
			message: 'The category was successfully added.',
			color: 'green'
		});
	} else {
		await category_store.updateCategory(category_to_edit.value as Category);
		$q.notify({
			message: 'The category was successfully updated.',
			color: 'green'
		});
	}
	add_category_dialog.value = false;
};

const setCategoryToAdd = () => {
	add_category.value = true;
	category_to_edit.value = new Category({ course_id: parseRouteCourseID(route) });
	add_category_dialog.value = true;
};

const setCategoryToUpdate = () => {
	add_category.value = false;
	category_to_edit.value = selected_category.value[0].clone();
	add_category_dialog.value = true;
};

const deleteCategory = async () => {
	const msg = `Are you sure you want to delete the category ${selected_category.value[0].label}?`;
	const conf = confirm(msg);
	if (conf) {
		await category_store.deleteCategory(selected_category.value[0] as Category);
		$q.notify({
			message: 'The category was successfully deleted.',
			color: 'green'
		});
	}
};

const columns = [
	{
		name: 'label',
		label: 'Label',
		field: 'label'
	},
	{
		name: 'description',
		label: 'Description',
		field: 'description'
	}
];

</script>