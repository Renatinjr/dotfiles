-- tailwindcss-language-server: broad filetype/root coverage plus classRegex for
-- clsx/cn/cva helpers.
return {
	filetypes = {
		"html",
		"css",
		"postcss",
		"sass",
		"scss",
		"javascript.jsx",
		"javascriptreact",
		"typescript.tsx",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},
	single_file_support = true,
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.cjs",
		"postcss.config.mjs",
		"postcss.config.ts",
		"pnpm-workspace.yaml",
		"turbo.json",
		"yarn.lock",
		"package-lock.json",
		"bun.lock",
		".git",
	},
	init_options = {
		userLanguages = {
			typescriptreact = "html",
			javascriptreact = "html",
		},
	},
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "ngClass", "classList" },
			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},
			experimental = {
				classRegex = {
					{ 'class:\\s*"([^"]*)"' },
					{ 'className:\\s*"([^"]*)"' },
					{ "clsx\\(([^)]*)\\)", '"([^"]*)"' },
					{ "cn\\(([^)]*)\\)", '"([^"]*)"' },
					{ "cva\\(([^)]*)\\)", '"([^"]*)"' },
				},
			},
		},
	},
}
