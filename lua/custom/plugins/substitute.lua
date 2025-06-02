-- substitute.nvim
-- https://github.com/gbprod/substitute.nvim

return {
	"gbprod/substitute.nvim",
	event = "VeryLazy", -- Load when needed
	config = function()
		local substitute = require("substitute")

		-- Setup the plugin
		substitute.setup({
			-- You can add configuration options here if needed
			-- See the repository documentation for available options
		})

		-- Setup keymaps
		vim.keymap.set("n", "gs", substitute.operator, { noremap = true, desc = "Substitute operator" })
		vim.keymap.set("n", "gss", substitute.line, { noremap = true, desc = "Substitute line" })
		vim.keymap.set("n", "gS", substitute.eol, { noremap = true, desc = "Substitute to end of line" })
		vim.keymap.set("x", "gs", substitute.visual, { noremap = true, desc = "Substitute visual selection" })

		-- Exchange functionality
		local exchange = require("substitute.exchange")
		vim.keymap.set("n", "cx", exchange.operator, { noremap = true, desc = "Exchange operator" })
		vim.keymap.set("n", "cxx", exchange.line, { noremap = true, desc = "Exchange line" })
		vim.keymap.set("x", "X", exchange.visual, { noremap = true, desc = "Exchange visual selection" })
		vim.keymap.set("n", "cxc", exchange.cancel, { noremap = true, desc = "Exchange cancel" })
	end,
}
