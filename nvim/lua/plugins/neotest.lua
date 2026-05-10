local uv = vim.uv

local jest_config_files = {
    "jest.config.ts",
    "jest.config.js",
    "jest.config.cjs",
    "jest.config.mjs",
}

local jest_lockfiles = {
    "pnpm-lock.yaml",
    "yarn.lock",
    "bun.lock",
}

local jest_commands = {
    ["pnpm-lock.yaml"] = "pnpm jest",
    ["yarn.lock"] = "yarn jest",
    ["bun.lock"] = "bun jest",
}

local function current_dir()
    local cwd = uv.cwd()
    if not cwd then
        error("Failed to determine current working directory for neotest-jest")
    end

    return vim.fs.normalize(cwd)
end

local function parent_dir(path)
    return vim.fs.normalize(vim.fs.dirname(path))
end

local function find_file_upward(names, start, stop)
    local dir = vim.fs.normalize(start)
    local root = vim.fs.normalize(stop)

    while dir do
        -- Check for the presence of any of the specified files in the current directory
        for _, name in ipairs(names) do
            local candidate = dir .. "/" .. name
            if uv.fs_stat(candidate) ~= nil then
                return candidate
            end
        end

        -- Stop if we've reached the root directory
        if dir == root then
            break
        end

        -- Move up to the parent directory
        dir = parent_dir(dir)
        if not dir then
            break
        end
    end

    return nil
end

local function jest_cmd(path)
    local root = current_dir()
    local start = parent_dir(path)
    local lockfile = find_file_upward(jest_lockfiles, start, root)

    if lockfile then
        return jest_commands[vim.fs.basename(lockfile)]
    end

    return "npx jest"
end

return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-jest",
        "nvim-neotest/neotest-go",
        "marilari88/neotest-vitest",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-go"),
                require("neotest-vitest"),
                require("neotest-jest")({
                    jestCommand = jest_cmd,
                    jest_test_discovery = true, -- Discover it.each
                    jestConfigFile = function(file)
                        local root = current_dir()
                        local start = parent_dir(file)
                        local config = find_file_upward(jest_config_files, start, root)

                        return config
                    end,
                    cwd = function()
                        return current_dir()
                    end,
                }),
            },
            status = { enabled = true, virtual_text = true, signs = true },
            output = { enabled = true, open_on_run = true },
            discovery = { concurrent = 0, enabled = false },
        })
    end,
    keys = {
        {
            "<leader>tn",
            function()
                require("neotest").run.run()
            end,
            desc = "[N]earest",
        },
        {
            "<leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "[F]ile",
        },
        {
            "<leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "[S]ummary",
        },
        {
            "<leader>to",
            function()
                require("neotest").output.open({ enter = true })
            end,
            desc = "[O]utput",
        },
        {
            "<leader>tp",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "[P]anel",
        },
        {
            "<leader>tl",
            function()
                require("neotest").run.run_last()
            end,
            desc = "[L]ast",
        },
        {
            "<leader>tw",
            function()
                require("neotest").run.run({ jestCommand = jest_cmd() .. " --watch" })
            end,
            desc = "[W]atch",
        },
        {
            "<leader>td",
            function()
                require("neotest").run.run({ strategy = "dap" })
            end,
            desc = "[D]ebug nearest",
        },
    },
}
