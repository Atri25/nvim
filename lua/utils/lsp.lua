local M = {}

-- ===================================================================
-- Global Diagnostic Options (VS Code style UI)
-- ===================================================================

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false, -- Don't recalculate diagnostics while typing (saves CPU cycles)
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

-- ===================================================================
-- Helpers (Module Scope)
-- ===================================================================

local function organize_imports_and_format(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf.code_action({
		context = { only = { "source.organizeImports" }, diagnostics = {} },
		apply = true,
		bufnr = bufnr,
	})

	vim.lsp.buf.format({ bufnr = bufnr, async = true })
end

local function sync_organize_imports_and_format(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
	if #clients == 0 then
		vim.lsp.buf.format({ bufnr = bufnr, async = false })
		return
	end

	for _, client in ipairs(clients) do
		local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
		params.context = { only = { "source.organizeImports" }, diagnostics = {} }

		local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
		if result then
			for _, res in pairs(result) do
				for _, r in ipairs(res.result or {}) do
					if r.edit then
						vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
					elseif r.command then
						vim.lsp.buf.execute_command(r.command)
					end
				end
			end
		end
	end

	vim.lsp.buf.format({ bufnr = bufnr, async = false })
end

local function whole_file_code_actions(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local last_line = vim.api.nvim_buf_line_count(bufnr)

	vim.lsp.buf.code_action({
		range = {
			start = { 0, 0 },
			["end"] = { last_line, 0 },
		},
		bufnr = bufnr,
	})
end

M.organize_imports_and_format = organize_imports_and_format
M.sync_organize_imports_and_format = sync_organize_imports_and_format
M.whole_file_code_actions = whole_file_code_actions

-- ===================================================================
-- Main On-Attach Callback
-- ===================================================================

M.on_attach = function(event)
	if not event.data then
		return
	end

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if not client then
		return
	end

	local bufnr = event.buf
	local keymap = vim.keymap.set
	local opts = { silent = true, buffer = bufnr }

	-- Enable VS Code Inlay Hints (Parameter names and type annotations)
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Code Action keymaps
	keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	keymap("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	keymap("n", "<leader>cA", function() whole_file_code_actions(bufnr) end, opts)
	keymap("n", "<leader>co", function() organize_imports_and_format(bufnr) end, opts)

	-- Lspsaga keymaps
	keymap("n", "<leader>gd", "<cmd>Lspsaga peek_definition<CR>", opts)
	keymap("n", "<leader>gD", "<cmd>Lspsaga goto_definition<CR>", opts)
	keymap("n", "<leader>gS", "<cmd>vsplit | Lspsaga goto_definition<CR>", opts)
	keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	keymap("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	keymap("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
	keymap("n", "<leader>pd", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	keymap("n", "<leader>nd", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)

	-- fzf-lua keymaps
	keymap("n", "<leader>fd", "<cmd>FzfLua lsp_finder<CR>", opts)
	keymap("n", "<leader>fr", "<cmd>FzfLua lsp_references<CR>", opts)
	keymap("n", "<leader>ft", "<cmd>FzfLua lsp_typedefs<CR>", opts)
	keymap("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", opts)
	keymap("n", "<leader>fw", "<cmd>FzfLua lsp_workspace_symbols<CR>", opts)
	keymap("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<CR>", opts)

	-- DAP keymaps
	if client.name == "rust-analyzer" then
		local ok, dap = pcall(require, "dap")
		if ok then
			keymap("n", "<leader>dc", dap.continue, opts)
			keymap("n", "<leader>do", dap.step_over, opts)
			keymap("n", "<leader>di", dap.step_into, opts)
			keymap("n", "<leader>du", dap.step_out, opts)
			keymap("n", "<leader>db", dap.toggle_breakpoint, opts)
			keymap("n", "<leader>dr", dap.repl.open, opts)
		end
	end
end

return M
