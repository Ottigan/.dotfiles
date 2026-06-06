-- Session management
-- https://github.com/folke/persistence.nvim

local uv = vim.uv or vim.loop

local function select_session()
    local persistence = require("persistence")
    local opts = require("persistence.config").options
    local items = {}
    local have = {}

    for _, session in ipairs(persistence.list()) do
        if uv.fs_stat(session) then
            local file = session:sub(#opts.dir + 1, -5)
            local parts = vim.split(file, "%%", { plain = true })
            local dir = (parts[1] or ""):gsub("%%", "/")
            local branch = parts[2]

            if not have[dir] then
                have[dir] = true
                items[#items + 1] = { session = session, dir = dir, branch = branch }
            end
        end
    end

    if #items == 0 then
        vim.notify("No sessions found", vim.log.levels.INFO, { title = "Persistence" })
        return
    end

    require("snacks.picker").select(items, {
        prompt = "Select a session: ",
        format_item = function(item)
            return vim.fn.fnamemodify(item.dir, ":p:~")
        end,
    }, function(item)
        if item then
            vim.fn.chdir(item.dir)
            persistence.load()
        end
    end)
end

return {
    "folke/persistence.nvim",
    event = "VimEnter",
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
        branch = true,
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

            if not first_arg then
                return select_session()
            end

            if vim.fn.isdirectory(first_arg) == 0 then
                persistence.stop()
                return
            end

            local dir = vim.fs.normalize(vim.fn.fnamemodify(first_arg, ":p")) or vim.fn.getcwd()
            vim.fn.chdir(dir)

            local session = persistence.current()

            if vim.fn.filereadable(session) == 1 then
                MiniFiles.close()
                persistence.load()
            end

            MiniFiles.open(dir, true)
        end)
    end,
    keys = {
        {
            "<leader>ql",
            function()
                select_session()
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
