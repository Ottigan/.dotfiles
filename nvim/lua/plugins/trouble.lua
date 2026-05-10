return {
    "folke/trouble.nvim",
    opts = {
        focus = true,
    },
    cmd = "Trouble",
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>lq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Toggle quickfix",
        },
        {
            "<leader>ll",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Toggle loclist",
        },
    },
}
