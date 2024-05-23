return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "typescript-language-server",
                "prettier",

                "gopls",
                "golangci-lint",
                "golangci-lint-langserver",
                "golines",
                "goimports-reviser",

                "rust-analyzer",

                "html-lsp",
                "htmx-lsp",
                "tailwindcss-language-server",

                "lua-language-server",
            },
        },
    },
}
