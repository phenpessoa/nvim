return {
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {},
        event = { "VeryLazy" },
        keys = {
            {
                "<S-T>",
                "<cmd> Trouble <CR>",
                desc = "Opens trouble,"
            },
        },
    },
}
