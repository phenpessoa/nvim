return {
	{
		"laytan/tailwind-sorter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm ci && npm run build",
		opts = {
			on_save_enabled = true,
			on_save_pattern = {
				"*.html",
				"*.js",
				"*.jsx",
				"*.tsx",
				"*.twig",
				"*.hbs",
				"*.php",
				"*.heex",
				"*.astro",
				"*.templ",
			},
			node_path = "node",
			trim_spaces = true,
		},
		config = true,
	},
}
