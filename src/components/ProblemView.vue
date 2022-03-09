<template>
	<div class="q-ma-md">
		<div id="problem" v-html="problem_source"/>
	</div>
</template>

<script lang="ts">
import axios from 'axios';
import { defineComponent, PropType, ref, watch } from 'vue';
import typeset from './mathjax-config';

import { Problem } from 'src/models/problems';

declare global {
	interface Window {
		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		MathJax: any
	}
}

interface RenderedProblem {
	output: string;
}

export default defineComponent({
	name: 'ProblemView',
	props: {
		problem: {
			type: Object as PropType<Problem>,
			default: new Problem()
		},
	},
	setup(props) {
		const problem_source = ref('');

		watch(() => props.problem, async () => {
			const url = `/problem-bank/api/courses/${props.problem.course_id}/problems/` +
				`${props.problem.problem_id}/render`;
			const response = await axios.get(url);
			const rendered_source = response.data as RenderedProblem;
			problem_source.value = rendered_source.output;
			const problem_div = document.querySelector('#problem');
			if (problem_div) {
				await typeset(problem_div);
			}
		}, { deep: true });

		return {
			problem_source
		};
	}
});

</script>
