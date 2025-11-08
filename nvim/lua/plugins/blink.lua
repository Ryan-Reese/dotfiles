return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        opts = {},
      },
      'folke/lazydev.nvim',
      'xzbdmw/colorful-menu.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_next()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        trigger = { show_in_snippet = false },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          -- nvim-cmp style menu
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
          },
          border = nil,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = {
            border = nil,
          },
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = 'inherit' },
        completion = {
          menu = {
            auto_show = true,
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
        },
      },

      snippets = { preset = 'luasnip' },
      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      -- Shows a signature help window while you type arguments for a function
      signature = {
        enabled = true,
        window = {
          border = nil,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
