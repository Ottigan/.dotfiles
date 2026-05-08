local set = vim.opt

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
set.number = true -- Line numbers
set.relativenumber = true -- Relative line numbers
set.cursorline = true -- Highlight the current line
set.wrap = false -- Don't wrap lines
set.scrolloff = 10 -- Keep 10 lines above/below cursor
set.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
set.sessionoptions:remove("terminal") -- Don't store terminal buffers in sessions

-- Folding settings
set.foldmethod = "expr" -- Use expression for folding
set.foldexpr = "nvim_treesitter#foldexpr()" -- Use Treesitter
set.foldlevelstart = 99 -- Start with all folds open

-- Indentation
set.tabstop = 2 -- Tab width
set.shiftwidth = 2 -- Indent width
set.softtabstop = 2 -- Soft tab stop
set.expandtab = true -- Use spaces instead of tabs
set.smartindent = true -- Smart auto-indenting
set.autoindent = true -- Copy indent from current line
set.breakindent = true -- Wrapped lines will be indented

-- Search settings
set.ignorecase = true -- Case-insensitive search
set.smartcase = true -- Case-sensitive if uppercase letters are used
set.hlsearch = false -- Highlight search results
set.incsearch = true -- Show search matches as you type

-- Visual settings
set.termguicolors = true -- Enable 24-bit colors
set.signcolumn = "yes" -- Always show the sign column
set.winborder = "rounded" -- Rounded float borders
vim.g.have_nerd_font = true -- Assume Nerd Font is available for icons
set.showmatch = true -- Highlight matching brackets
set.matchtime = 2 -- How long to show match
set.cmdheight = 1 -- Command line height
set.completeopt = "menuone,noselect" -- Completion options
vim.showmode = false -- Don't show -- INSERT -- etc.
set.pumheight = 10 -- Popup menu height
set.pumblend = 10 -- Popup transparency
set.winblend = 0 -- Floating window transparency
set.list = true -- Show whitespace characters
set.listchars = { tab = "→ ", trail = ".", lead = " ", nbsp = "␣" }
set.conceallevel = 0 -- Don't hide markup
set.concealcursor = "" -- Don't hide markup in cursor line
set.synmaxcol = 300 -- Don't syntax highlight long lines
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25"

-- File handling
set.backup = false -- Don't create backup files
set.writebackup = false -- Don't create backup files while writing
set.swapfile = false -- Don't create swap files
set.undofile = true -- Enable persistent undo
set.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
set.updatetime = 300 -- Faster completion
set.timeoutlen = 500 -- Faster key sequence timeout
set.ttimeoutlen = 0 -- Don't wait for key codes
set.autoread = true -- Auto-reload files changed outside of Vim
set.autowrite = false -- Don't auto-save files

-- Behaviour settings
set.hidden = true -- Allow hidden buffers
set.errorbells = false -- Disable error bells
set.backspace = "indent,eol,start" -- Backspace behavior
set.autochdir = false -- Don't change working directory automatically
set.selection = "inclusive" -- Selection behavior required for snippet placeholders
set.mouse = "a" -- Enable mouse support
set.clipboard:append("unnamedplus") -- Use system clipboard
set.modifiable = true -- Allow modifying buffers
set.encoding = "utf-8" -- Set encoding
set.confirm = true -- Confirm before exiting with unsaved changes
set.inccommand = "split" -- Show live preview of substitutions

-- Split behavior
set.splitbelow = true -- Horizontal splits go below
set.splitright = true -- Vertical splits go right

-- Disable netrw (use Neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
