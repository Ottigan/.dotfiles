return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mason-org/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "leoluz/nvim-dap-go",
        -- Inline variable values as virtual text while stepping
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                highlight_changed_variables = true,
                highlight_new_as_changed = true,
                show_stop_reason = true,
                virt_text_pos = "eol",
            },
        },
    },
    config = function()
        local dap = require("dap")

        require("mason-nvim-dap").setup({
            automatic_installation = true,
            handlers = {},
            ensure_installed = {
                "delve",
                "js-debug-adapter",
            },
        })

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "::1",
            port = "${port}",
            executable = {
                command = "js-debug-adapter",
                args = {
                    "${port}",
                },
            },
        }

        -- ── Go ────────────────────────────────────────────────────────────────
        require("dap-go").setup()

        -- ── DAP UI ────────────────────────────────────────────────────────────
        local dapui = require("dapui")
        dapui.setup()

        -- Change breakpoint icons
        vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
        vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
        local breakpoint_icons = {
            Breakpoint = "●",
            BreakpointCondition = "⊜",
            BreakpointRejected = "⊘",
            LogPoint = "◆",
            Stopped = "⭔",
        }

        for type, icon in pairs(breakpoint_icons) do
            local tp = "Dap" .. type
            local hl = (type == "Stopped") and "DapStop" or "DapBreak"
            vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        end

        dap.listeners.before.attach.dapui_config = function()
            vim.schedule(dapui.open)
        end
        dap.listeners.before.launch.dapui_config = function()
            vim.schedule(dapui.open)
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        local widgets = require("dap.ui.widgets")

        vim.keymap.set("n", "<F1>", dap.continue, { desc = "[C]ontinue" })
        vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step into" })
        vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step over" })
        vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step out" })
        vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Step back" })
        vim.keymap.set("n", "<F6>", dap.restart, { desc = "Restart" })
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Toggle UI" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle [b]reakpoint" })
        vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Set conditional [B]reakpoint" })
        vim.keymap.set("n", "<leader>dh", widgets.hover, { desc = "[H]over value" })
        vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run [l]ast" })
        vim.keymap.set("n", "<leader>de", function()
            widgets.centered_float(widgets.expression)
        end, { desc = "[E]valuate expression" })
        vim.keymap.set("n", "<Leader>df", function()
            widgets.centered_float(widgets.frames)
        end, { desc = "Stack [f]rames" })
        vim.keymap.set("n", "<leader>ds", function()
            widgets.centered_float(widgets.scopes)
        end, { desc = "[S]copes" })
        vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "[T]erminate" })
    end,
}
