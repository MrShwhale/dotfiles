-- KEYBINDS
-- General
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, desc = "Quick save", silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", ":nohl<CR>", { noremap = true, desc = "Remove highlights", silent = true })
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, desc = "Open tree", silent = true })

-- Editing
vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { noremap = false, silent = true })

-- Window-hopping
vim.api.nvim_set_keymap("n", "<C-h>", "<C-W>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-W>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-W>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-W>l", { noremap = true, silent = true })

-- Buffer interaction
vim.api.nvim_set_keymap("n", "<leader>bn", ":bnext<CR>", { noremap = true, desc = "Next buffer", silent = true })
vim.api.nvim_set_keymap("n", "<leader>bb", ":bprevious<CR>", { noremap = true, desc = "Last buffer", silent = true })
vim.api.nvim_set_keymap("n", "<leader>c", ":bdelete<CR>", { noremap = true, desc = "Close this buffer", silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>bj",
	":BufferLinePick<CR>",
	{ noremap = true, desc = "Close target buffer", silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>be",
	":BufferLinePickClose<CR>",
	{ noremap = true, desc = "Close target buffer", silent = true }
)

-- LSP THINGS
vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)

-- COQ
vim.api.nvim_set_keymap("i", "<Esc>", [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-c>", [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<BS>", [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap(
	"i",
	"<CR>",
	[[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
	{ expr = true, silent = true }
)
vim.api.nvim_set_keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true })
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
