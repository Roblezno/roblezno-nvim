-- ================================================================================================
-- TITLE : lualine.nvim
-- LINKS :
--   > github : https://github.com/nvim-lualine/lualine.nvim
-- ABOUT : Kanagawa statusline with icons and rounded section separators.
-- ================================================================================================

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = "kanagawa",
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = "|",
			},
		})
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
