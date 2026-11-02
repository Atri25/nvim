-- ================================================================================================
-- TITLE : nvim-autopairs
-- ABOUT : VS Code-like contextual auto-pairing and typeover behavior
-- ================================================================================================

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true, -- Enable Treesitter check
		ts_config = {
			cpp = { "string", "comment" }, -- Do NOT auto-pair inside C++ strings or comments
			c = { "string", "comment" },
			go = { "string", "comment" },
			python = { "string" },
		},
		enable_check_bracket_line = false, -- VS Code type-through: skip existing closing brackets when typed
		ignored_next_char = "[%w%.]", -- Do NOT add closing pair if directly preceding a word or number
		fast_wrap = {},
	},
}
