-- ================================================================================================
-- TITLE : nvim-lspconfig
-- ABOUT : Quickstart configurations for the built-in Neovim LSP client.
-- ================================================================================================

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim", -- Bridges mason.nvim with lspconfig
		"creativenull/efmls-configs-nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- 1. Initialize diagnostic signs, virtual text, and floating popups
		require("utils.diagnostics").setup()

		-- 2. Register global LspAttach autocommand to run utils.lsp on every active LSP buffer
		local lsp_utils = require("utils.lsp")
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(event)
				lsp_utils.on_attach(event)
			end,
		})

		-- 3. Broadcast completion capabilities from cmp_nvim_lsp to servers
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 4. Automatically install & manage required language servers via Mason
		require("mason-lspconfig").setup({
			ensure_installed = { "clangd", "gopls", "pyright" },
			automatic_installation = true,
		})

		-- 5. Load all LSP server configs from the lua/servers/ directory
		local servers = require("servers")
		if type(servers) == "function" then
			servers(capabilities)
		end
	end,
}
