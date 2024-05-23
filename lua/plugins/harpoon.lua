return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        event = { "VeryLazy" },
        config = function()
            local harpoon = require "harpoon"
            harpoon:setup()
        end,
        keys = function()
            local harpoon = require "harpoon"
            local conf = require("telescope.config").values
            local action_state = require('telescope.actions.state')
            local transform_mod = require('telescope.actions.mt').transform_mod

            local function get_harpoon_file_paths()
                local file_paths = {}
                for _, item in ipairs(harpoon:list().items) do
                    table.insert(file_paths, item.value)
                end
                return file_paths
            end

            local actions = transform_mod({
                remove_item_under_cursor = function(prompt_bufnr)
                    local current_picker = action_state.get_current_picker(prompt_bufnr)
                    local current_entry = action_state.get_selected_entry()

                    if current_entry then
                        local item = current_entry.value
                        harpoon:list():remove({ value = item })
                        local finder = require("telescope.finders").new_table({
                            results = get_harpoon_file_paths(),
                            entry_maker = current_picker.finder.entry_maker,
                        })

                        current_picker:refresh(finder, { reset_prompt = false })
                    end
                end
            })


            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.remove_item_under_cursor,
                        },
                    },
                }
            })

            local function toggle_telescope()
                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = get_harpoon_file_paths(),
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

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
                        toggle_telescope()
                    end,
                    desc = "Toggle harpoon's quick menu",
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
