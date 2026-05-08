return { -- Collection of various small independent plugins/modules
    "nvim-mini/mini.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require("mini.ai").setup({ n_lines = 500 })

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sdn(   - [S]urround [D]elete [N]ext [(]paren
        -- - sr)'  - [S]urround [R]eplace [)] [']
        -- - srn({ - [S]urround [R]eplace [N]ext [(] with [{]brace
        require("mini.surround").setup()

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require("mini.statusline")
        -- set use_icons to true if you have a Nerd Font
        statusline.setup({ use_icons = vim.g.have_nerd_font })

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return "%2l:%-2v"
        end

        require("mini.files").setup({
            options = {
                use_as_default_explorer = false,
            },
            mappings = {
                show_help = "?",
                close = "q",
                go_in = "L",
                go_in_plus = "l",
                go_out = "h",
                go_out_plus = "H",
                mark_goto = "'",
                mark_set = "m",
                reset = "<BS>",
                reveal_cwd = "@",
                synchronize = "<cr>",
                trim_left = "<",
                trim_right = ">",
            },
            windows = {
                width_nofocus = 25,
                preview = false,
            },
        })

        vim.keymap.set("n", "<leader>e", function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local path = vim.fn.fnamemodify(bufname, ":p")

            -- Noop if the buffer isn't valid.
            if path and vim.uv.fs_stat(path) then
                require("mini.files").open(bufname, true)
            end
        end, { desc = "File explorer" })

        local show_dotfiles = true

        local filter_show = function()
            return true
        end

        local filter_hide = function(fs_entry)
            return not vim.startswith(fs_entry.name, ".")
        end

        local toggle_dotfiles = function()
            show_dotfiles = not show_dotfiles
            local new_filter = show_dotfiles and filter_show or filter_hide
            MiniFiles.refresh({ content = { filter = new_filter } })
        end

        local map_split = function(buf_id, lhs, direction, close_on_file)
            local rhs = function()
                local new_target_window
                local cur_target_window = require("mini.files").get_explorer_state().target_window
                if cur_target_window ~= nil then
                    vim.api.nvim_win_call(cur_target_window, function()
                        vim.cmd("belowright " .. direction .. " split")
                        new_target_window = vim.api.nvim_get_current_win()
                    end)

                    require("mini.files").set_target_window(new_target_window)
                    require("mini.files").go_in({ close_on_file = close_on_file })
                end
            end

            local desc = "Open in " .. direction .. " split"
            if close_on_file then
                desc = desc .. " and close"
            end
            vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
                local buf_id = args.data.buf_id

                vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })

                map_split(buf_id, "<C-w>s", "horizontal", true)
                map_split(buf_id, "<C-w>v", "vertical", true)
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(event)
                Snacks.rename.on_rename_file(event.data.from, event.data.to)
            end,
        })

        -- ... and there is more!
        --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
}
