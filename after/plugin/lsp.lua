require("mason.settings").set({
	ui = {
		border = "rounded",
	},
})

local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.nvim_workspace()

lsp.setup_nvim_cmp({
	formatting = {
		-- changing the order of fields so the icon is the first
		fields = { "menu", "abbr", "kind" },

		-- here is where the change happens
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "λ",
				luasnip = "⋗",
				buffer = "📋",
				path = "📁",
				nvim_lua = "π",
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	documentation = {
		max_height = 50,
		max_width = 60,
		border = "rounded",
		col_offset = 0,
		side_padding = 1,
		winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
		zindex = 1001,
	},
})

lsp.set_preferences({
	set_lsp_keymaps = { omit = { "K", "<F2>", "<F4>" } },
})

lsp.setup()
