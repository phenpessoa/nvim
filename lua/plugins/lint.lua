return {
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            require "plugins.configs.lint"
        end
  },
}
