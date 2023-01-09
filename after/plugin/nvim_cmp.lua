---
-- Snippet engine setup
---

local luasnip = require("luasnip")

luasnip.config.set_config({
    region_check_events = "InsertEnter",
    delete_check_events = "InsertLeave",
})

require("luasnip.loaders.from_vscode").lazy_load()

---
-- Autocompletion
---

local cmp = require("cmp")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local select_opts = { behavior = cmp.SelectBehavior.Select }

local cmp_config = {
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "buffer", keyword_length = 3 },
        { name = "luasnip", keyword_length = 2 },
    },
    window = {
        documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
            max_height = 15,
            max_width = 60,
            border = "rounded",
            col_offset = 0,
            side_padding = 1,
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
            zindex = 1001,
        }),
    },
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
    mapping = {
        -- confirm selection
        ["<C-y>"] = cmp.mapping.confirm({ select = false }),

        -- navigate items on the list
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

        -- scroll up and down in the completion documentation
        ["<C-d>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),

        -- toggle completion
        ["<C-e>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
                fallback()
            else
                cmp.complete()
            end
        end),

        -- go to next placeholder in the snippet
        ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),

        -- go to previous placeholder in the snippet
        ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
}

cmp.setup(cmp_config)
