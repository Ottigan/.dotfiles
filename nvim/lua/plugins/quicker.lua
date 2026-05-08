-- Improved quickfix UI.
return {
    "stevearc/quicker.nvim",
    event = "VeryLazy",
    opts = {
        -- Open the quickfix list when there are diagnostics.
        open = {
            diagnostics = true,
        },
    },
    keys = {
        {
            "<leader>xq",
            function()
                local quicker = require("quicker")

                if quicker.is_open() then
                    quicker.close()
                else
                    vim.diagnostic.setqflist()
                end
            end,
            desc = "Toggle diagnostic quickfix",
        },
        {
            "<leader>xl",
            function()
                local quicker = require("quicker")

                if quicker.is_open() then
                    quicker.close()
                else
                    vim.diagnostic.setloclist()
                end
            end,
            desc = "Toggle diagnostic loclist",
        },
        {
            "<leader>lq",
            function()
                local quicker = require("quicker")
                quicker.toggle()
            end,
            desc = "Toggle quickfix",
        },
        {
            "<leader>ll",
            function()
                local quicker = require("quicker")
                quicker.toggle({ loclist = true })

            end,
            desc = "Toggle loclist",
        },
    },
}
