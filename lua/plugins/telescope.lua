return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    cmd = "Telescope",
    keys = function()
      local builtin = require('telescope.builtin')

      return {
        {
          "<leader>ff",
          builtin.find_files,
          desc = "Find File",
        },
        {
          "<leader>fb",
          builtin.buffers,
          desc = "Find Buffer",
        },
        {
          "<leader>fw",
          builtin.live_grep,
          desc = "Find with Grep",
        },
        {
          "<leader>fh",
          builtin.help_tags,
          desc = "Find Help",
        },
      }
    end,
    opts = function()
      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          previewer = true,
          file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
        },
        extensions = {},
        extensions_list = {},
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
}
