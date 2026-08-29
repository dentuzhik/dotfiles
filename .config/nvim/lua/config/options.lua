local opt = vim.opt

opt.backup = false
opt.clipboard = "unnamedplus"
opt.colorcolumn = "120"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.ignorecase = true
opt.incsearch = true
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", nbsp = "_" }
opt.modeline = false
opt.mouse = "a"
opt.number = true
opt.scrolloff = 5
opt.shiftwidth = 4
opt.showmode = false
opt.sidescrolloff = 5
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 4
opt.termguicolors = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undofile = true
opt.updatetime = 250
opt.wrap = false

vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")
