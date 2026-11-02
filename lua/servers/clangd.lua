-- ===================================================================
-- TITLE : clangd (C/C++ Language Server) LSP Setup
-- ===================================================================

return function(capabilities)
	vim.lsp.config("clangd", {
		capabilities = capabilities,
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
			"--background-index", -- Index codebase in background for fast symbol search
			"--clang-tidy", -- Enable real-time linting and quick fixes
			"--header-insertion=never", -- STOP adding #include <vector> when using bits/stdc++.h
			"--completion-style=detailed", -- Show full method signatures in popups like VS Code
			"--function-arg-placeholders", -- Auto-fill argument placeholders when completing functions
			"--pch-storage=memory", -- Keep precompiled headers in RAM for instant compilation checks
			"-j=8", -- Leverage 8 background threads on your Intel 14th Gen HX CPU
		},
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true,
		},
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	})
end
