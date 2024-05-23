return {
    {
        "numToStr/FTerm.nvim",
        config = function()
            require("FTerm").setup({
                border = 'double',
                dimensions  = {
                    height = 0.9,
                    width = 0.9,
                },
            })
        end,
        event = { "VeryLazy" },
        keys = function()
            local fterm = require("FTerm")

            return {
                {
                    "<leader>fto",
                    function()
                        fterm.open()
                    end,
                    desc = "Open floating terminal",
                },
                {
                    "<leader>lzg",
                    function()
                        fterm.run("lazygit")
                    end,
                    desc = "Open floating terminal",
                },
            }
        end,
    },
}
