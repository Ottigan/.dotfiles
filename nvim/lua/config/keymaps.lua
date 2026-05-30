-- Misc
vim.keymap.set("n", "'", "`", { desc = "Use backticks for jumping to marks" })

-- Better J behavior
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Emacs-style command-line navigation
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Start of line" })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("c", "<C-b>", "<Left>", { desc = "Back one character" })
vim.keymap.set("c", "<C-f>", "<Right>", { desc = "Forward one character" })
vim.keymap.set("c", "<C-d>", "<Del>", { desc = "Delete character under cursor" })
vim.keymap.set("c", "<C-n>", "<Down>", { desc = "Recall newer command-line" })
vim.keymap.set("c", "<C-p>", "<Up>", { desc = "Recall previous (older) command-line" })

-- Save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })

-- Quit
vim.keymap.set("n", "<leader>qq", "<cmd>quit<cr>", { desc = "[Q]uit window" })
vim.keymap.set("n", "<leader>qa", "<cmd>qall<cr>", { desc = "Quit [a]ll" })
vim.keymap.set("n", "<leader>qA", "<cmd>qall!<cr>", { desc = "Quit [a]ll (force)" })

-- Buffer management
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Alternate [b]uffer" })
vim.keymap.set("n", "<leader>bd", require("config.buffers").delete, { desc = "[d]elete" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Delete others" })
vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete left" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete right" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "}", "}zz", { desc = "Next paragraph (centered)" })
vim.keymap.set("n", "{", "{zz", { desc = "Previous paragraph (centered)" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines up/down
local function position_before(a, b)
    return a[2] < b[2] or (a[2] == b[2] and a[3] <= b[3])
end

local function move_visual_selection(delta)
    local anchor = vim.fn.getpos("v")
    local cursor = vim.fn.getcurpos()
    local start_pos, end_pos = anchor, cursor

    if not position_before(start_pos, end_pos) then
        start_pos, end_pos = end_pos, start_pos
    end

    local start_line = start_pos[2]
    local end_line = end_pos[2]
    local destination = delta > 0 and end_line + delta or start_line + delta - 1
    vim.cmd(string.format("%d,%dmove %d", start_line, end_line, destination))

    start_pos[2] = start_pos[2] + delta
    end_pos[2] = end_pos[2] + delta
    vim.fn.setpos("'<", start_pos)
    vim.fn.setpos("'>", end_pos)
    vim.cmd.normal({ args = { "gv=gv" }, bang = true })
end

vim.keymap.set("n", "<S-C-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("n", "<S-C-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("x", "<S-C-k>", function()
    move_visual_selection(-1)
end, { desc = "Move selection up" })
vim.keymap.set("x", "<S-C-j>", function()
    move_visual_selection(1)
end, { desc = "Move selection down" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("n", "<", "<cmd> < <cr>", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })
vim.keymap.set("n", ">", "<cmd> > <cr>", { desc = "Indent right" })

-- Diagnostic
local diagnostic_goto = function(next, severity)
    return function()
        vim.diagnostic.jump({
            count = (next and 1 or -1) * vim.v.count1,
            severity = severity and vim.diagnostic.severity[severity] or nil,
            float = true,
        })
    end
end

vim.keymap.set("n", "<leader>xh", vim.diagnostic.open_float, { desc = "Hover diagnostic" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev warning" })

-- Copy
vim.keymap.set("n", "<leader>cr", function()
    vim.fn.setreg("+", vim.fn.fnamemodify(vim.fn.expand("%:p"), ":."))
end, { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>ca", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy absolute path" })

vim.keymap.set("n", "<leader>cf", function()
    vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy filename" })

vim.keymap.set("n", "<leader>cd", function()
    vim.fn.setreg("+", vim.fn.expand("%:p:h"))
end, { desc = "Copy directory path" })

vim.keymap.set("n", "<leader>cl", function()
    local file = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
    local line = vim.fn.line(".")
    vim.fn.setreg("+", file .. ":" .. line)
end, { desc = "Copy path:line" })

-- Clear highlights on search and close floating windows when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", function()
    vim.cmd("Noice dismiss")
    vim.cmd("nohlsearch")

    local curr = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(curr).relative ~= "" then
        vim.api.nvim_win_close(curr, false)
    end
end)

-- Custom open to handle file paths including port
vim.keymap.set("n", "gx", function()
    local line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1

    for i = cursor_col, 1, -1 do
        local char = line:sub(i, i)
        if char:match("%s") then
            cursor_col = i
            break
        end
    end

    vim.ui.open(line:sub(cursor_col):match("%S+"))
end, { desc = "Open file/URL under cursor" })
