vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- UI Plugins
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	use({
		"akinsho/bufferline.nvim",
		requires = "nvim-tree/nvim-web-devicons",
	})

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.x",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({ "rose-pine/neovim", as = "rose-pine" })

	use({
		"nvim-treesitter/nvim-treesitter",
	})

	-- LSP (Language Server Protocol)
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
	})

	use("theprimeagen/harpoon")
	use("theprimeagen/vim-be-good")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use("stevearc/conform.nvim") -- Formatter
	use("mfussenegger/nvim-lint") -- Linter
	use("folke/which-key.nvim")

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- A dependency for file icons
			"MunifTanjim/nui.nvim",
		},
	})
end)
