local M = {}

local SUMMARY_FILETYPE = "neotest-summary"

local function is_valid_buffer(bufnr)
    return type(bufnr) == "number" and bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr)
end

local function is_summary_buffer(bufnr)
    return is_valid_buffer(bufnr) and vim.bo[bufnr].filetype == SUMMARY_FILETYPE
end

local function is_normal_buffer(bufnr)
    return is_valid_buffer(bufnr)
        and vim.bo[bufnr].buflisted
        and vim.bo[bufnr].buftype == ""
        and not is_summary_buffer(bufnr)
end

local function regular_buffers()
    local buffers = {}

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if is_normal_buffer(bufnr) then
            buffers[#buffers + 1] = bufnr
        end
    end

    table.sort(buffers)

    return buffers
end

local function find_replacement(target)
    local buffers = regular_buffers()
    for index, bufnr in ipairs(buffers) do
        if bufnr == target then
            return buffers[index + 1] or buffers[index - 1]
        end
    end

    local alternate = vim.fn.bufnr("#")
    if alternate ~= target and is_normal_buffer(alternate) then
        return alternate
    end

    return buffers[1]
end

function M.delete(bufnr, opts)
    opts = opts or { force = false }

    local target = bufnr or vim.api.nvim_get_current_buf()
    if not is_valid_buffer(target) then
        return
    end

    if is_summary_buffer(target) then
        require("neotest").summary.close()
        return
    end

    local replacement = find_replacement(target)
    local windows = vim.fn.win_findbuf(target)

    if #windows > 0 and (not replacement or replacement == target) then
        replacement = vim.api.nvim_create_buf(true, false)
    end

    if replacement and replacement ~= target then
        for _, win in ipairs(windows) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == target then
                vim.api.nvim_win_set_buf(win, replacement)
            end
        end
    end

    vim.api.nvim_buf_delete(target, opts)
end

return M
