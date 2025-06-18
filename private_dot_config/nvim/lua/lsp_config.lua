local coq = require("coq")

-- Python
vim.lsp.config("pyright", coq.lsp_ensure_capabilities())
vim.lsp.enable("pyright")

-- Lua
vim.lsp.config["lua_ls"] = {
	settings = {
		Lua = {
			workspace = {
				library = {
					["/usr/share/nvim/runtime/lua"] = true,
					["/usr/share/nvim/runtime/lua/lsp"] = true,
					["/usr/share/awesome/lib"] = true,
				},
			},

			diagnostics = {
				enable = true,
				globals = {
					-- neovim
					"vim",
					-- awesomewm
					"awesome",
					"client",
					"root",
					"screen",
				},
			},
		},
	},
}

vim.lsp.config("lua_ls", coq.lsp_ensure_capabilities())
vim.lsp.enable("lua_ls")
