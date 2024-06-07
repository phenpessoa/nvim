return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config =  function()
            require("nvim-tree").setup({})
        end,
        keys = {
            {
                '<C-O>',
                "<cmd> NvimTreeToggle <CR>",
                desc = 'Find file in Tree'
            },
        }
    },
};
