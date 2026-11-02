-- ===================================================================
-- TITLE : pyright (Python Language Server) LSP Setup
-- ===================================================================

return function(capabilities)
	vim.lsp.config("pyright", {
		capabilities = capabilities,
		filetypes = { "python" },
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					
					-- PERFORMANCE FIX: Only analyze open files so Pyright doesn't freeze indexing large .venv paths
					diagnosticMode = "openFilesOnly",
					
					-- Balanced type checking without excessive noise
					typeCheckingMode = "basic", 
					
					-- VS Code-style Inlay Hints
					inlayHints = {
						variableTypes = true,
						functionReturnTypes = true,
						pytestParameters = true,
					},
				},
			},
		},
	})
end
