local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.nvim_workspace()

lsp.setup_nvim_cmp({
   formatting = {
    -- changing the order of fields so the icon is the first
    fields = {'menu', 'abbr', 'kind'},

    -- here is where the change happens
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
        nvim_lua = 'Π',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  documentation = {
    max_height = 50,
    max_width = 60,
    border = 'rounded',
    col_offset = 0,
    side_padding = 1,
    winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
    zindex = 1001
  }
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      -- border = { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" },
      -- border = "shadow",
      border = "rounded",
    }
  )

lsp.setup()
