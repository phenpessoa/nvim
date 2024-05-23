return {
    {
        "ray-x/go.nvim",
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                tag_options="",
            })
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()',
        keys = {
            {
                "<leader>gsj",
                "<cmd> GoAddTag json <CR>",
                desc = "Add json struct tags",
            },
            {
                "<leader>gsy",
                "<cmd> GoAddTag yaml <CR>",
                desc = "Add yaml struct tags",
            },
        },
    },
}
