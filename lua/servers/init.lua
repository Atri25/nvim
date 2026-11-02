-- ================================================================================================
-- TITLE : Server Loader Module
-- ================================================================================================

return function(capabilities)
	-- List of active language server modules inside lua/servers/
	local server_files = {
		"clangd",
		"gopls",
		"pyright",
		"bashls",
		"dockerls",
		"jsonls",
		"lua_ls",
		"yamlls",
	}

	for _, server in ipairs(server_files) do
		local ok, server_config = pcall(require, "servers." .. server)
		if ok and type(server_config) == "function" then
			server_config(capabilities)
		end
	end
end
