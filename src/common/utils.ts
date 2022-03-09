import type { RouteLocationNormalizedLoaded } from 'vue-router';

export const parseRouteCourseID = (route: RouteLocationNormalizedLoaded) => parseInt(
	Array.isArray(route.params.course_id) ?
		route.params.course_id[0] :
		route.params.course_id);

export interface ViewInfo {
	name: string;
	icon: string;
	component_name: string;
}