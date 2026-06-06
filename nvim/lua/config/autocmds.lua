local augroup = vim.api.nvim_create_augroup("Config", { clear = true })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        local line = mark[1]
        local ft = vim.bo.filetype

        if
            line > 0
            and line <= lcount
            and vim.fn.index({ "commit", "gitrebase", "xxd" }, ft) == -1
            and not vim.o.diff
        then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Automatically close buffers that no longer exist on disk
vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitUpdated",
    callback = function()
        local buffers = require("config.buffers")

        -- Check if a branch change actually occurred
        local new_branch = vim.b.minigit_summary
        if new_branch and new_branch.head_name == vim.g.last_known_branch then
            return
        end

        vim.g.last_known_branch = new_branch.head_name

        for _, bufnr in ipairs(buffers.list()) do
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local path = vim.fn.fnamemodify(bufname, ":p")

            -- Delete buffer if it no longer exists on disk (e.g. due to git checkout)
            if not path or not vim.uv.fs_stat(path) then
                buffers.delete(bufnr)
            end
        end
    end,
})
