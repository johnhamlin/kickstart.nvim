return {
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins
		config = function()
			-- Configure the theme
			require("monokai-pro").setup({
				-- You can customize the theme here
				-- Using 'spectrum' filter as requested
				filter = "spectrum",
				-- You can also customize other options
				-- background_clear = {}, -- specify UI elements to have transparent bg
				-- devicons = true, -- highlight devicons
				-- styles = {
				--   comment = { italic = true },
				--   keyword = { italic = true }, -- any other token style
				-- },
				-- plugins = {
				--   -- Options: true uses default settings, false disables plugin highlighting
				--   -- You can also specify options for a plugin as a table
				--   bufferline = true,
				--   telescope = true,
				--   -- etc.
				-- },
			})

			-- Set the colorscheme
			-- vim.cmd.colorscheme 'monokai-pro-spectrum'
		end,
	},
	-- This from kickstarter, but I moved it here for modularity
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("tokyonight").setup({
				styles = {
					comments = { italic = false }, -- Disable italics in comments
				},
			})

			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
}
