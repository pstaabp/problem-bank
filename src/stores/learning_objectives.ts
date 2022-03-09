import axios from 'axios';
import { defineStore } from 'pinia';

import { LearningObjective, ParseableLearningObjective } from 'src/models/learning_objectives';
import { useCategoryStore } from './categories';

export interface LearningObjectivesState {
	objectives: LearningObjective[];
	all_objectives: LearningObjective[];
}

const getCourseID = (category_id: number) => {
	const category_store = useCategoryStore();
	const category = category_store.categories.find(cat => cat.category_id === category_id);
	return category?.course_id ?? 0;
};

export const useLearningObjStore = defineStore('objectives', {
	state: (): LearningObjectivesState => ({
		objectives: [],
		all_objectives: []
	}),
	getters: { },
	actions: {
		async fetchAllObjectives() : Promise<void> {
			const response = await axios.get('/problem-bank/api/objectives');
			const objectives_to_parse = response.data as ParseableLearningObjective[];
			this.all_objectives = objectives_to_parse.map(obj => new LearningObjective(obj));
		},
		async fetchObjectives(course_id: number) : Promise<void> {
			const response = await axios.get(`/problem-bank/api/courses/${course_id}/objectives`);
			const objectives_to_parse = response.data as ParseableLearningObjective[];
			this.objectives = objectives_to_parse.map(obj => new LearningObjective(obj));
		},
		async addObjective(obj: LearningObjective) : Promise<LearningObjective> {
			const course_id = getCourseID(obj.category_id);
			const url = `/problem-bank/api/courses/${course_id}/objectives`;
			const response = await axios.post(url, obj.toObject());
			const new_objective = new LearningObjective(response.data as ParseableLearningObjective);
			this.objectives.push(new_objective);
			return new_objective;
		},
		async updateObjective(obj: LearningObjective): Promise<LearningObjective> {
			const course_id = getCourseID(obj.category_id);
			const url = `/problem-bank/api/courses/${course_id}/objectives/${obj.obj_id}`;
			const response = await axios.put(url, obj.toObject());
			const updated_objective = new LearningObjective(response.data as ParseableLearningObjective);
			const index = this.objectives.findIndex(obj => obj.obj_id === updated_objective.obj_id);
			this.objectives.splice(index, 1, updated_objective);
			return updated_objective;
		},
		async deleteObjective(obj: LearningObjective): Promise<LearningObjective> {
			const course_id = getCourseID(obj.category_id);
			const url = `/problem-bank/api/courses/${course_id}/objectives/${obj.obj_id}`;
			const response = await axios.delete(url, obj.toObject());
			const deleted_objective = new LearningObjective(response.data as ParseableLearningObjective);
			const index = this.objectives.findIndex(obj => obj.obj_id === deleted_objective.obj_id);
			this.objectives.splice(index, 1);
			return deleted_objective;
		}
	}
});
