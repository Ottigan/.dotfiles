return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                -- LSP Progress is handled by Lualine
                progress = {
                    enabled = false,
                },
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
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        keys = {
            {
                "<leader>na",
                function()
                    require("noice").cmd("all")
                end,
                desc = "All Messages",
            },
            {
                "<leader>nn",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Message History",
            },
            {
                "<leader>nl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Last Message",
            },
            {
                "<leader>sn",
                function()
                    require("noice").cmd("fzf")
                end,
                desc = "Search Messages",
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
                desc = "Scroll borward",
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
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
            },
            sections = {
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- Displays file status (readonly status, modified status)
                        newfile_status = false, -- Display new file status (new file means no write after created)

                        -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                        -- 4: Filename and parent dir, with tilde as the home directory
                        path = 1,

                        -- Shortens path to leave 40 spaces in the window
                        -- for other components. (terrible name, any suggestions?)
                        -- It can also be a function that returns
                        -- the value of `shorting_target` dynamically.
                        shorting_target = 40,
                        symbols = {
                            modified = "[+]", -- Text to show when the file is modified.
                            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                            unnamed = "[No Name]", -- Text to show for unnamed buffers.
                            newfile = "[New]", -- Text to show for newly created file before first write
                        },
                    },
                },
                lualine_x = {
                    {
                        function()
                            ---@type string|nil
                            local mode = require("noice").api.status.mode.get()

                            -- Skip status such as -- INSERT --, etc
                            if not mode or mode:sub(1, 2) == "--" then
                                return ""
                            end

                            return mode
                        end,
                        cond = require("noice").api.status.mode.has,
                        color = { fg = "#ff9e64" },
                    },
                },
                lualine_y = { "searchcount", "lsp_status", "filetype", "progress" },
            },
        },
    },
}
