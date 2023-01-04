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

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	local bind = vim.keymap.set

	bind("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", opts)

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end
end)

lsp.setup()

local null_ls = require("null-ls")
local mason_nullls = require("mason-null-ls")

mason_nullls.setup({
	automatic_installation = true,
	automatic_setup = true,
})
mason_nullls.setup_handlers({
	stylua = function()
		null_ls.register(null_ls.builtins.formatting.stylua)
	end,
})
