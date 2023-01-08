require("mason").setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

local function merge(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end

    return t1
end

require("mason-lspconfig").setup()

local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        merge(bufopts, { desc = "Go to declaration" })
    )
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, merge(bufopts, { desc = "Go to definition" }))
    vim.keymap.set(
        "n",
        "gi",
        vim.lsp.buf.implementation,
        merge(bufopts, { desc = "Go to implementation" })
    )
    vim.keymap.set(
        "n",
        "<C-k>",
        vim.lsp.buf.signature_help,
        merge(bufopts, { desc = "Show signature help" })
    )
    vim.keymap.set(
        "n",
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        merge(bufopts, { desc = "Add workspace folder" })
    )
    vim.keymap.set(
        "n",
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        merge(bufopts, { desc = "Remove workspace folder" })
    )
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, merge(bufopts, { desc = "List workspace folders" }))

    vim.keymap.set(
        "n",
        "<leader>D",
        vim.lsp.buf.type_definition,
        merge(bufopts, { desc = "Show Type Definition" })
    )
    vim.keymap.set("n", "gr", vim.lsp.buf.references, merge(bufopts, { desc = "Show references" }))
    vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
    end, merge(bufopts, { desc = "Format using LSP" }))
end

require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
        })
    end,

    -- Next, you can provide a dedicated handler for specific servers.
    ["rust_analyzer"] = function()
        local rt = require("rust-tools")
        rt.setup({
            on_attach = on_attach
        })
    end,
    ["sumneko_lua"] = function()
        require("lspconfig")["sumneko_lua"].setup({
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    runtime = {
                        version = "LuaJIT",
                        path = vim.split(package.path, ";"),
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        },
                    },
                },
            },
        })
    end,
})

require("mason").setup()
require("mason-null-ls").setup({
    automatic_installation = false,
    automatic_setup = true,
})
require("null-ls").setup()

require("mason-null-ls").setup_handlers()

--[[ local lsp = require("lsp-zero")

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
}) ]]
