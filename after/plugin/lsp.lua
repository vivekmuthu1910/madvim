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

local merge = vim.tbl_extend

core.lsp = {}
core.lsp.on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        merge("force", bufopts, { desc = "Go to declaration" })
    )
    vim.keymap.set(
        "n",
        "gd",
        vim.lsp.buf.definition,
        merge("force", bufopts, { desc = "Go to definition" })
    )
    vim.keymap.set(
        "n",
        "gi",
        vim.lsp.buf.implementation,
        merge("force", bufopts, { desc = "Go to implementation" })
    )
    vim.keymap.set(
        "n",
        "<C-k>",
        vim.lsp.buf.signature_help,
        merge("force", bufopts, { desc = "Show signature help" })
    )
    vim.keymap.set(
        "n",
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        merge("force", bufopts, { desc = "Add workspace folder" })
    )
    vim.keymap.set(
        "n",
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        merge("force", bufopts, { desc = "Remove workspace folder" })
    )
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, merge("force", bufopts, { desc = "List workspace folders" }))

    vim.keymap.set(
        "n",
        "<leader>D",
        vim.lsp.buf.type_definition,
        merge("force", bufopts, { desc = "Show Type Definition" })
    )
    vim.keymap.set(
        "n",
        "gr",
        vim.lsp.buf.references,
        merge("force", bufopts, { desc = "Show references" })
    )
    vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
    end, merge("force", bufopts, { desc = "Format using LSP" }))

    -- Lsp Sage Keymaps
    vim.keymap.set("n", "<leader>lh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

    vim.keymap.set({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", { silent = true })

    vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { silent = true })

    -- Peek Definition
    -- you can edit the definition file in this flaotwindow
    -- also support open/vsplit/etc operation check definition_action_keys
    -- support tagstack C-t jump back
    vim.keymap.set("n", "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

    -- Show line diagnostics
    vim.keymap.set("n", "<leader>lcd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

    -- Show cursor diagnostics
    vim.keymap.set(
        "n",
        "<leader>lcd",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        { silent = true }
    )

    -- Diagnostic jump can use `<c-o>` to jump back
    vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
    vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

    -- Only jump to error
    vim.keymap.set("n", "[E", function()
        require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, { silent = true })
    vim.keymap.set("n", "]E", function()
        require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, { silent = true })

    -- Outline
    vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { silent = true })

    -- Hover Doc
    vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
            require("lspsaga.hover"):render_hover_doc()
        end
    end)
end
local user_lsp = core.load_user_config("lsp") or {}

require("mason-lspconfig").setup({
    ensure_installed = user_lsp.ensure_installed or {},
})

local saga = require("lspsaga")

saga.init_lsp_saga()

require("mason-lspconfig").setup_handlers(vim.tbl_deep_extend("force", {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
            on_attach = core.lsp.on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
    end,
}, user_lsp.setup_handlers or {}))

local system_lsps = user_lsp.system_lsps or {}

for server, settings in pairs(system_lsps) do
    if type(server) == "number" then
        require("lspconfig")[settings].setup()
    else
        require("lspconfig")[server].setup(settings)
    end
end

require("mason").setup()
require("mason-null-ls").setup({
    automatic_installation = false,
    automatic_setup = true,
})
require("null-ls").setup()

require("mason-null-ls").setup_handlers()

local function lsp_settings()
    local sign = function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = "",
        })
    end

    sign({ name = "DiagnosticSignError", text = "✘" })
    sign({ name = "DiagnosticSignWarn", text = "▲" })
    sign({ name = "DiagnosticSignHint", text = "⚑" })
    sign({ name = "DiagnosticSignInfo", text = "" })

    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })
end

lsp_settings()

-- Float terminal
vim.keymap.set("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- if you want to pass some cli command into a terminal you can do it like this
-- open lazygit in lspsaga float terminal
-- vim.keymap.set("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })

-- close floaterm
vim.keymap.set("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
