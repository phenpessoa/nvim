return {
	ensure_installed = {
		"lua",
		"go",
		"templ",
		"rust",
        "javascript",
        "typescript",
		"pkl",
		"gleam",

        "json",
        "yaml",
        "sql",
        "markdown",
        "html",
        "css",
        "proto",

        "dockerfile",
	},
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	indent = { enable = true },
	autotag = {
		enable = true,
		enable_rename = true,
		enable_close = true,
		enable_close_on_slash = true,
		filetypes = { "html", "xml", "templ" },
	},
}
