vim.o.background = "dark"

require("gruvbox").setup({
	overrides = {
		ColorColumn = { bg = "#331111" },
		NormalFloat = { link = "Normal" },
		FloatBorder = { link = "GruvboxFg4" },
	},
	transparent_mode = true,
})

vim.cmd.colorscheme("gruvbox")

require("lualine").setup()

local g = vim.g

local fullscreen = false

vim.keymap.set("n", "<M-CR>", function()
	if fullscreen then
		fullscreen = false
		g.neovide_fullscreen = false
	else
		fullscreen = true
		g.neovide_fullscreen = true
	end
end)

if g.neovide then
	print("Neovide detected")
	g.neovide_refresh_rate = 65
	g.neovide_transparency = 0.8
	g.neovide_cursor_animation_length = 0.05
	g.neovide_cursor_trail_length = 0.01
	g.neovide_cursor_vfx_mode = "pixiedust"
	g.neovide_remember_dimensions = true
	g.neovide_scroll_animation_length = 0.2

	vim.opt.guifont = { "FantasqueSansMono NF", ":h10" }
end
