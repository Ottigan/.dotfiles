-- Pretty bufferline.
return {
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            -- Buffer navigation.
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
            { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick a buffer to open" },
            { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Select a buffer to close" },
        },
        config = function()
            local bufferline = require("bufferline")
            local constants = require("bufferline.constants")
            constants.sep_chars["thin"] = { "｜", "｜" }

            bufferline.setup({
                highlights = {},
                options = {
                    style_preset = bufferline.style_preset.no_italic,
                    separator_style = "thin",
                    indicator = { style = "underline" },
                    show_tab_indicators = false,
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    custom_filter = function(buf)
                        return vim.bo[buf].buftype ~= "terminal"
                    end,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and MiniIcons.get("lsp", "error")
                            or MiniIcons.get("lsp", "warn")
                        return " " .. icon .. count
                    end,
                },
            })
        end,
    },
}
