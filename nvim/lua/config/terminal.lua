local terminal_state = {
    buf = nil,
    win = nil,
    is_open = false,
    autocmd_id = nil,
}

local function Terminal()
    -- If terminal is already open, close it (toggle behavior)
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
        return
    end

    -- Create buffer if it doesn't exist or is invalid
    if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
        terminal_state.buf = vim.api.nvim_create_buf(false, true)
        -- Set buffer options for better terminal experience
        vim.bo[terminal_state.buf].bufhidden = "hide"
    end

    -- Calculate window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor(vim.o.lines * 0.1)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the floating window
    terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    -- Start terminal if not already running
    if vim.bo[terminal_state.buf].buftype ~= "terminal" then
        vim.cmd("terminal")
    end

    terminal_state.is_open = true
    vim.cmd("startinsert")

    -- Clear any previous BufLeave autocmd before registering a new one
    if terminal_state.autocmd_id then
        pcall(vim.api.nvim_del_autocmd, terminal_state.autocmd_id)
    end

    terminal_state.autocmd_id = vim.api.nvim_create_autocmd("BufLeave", {
        buffer = terminal_state.buf,
        callback = function()
            if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                vim.api.nvim_win_close(terminal_state.win, false)
                terminal_state.is_open = false
            end
            terminal_state.autocmd_id = nil
        end,
        once = true,
    })
end

-- Key mappings
vim.keymap.set("n", "<leader>`", Terminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("n", "<leader>§", Terminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
    vim.cmd("stopinsert")
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })
