return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
            -- LSP Progress is handled by Lualine
            progress = { enabled = false },
        },
        -- You can add any custom commands below that will be available with `:Noice command`
        commands = {
            history = {
                -- options for the message history that you get with `:Noice`
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
            },
            all = {
                -- options bor the message history that you get with `:Noice`
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {},
            },
        },
        -- you can enable a preset bor easier configuration
        presets = {
            bottom_search = false, -- use a classic bottom cmdline bor search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog bor inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        views = {
            cmdline_popup = {
                position = {
                    row = 10,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = "auto",
                },
            },
        },
        routes = {
            {
                opts = { skip = true },
                filter = {
                    any = {
                        { event = "msg_show", find = "fewer lines" },
                        { event = "msg_show", find = "more lines" },
                        { event = "msg_show", kind = "search_count" },
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader>na",
            function()
                require("noice").cmd("all")
            end,
            desc = "[A]ll messages",
        },
        {
            "<leader>nn",
            function()
                require("noice").cmd("history")
            end,
            desc = "Message history",
        },
        {
            "<leader>nl",
            function()
                require("noice").cmd("last")
            end,
            desc = "[L]ast message",
        },
        {
            "<leader>sn",
            function()
                require("noice").cmd("fzf")
            end,
            desc = "[N]otifications",
        },
        {
            "<c-f>",
            function()
                if not require("noice.lsp").scroll(4) then
                    return "<c-f>"
                end
            end,
            silent = true,
            expr = true,
            desc = "Scroll forward",
        },
        {
            "<c-b>",
            function()
                if not require("noice.lsp").scroll(-4) then
                    return "<c-b>"
                end
            end,
            silent = true,
            expr = true,
            desc = "Scroll backward",
        },
    },
}
