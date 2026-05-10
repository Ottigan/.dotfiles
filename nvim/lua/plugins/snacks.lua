local function source_js_or_ts(self)
    local namespace = vim.api.nvim_create_namespace("node_result")
    vim.api.nvim_buf_clear_namespace(self.buf, namespace, 0, -1)

    -- Inject script that makes console log output line numbers.
    local script = [[
        'use strict';

        const path = require('path');

        const originalLog = console.log;
        console.log = (first, ...rest) => {
            const originalPrepareStackTrace = Error.prepareStackTrace;
            Error.prepareStackTrace = (_, stack) => stack;
            const callee = new Error().stack[1];
            Error.prepareStackTrace = originalPrepareStackTrace;

            const relativeFileName = path.relative(process.cwd(), callee.getFileName());
            const prefix = `${relativeFileName}:${callee.getLineNumber()}:`;

            if (typeof first === 'string') {
                originalLog(prefix + ' ' + first, ...rest);
            } else {
                originalLog(prefix, first, ...rest);
            }
        };
    ]]

    for _, line in pairs(vim.api.nvim_buf_get_lines(self.buf, 0, -1, true)) do
        script = script .. line .. "\n"
    end

    local result = vim.system({ "node", "-e", script }, { text = true }):wait()

    if result.code ~= 0 then
        error(result.stderr)
    end

    local lines = vim.split(result.stdout or "", "\n", { trimempty = true })

    for _, line in pairs(lines) do
        local line_number, output = line:match("%[eval%]:(%d+): (.*)")
        -- Subtract the lines of the injected script.
        vim.api.nvim_buf_set_extmark(0, namespace, line_number - 21, 0, {
            virt_text = { { output, "Comment" } },
        })
    end
end

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        image = { enabled = true },
        quickfile = { enabled = true },
        lazygit = {
            -- automatically configure lazygit to use the current colorscheme
            -- and integrate edit with the current neovim instance
            configure = true,
            -- extra configuration for lazygit that will be merged with the default
            -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
            -- you need to double quote it: `"\"test\""`
            config = {
                os = { editPreset = "nvim-remote" },
            },
            theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
        },
        scratch = {
            win_by_ft = {
                javascript = {
                    keys = {
                        ["source"] = {
                            "<cr>",
                            source_js_or_ts,
                            desc = "Source buffer",
                            mode = { "n", "x" },
                        },
                    },
                },
                typescript = {
                    keys = {
                        ["source"] = {
                            "<cr>",
                            source_js_or_ts,
                            desc = "Source buffer",
                            mode = { "n", "x" },
                        },
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle scratch buffer",
        },
        {
            "<leader>ss",
            function()
                Snacks.scratch.select()
            end,
            desc = "[S]elect [s]cratch buffer",
        },
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },
        {
            "<leader>gl",
            function()
                Snacks.lazygit.log()
            end,
            desc = "Lazygit [l]og",
        },
        {
            "<leader>gf",
            function()
                Snacks.lazygit.log_file()
            end,
            desc = "Lazygit log [f]ile",
        },
    },
}
