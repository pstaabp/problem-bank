import axios from 'axios';
import { defineStore } from 'pinia';

import { Category, ParseableCategory } from 'src/models/categories';

export interface CategoryState {
	categories: Category[];
	all_categories: Category[];
}

export const useCategoryStore = defineStore('categories', {
	state: (): CategoryState => ({
		categories: [],
		all_categories: []
	}),
	getters: { },
	actions: {
		async fetchAllCategories() : Promise<void> {
			const response = await axios.get('/problem-bank/api/catgories');
			const categories_to_parse = response.data as ParseableCategory[];
			this.all_categories = categories_to_parse.map(obj => new Category(obj));
		},
		async fetchCategories(course_id: number) : Promise<void> {
			const response = await axios.get(`/problem-bank/api/courses/${course_id}/categories`);
			const objectives_to_parse = response.data as ParseableCategory[];
			this.categories = objectives_to_parse.map(obj => new Category(obj));
		},
		async addCategory(cat: Category) : Promise<Category> {
			const url = `/problem-bank/api/courses/${cat.course_id}/categories`;
			const response = await axios.post(url, cat.toObject());
			const new_category = new Category(response.data as ParseableCategory);
			this.categories.push(new_category);
			return new_category;
		},
		async updateCategory(cat: Category): Promise<Category> {
			const url = `/problem-bank/api/courses/${cat.course_id}/categories/${cat.category_id}`;
			const response = await axios.put(url, cat.toObject());
			const updated_category = new Category(response.data as ParseableCategory);
			const index = this.categories.findIndex(c => c.category_id === updated_category.category_id);
			this.categories.splice(index, 1, updated_category);
			return updated_category;
		},
		async deleteCategory(cat: Category): Promise<Category> {
			const url = `/problem-bank/api/courses/${cat.course_id}/categories/${cat.category_id}`;
			const response = await axios.delete(url, cat.toObject());
			const deleted_category = new Category(response.data as ParseableCategory);
			const index = this.categories.findIndex(c => c.category_id === deleted_category.category_id);
			this.categories.splice(index, 1);
			return deleted_category;
		}
	}
});
