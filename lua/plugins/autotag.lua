return {
    {
        "windwp/nvim-ts-autotag",
        opts = {
            enable = true,
            enable_close = true,
            enable_rename = true,
            enable_close_on_slash = false,
            filetypes = {
                "templ",
            },
		},
        lazy = false,
        config = function(_, opts)
            require("nvim-ts-autotag").setup(opts)
        end,
    },
}
