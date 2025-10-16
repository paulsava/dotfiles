-- in after/plugin/neotree.lua

require("neo-tree").setup({
	-- This tells neo-tree to take over for netrw
	hijack_netrw = true,

	window = {
		-- Your setting to open on the right
		position = "right",
		width = 40,
	},

	filesystem = {
		-- Other filesystem settings can go here
	},

	-- Add any other settings you have...
})
