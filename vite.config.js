/* eslint-disable no-undef */

import { defineConfig, loadEnv } from 'vite';
import vue from '@vitejs/plugin-vue';
import { quasar, transformAssetUrls } from '@quasar/vite-plugin';
import path from 'path';

// https://vitejs.dev/config/
export default ({ mode }) => {
	process.env = { ...process.env, ...loadEnv(mode, process.cwd(), '') };

	// import.meta.env.VITE_NAME available here with: process.env.VITE_NAME
	// import.meta.env.VITE_PORT available here with: process.env.VITE_PORT
	return defineConfig({
		plugins: [
			vue({
				template: { transformAssetUrls },
				customElement: true
			}),

			quasar({
				sassVariables: 'src/assets/quasar-variables.sass'
			})
		],
		server: {
			port: 3333,
			proxy: {
				'/problem-bank/api': 'http://localhost:3000'
			}
		},
		resolve: {
			alias: {
				'@': path.resolve(__dirname, './src'),
				'src': path.resolve(__dirname, './src'),
				'boot': path.resolve(__dirname, './src/boot')
			},
		},
	});
};