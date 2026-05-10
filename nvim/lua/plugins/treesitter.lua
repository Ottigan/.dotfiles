return {
    "nvim-treesitter/nvim-treesitter",
    build = "<cmd>TSUpdate",
    lazy = false,
    config = function()
        local languages = {
            "lua",
            "javascript",
            "typescript",
            "tsx",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "templ",
            "html",
            "css",
            "scss",
            "json",
            "yaml",
            "markdown",
            "markdown_inline",
            "bash",
            "rust",
        }

        require("nvim-treesitter").install(languages)

        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- folds
        vim.opt.foldmethod = "expr"
        vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
        vim.opt.foldlevelstart = 99 -- Start with all folds open

        vim.api.nvim_create_autocmd("FileType", {
            pattern = languages,
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
