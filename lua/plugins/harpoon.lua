return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = { "VeryLazy" },
        config = function()
            local harpoon = require "harpoon"
            harpoon:setup()
            require("telescope").load_extension("harpoon")
        end,
        keys = function()
            local harpoon = require "harpoon"

            return {
                {
                    "<leader>ha",
                    function()
                        harpoon:list():add()
                    end,
                    desc = "Add file to harpoon",
                },
                {
                    "<leader>ho",
                    function()
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Toggle harpoon's quick menu",
                },
                {
                    "<leader>hc",
                    function()
                        harpoon:list():clear()
                    end,
                    desc = "Clear harpoon list",
                },
                {
                    "<Tab>",
                    function()
                        harpoon:list():next({ ui_nav_wrap = true })
                    end,
                    desc = "Navigate to next harpoon's mark",
                },
                {
                    "<S-Tab>",
                    function()
                        harpoon:list():prev({ ui_nav_wrap = true })
                    end,
                    desc = "Navigate to prev harpoon's mark",
                },
            }
        end,
    },
}
