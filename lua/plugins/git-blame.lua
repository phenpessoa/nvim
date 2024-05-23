return {
    {
        "f-person/git-blame.nvim",
        config = function()
            require("gitblame").setup({
                enabled = true,
            })
        end,
        event = { "VeryLazy" },
    },
}
