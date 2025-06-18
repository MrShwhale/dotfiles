require("bufferline").setup({})

-- Kitty scrollback
require("kitty-scrollback").setup()

-- Register helper
local peekup = require("nvim-peekup.config")
peekup.on_keystroke.paste_reg = "+"
peekup.on_keystroke.delay = "300ms"

-- Marks setup
require("marks").setup({
	-- whether to map keybinds or not. default true
	-- TODO actually bind this!!!
	default_mappings = false,
	-- which builtin marks to show. default {}
	builtin_marks = { ".", "<", ">", "^" },
	-- whether movements cycle back to the beginning/end of buffer. default true
	cyclic = true,
	-- whether the shada file is updated after modifying uppercase marks. default false
	force_write_shada = false,
	-- how often (in ms) to redraw signs/recompute mark positions.
	-- higher values will have better performance but may cause visual lag,
	-- while lower values may cause performance penalties. default 150.
	refresh_interval = 250,
	-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
	-- marks, and bookmarks.
	-- can be either a table with all/none of the keys, or a single number, in which case
	-- the priority applies to all marks.
	-- default 10.
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	-- disables mark tracking for specific filetypes. default {}
	excluded_filetypes = {},
	-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
	-- sign/virttext. Bookmarks can be used to group together positions and quickly move
	-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
	-- default virt_text is "".
	bookmark_0 = {
		sign = "⚑",
		virt_text = "Group 1",
		-- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
		-- defaults to false.
		annotate = false,
	},
	mappings = {},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_set_keymap(
	"n",
	"S",
	"<cmd>HopChar2<CR>",
	{ noremap = false, desc = "Jump to 2 character sequence", silent = true }
)

require("coq_3p")({
	{ src = "nvimlua", short_name = "nLUA" },
})

require("ts_context_commentstring").setup({
	enable_autocmd = false,
})

require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
