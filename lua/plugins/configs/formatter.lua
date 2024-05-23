vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    command = "FormatWriteLock"
})

return {
  filetype = {
    javascript = {
      require("formatter.filetypes.javascript").prettier
    },
    typescript = {
      require("formatter.filetypes.typescript").prettier
    },
    html = {
      require("formatter.filetypes.html").prettier
    },
    css = {
      require("formatter.filetypes.css").prettier
    },
    go = {
      function()
        return {
          exe = "gofumpt",
          args = { "-l", "-w" },
        }
      end,
      function()
        return {
          exe = "golines",
          args = { "-w", "-m 120" },
        }
      end,
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    },
    templ = {
      function()
        return {
          exe = "templ fmt",
        }
      end
    },
  }
}
