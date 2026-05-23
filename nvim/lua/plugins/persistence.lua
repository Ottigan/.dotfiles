-- Session management
-- https://github.com/folke/persistence.nvim

return {
    "folke/persistence.nvim",
    event = "VimEnter",
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
        branch = false,
        need = 0,
    },
    config = function(_, opts)
        local group = vim.api.nvim_create_augroup("Persistence", { clear = true })
        local persistence = require("persistence")
        persistence.setup(opts)

        -- Clear initial directory buffer created by `nvim {dir}` before loading the session
        vim.api.nvim_create_autocmd("BufReadPre", {
            group = group,
            pattern = "*",
            once = true,
            callback = function()
                for _, id in ipairs(vim.api.nvim_list_bufs()) do
                    local bufname = vim.api.nvim_buf_get_name(id)

                    if vim.fn.isdirectory(bufname) == 1 then
                        vim.notify("Deleting buffer: " .. bufname, vim.log.levels.INFO, { title = "Persistence" })
                        vim.bo[id].buflisted = false
                        vim.api.nvim_buf_delete(id, { force = true })
                    end
                end
            end,
        })

        -- Clear buffers from previous session before loading a new one
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "PersistenceLoadPre",
            callback = function()
                vim.notify("Loading session...", vim.log.levels.INFO, { title = "Persistence" })
                persistence.start()

                for _, id in ipairs(vim.api.nvim_list_bufs()) do
                    vim.bo[id].buflisted = false
                    vim.api.nvim_buf_delete(id, { force = true })
                end
            end,
        })

        -- Fix a glitch creating broken directory buffer
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "PersistenceSavePre",
            callback = function()
                if vim.fn.argc() > 0 then
                    vim.cmd("silent! %argdelete")
                end
            end,
        })

        -- Handle following scenarios:
        -- 1. `nvim {dir}` - open a directory
        -- 2. `nvim {dir}/file` - open a file in a directory
        -- 3. `nvim` - open without arguments
        vim.schedule(function()
            local first_arg = vim.fn.argv()[1]

            -- Handle zellij restoring session passing {cwd}/. as argument
            if first_arg and vim.endswith(first_arg, "/.") then
                first_arg = "."
            end

            if vim.fn.isdirectory(first_arg) == 0 or not first_arg then
                persistence.stop()
                return
            end

            local dir = vim.fs.normalize(vim.fn.fnamemodify(first_arg, ":p")) or vim.fn.getcwd()
            vim.fn.chdir(dir)

            local session = persistence.current()

            if vim.fn.filereadable(session) == 1 then
                persistence.load()
            else
                require("mini.files").open(dir, true)
            end
        end)
    end,
    keys = {
        {
            "<leader>ql",
            function()
                require("persistence").select()
            end,
            desc = "[L]ist sessions",
        },
        {
            "<leader>qr",
            function()
                require("persistence").load()
            end,
            desc = "[R]estore session",
        },
        {
            "<leader>qs",
            function()
                require("persistence").save()
            end,
            desc = "Save [w]orkspace session",
        },
        {
            "<leader>qd",
            function()
                require("persistence").stop()
            end,
            desc = "[D]on't save on exit",
        },
    },
}
