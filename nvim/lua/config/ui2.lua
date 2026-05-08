local M = {}

function M.setup()
    -- Enable Neovim's native ui2 system
    -- Note: This requires Neovim >= 0.12
    local success, ui2 = pcall(require, "vim._core.ui2")
    if success then
        ui2.enable({
            enable = true, -- Whether to enable or disable the UI.
            msg = { -- Options related to the message module.
                ---@type 'cmd'|'msg' Default message target, either in the
                ---cmdline or in a separate ephemeral message window.
                ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
                ---or table mapping |ui-messages| kinds and triggers to a target.
                targets = "cmd",
                cmd = { -- Options related to messages in the cmdline window.
                    height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
                },
                dialog = { -- Options related to dialog window.
                    height = 0.5, -- Maximum height.
                },
                msg = { -- Options related to msg window.
                    height = 0.5, -- Maximum height.
                    timeout = 4000, -- Time a message is visible in the message window.
                },
                pager = { -- Options related to message window.
                    height = 1, -- Maximum height.
                },
            },
        })
        vim.opt.cmdheight = 0 -- Recommended for ui2
        vim.notify("ui2 initialized", vim.log.levels.INFO, { title = "ui2" })
    else
        vim.notify("ui2 not available (Neovim 0.12+ required)", vim.log.levels.WARN)
    end
end

return M
