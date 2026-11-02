-- ===================================================================
-- TITLE : gopls (Go Language Server) LSP Setup
-- ===================================================================

return function(capabilities)
	vim.lsp.config("gopls", {
		capabilities = capabilities,
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		settings = {
			gopls = {
				-- Static analysis rules like VS Code / GoLand
				analyses = {
					unusedparams = true,
					unusedwrite = true,
					shadow = true,
					nilness = true,
					useany = true,
				},
				staticcheck = true,
				gofumpt = true, -- Strict Go formatting rules
				usePlaceholders = true, -- Auto fill arguments when completing function calls
				completeUnimported = true, -- Auto import missing packages on completion

				-- Exclude large non-code directories from indexing
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },

				-- VS Code-style Inlay Hints
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	})
end
