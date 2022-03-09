/* eslint-disable @typescript-eslint/no-unused-vars, @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call */

interface Window {
	MathJax: any
}

const script = document.createElement('script');
script.src = '/node_modules/mathjax-full/es5/tex-chtml-full.js';
script.async = true;
document.head.appendChild(script);

window.MathJax = {
	tex: {
		inlineMath: [['$', '$'], ['\\(', '\\)']],
		packages: { '[+]': ['noerrors'] }
	},
	loader: {
		paths: {
			custom: 'node_modules/mathjax'
		},
		load: ['input/asciimath', '[tex]/noerrors']
	},
	startup: {
		ready: () => {
			const AM = window.MathJax.InputJax.AsciiMath.AM;
			for (let i = 0; i < AM.symbols.length; ++i) {
				if (AM.symbols[i].input == '**') {
					AM.symbols[i] = { input: '**', tag: 'msup', output: '^', tex: null, ttype: AM.TOKEN.INFIX };
				}
			}
			return window.MathJax.startup.defaultReady();
		}
	},
	options: {
		renderActions: {
			findScript: [10, (doc: any) => {
				document.querySelectorAll('script[type^="math/tex"]').forEach((node: Element) => {
					const display = !!/; *mode=display/.exec((node as HTMLScriptElement).type);
					const math = new doc.options.MathItem(node.textContent, doc.inputJax[0], display);
					const text = document.createTextNode('');
					node.parentNode?.replaceChild(text, node);
					math.start = { node: text, delim: '', n: 0 };
					math.end = { node: text, delim: '', n: 0 };
					doc.math.push(math);
				});
			}, '']
		},
		ignoreHtmlClass: 'tex2jax_ignore'
	}

};

export default (element: Element) => {
	if (window.MathJax && typeof window.MathJax.typesetPromise == 'function') {
		window.MathJax.startup.promise = window.MathJax.startup.promise.then(
			() => window.MathJax.typesetPromise([element])
		);
		return window.MathJax.startup.promise;
	}
};
