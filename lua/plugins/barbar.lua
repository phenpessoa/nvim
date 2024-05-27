return {
    {
        "romgrk/barbar.nvim",
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {},
        config = function(_, opts)
            require("barbar").setup(opts)

            local set = vim.keymap.set
            local options = { noremap = true, silent = true }

            set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', options)
            set('n', '<Tab>', '<Cmd>BufferNext<CR>', options)
            set('n', '<leader>x', '<Cmd>BufferClose<CR>', options)
            set('n', '<leader>ca', '<Cmd>BufferCloseAllButCurrent<CR>', options)
            set('n', '<C-p>', '<Cmd>BufferPick<CR>', options)
        end
    },
}
