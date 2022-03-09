import { createRouter, createWebHistory } from 'vue-router';
import routes from './routes';

/*
 * If not building with SSR mode, you can
 * directly export the Router instantiation;
 *
 * The function below can be async too; either use
 * async/await or return a Promise which resolves
 * with the Router instance.
 */

export default function () {

	// This following isn't working yet.   Hardcode this
	const createHistory = createWebHistory;
	// const createHistory = import.meta.env.SERVER
	// ? createMemoryHistory
	// : (import.meta.env.VUE_ROUTER_MODE === 'history' ? createWebHistory : createWebHashHistory);

	const Router = createRouter({
		scrollBehavior: () => ({ left: 0, top: 0 }),
		routes,

		// Leave this as is and make changes in quasar.conf.js instead!
		// quasar.conf.js -> build -> vueRouterMode
		// quasar.conf.js -> build -> publicPath
		history: createHistory(
			//`Again, not working
			// import.meta.env.MODE === 'ssr' ? void 0 : import.meta.env.VUE_ROUTER_BASE
			'/problem-bank'
		),
	});

	return Router;
}
