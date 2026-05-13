return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = { "n", "v" },
            desc = "[F]ormat buffer",
        },
        {
            "<leader>F",
            function()
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                vim.notify(
                    "Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"),
                    vim.log.levels.INFO
                )
            end,
            desc = "Toggle [F]ormat on Save",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            scss = { "stylelint" },
            yaml = { "prettierd" },
            toml = { "taplo" },
            lua = { "stylua" },
            zsh = { "shfmt" },
        },
        format_on_save = function()
            if vim.g.disable_autoformat then
                return
            end
            return { timeout_ms = 2000, lsp_format = "fallback" }
        end,
    },
}
