import axios from 'axios';
import { defineStore } from 'pinia';

import { ParseableProblem, Problem } from 'src/models/problems';

export interface ProblemState {
	problems: Problem[];
}

export const useProblemStore = defineStore('problems', {
	state: (): ProblemState => ({
		problems: []
	}),
	actions: {
		async fetchProblems(course_id: number) : Promise<void> {
			const response = await axios.get(`/problem-bank/api/courses/${course_id}/problems`);
			const problems_to_parse = response.data as ParseableProblem[];
			this.problems = problems_to_parse.map(obj => new Problem(obj));
		},
		async addProblem(problem: Problem) : Promise<Problem> {
			const url = `/problem-bank/api/courses/${problem.course_id}/problems`;
			const response = await axios.post(url, problem.toObject());
			const new_problem = new Problem(response.data as ParseableProblem);
			this.problems.push(new_problem);
			return new_problem;
		},
		async updateProblem(problem: Problem): Promise<Problem> {
			const url = `/problem-bank/api/courses/${problem.course_id}/problems/${problem.problem_id}`;
			const response = await axios.put(url, problem.toObject());
			const updated_problem = new Problem(response.data as ParseableProblem);
			const index = this.problems.findIndex(p => p.problem_id === updated_problem.problem_id);
			this.problems.splice(index, 1, updated_problem);
			return updated_problem;
		},
		async deleteProblem(problem: Problem): Promise<Problem> {
			const url = `/problem-bank/api/courses/${problem.course_id}/problems/${problem.problem_id}`;
			const response = await axios.delete(url, problem.toObject());
			const deleted_problem = new Problem(response.data as ParseableProblem);
			const index = this.problems.findIndex(p => p.problem_id === deleted_problem.problem_id);
			this.problems.splice(index, 1);
			return deleted_problem;
		}
	}
});
