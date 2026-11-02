return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = "rose-pine",
				icons_enabled = true,
				component_separators = "|",
				section_separators = "", -- Flat rectangular blocks (i3 style)
			},
		})
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
