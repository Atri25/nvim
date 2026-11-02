local M = {}

local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "",
	Info = "",
}

M.setup = function()
	vim.diagnostic.config({
		-- Gutter Signs (Gutter icons)
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
				[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
				[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
				[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
			},
		},

		-- VS Code-style Virtual Text (Inline error messages)
		virtual_text = {
			prefix = "●",
			spacing = 4,
			source = "if_many", -- Show server name (e.g., clangd) if multiple LSPs are active
		},

		-- Underline offending code
		underline = true,

		-- Prioritize Errors over Warnings/Hints in UI rendering
		severity_sort = true,

		-- Performance: Do NOT update diagnostics while typing (prevents typing stutter)
		update_in_insert = false,

		-- Floating Diagnostic Popups (Hover / Cursor diagnostics)
		float = {
			border = "rounded",
			focusable = false,
			style = "minimal",
			source = "always", -- Always display error source (e.g., [clangd])
			header = { "Diagnostics:", "Bold" },
			prefix = function(diagnostic)
				local sign = diagnostic_signs[vim.diagnostic.severity[diagnostic.severity]] or ""
				return sign .. " ", "DiagnosticSign" .. vim.diagnostic.severity[diagnostic.severity]
			end,
		},
	})
end

return M
