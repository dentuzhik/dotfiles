local github = function(repository)
    return "https://github.com/" .. repository
end

vim.pack.add({
    github("nvim-lua/plenary.nvim"),
    github("folke/tokyonight.nvim"),
    github("nvim-lualine/lualine.nvim"),
    github("lewis6991/gitsigns.nvim"),
    github("stevearc/oil.nvim"),
    github("nvim-telescope/telescope.nvim"),
    github("folke/which-key.nvim"),
    github("nvim-mini/mini.nvim"),
    github("neovim/nvim-lspconfig"),
}, { confirm = false })

require("tokyonight").setup({ style = "night" })
vim.cmd.colorscheme("tokyonight")

require("lualine").setup({ options = { theme = "tokyonight" } })
require("gitsigns").setup()
require("oil").setup({ default_file_explorer = true, view_options = { show_hidden = true } })
require("which-key").setup()
require("mini.pairs").setup()
require("mini.surround").setup()

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Search text" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Search help" })
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

vim.lsp.enable({ "lua_ls", "ts_ls", "eslint", "pyright" })
