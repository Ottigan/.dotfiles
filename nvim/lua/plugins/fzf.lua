return {
    "ibhagwan/fzf-lua",
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {
        defaults = {
            file_icons = "mini",
            copen = "Trouble qflist open",
            lopen = "Trouble loclist open",
        },
        ---@type fzf-lua.config.Colorschemes
        fzf_colors = {
            true, -- inherit fzf colors that aren't specified below from
            ["pointer"] = { "fg", "Exception" },
        },
        keymap = {
            builtin = {
                ["<C-u>"] = "preview-up",
                ["<C-d>"] = "preview-down",
            },
            fzf = {
                ["alt-s"] = "toggle",
                ["alt-a"] = "toggle-all",
            },
        },
        ui_select = {
            winopts = {
                height = 0.5,
                width = 0.5,
                preview = {
                    layout = "vertical",
                },
            },
        },
        files = {
            cwd_prompt = false,
            fzf_opts = {
                ["--multi"] = true,
                ["--scheme"] = "path",
                ["--exact"] = true,
            },
        },
    },
    ---@diagnostic enable: missing-fields
    config = function(_, opts)
        local fzf = require("fzf-lua")
        fzf.setup(opts)

        vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "[H]elp" })
        vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[K]eymaps" })
        vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[F]iles" })
        vim.keymap.set("n", "<leader>sq", fzf.lgrep_quickfix, { desc = "[Q]uickfix" })
        vim.keymap.set("n", "<leader>sb", fzf.builtin, { desc = "[B]uiltin" })
        vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[G]rep" })
        vim.keymap.set("n", "<leader>sd", fzf.diagnostics_workspace, { desc = "[D]iagnostics" })
        vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "[R]esume" })
        vim.keymap.set("n", "<leader>sc", fzf.commands, { desc = "[C]ommands" })
        vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "Buffers" })
        vim.keymap.set("n", "<leader>sv", fzf.nvim_options, { desc = "[V]im" })
        vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[W]ord" })
        vim.keymap.set("v", "<leader>sw", fzf.grep_visual, { desc = "[W]ord (visual)" })
        vim.keymap.set("n", "<leader>so", fzf.oldfiles, { desc = "[O]ld Files" })
        vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "Grep Buffer" })
    end,
}
