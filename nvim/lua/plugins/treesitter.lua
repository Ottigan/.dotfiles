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

        vim.opt.foldlevelstart = 99 -- Start with all folds open

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterFolds", { clear = true }),
            pattern = languages,
            callback = function()
                vim.treesitter.start()
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
