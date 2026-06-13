-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },

      -- Allows extra capabilities provided by blink-cmp
      'saghen/blink.cmp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Jump to the definition in a vertical split, keeping the current
          -- buffer on the left (splitright is set in options.lua).
          map('grD', function()
            require('telescope.builtin').lsp_definitions { jump_type = 'vsplit' }
          end, '[G]oto [D]efinition (vsplit)')

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Rename the symbol under the cursor across the project. Neovim 0.11+ already binds
          -- this to `grn` by default; mapping it explicitly here just gives it an `LSP: ...`
          -- description so it reads consistently with the rest of the `gr` family in which-key.
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_rename, event.buf) then
            map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          end

          -- Code actions (quickfixes, refactors) for the cursor position or visual selection.
          -- Also a Neovim 0.11+ default (`gra`); mapped explicitly for a consistent label.
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction, event.buf) then
            map('gra', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
      }

      -- Broadcast blink.cmp's extra completion capabilities to every server.
      --  On Neovim 0.11+, blink already registers these on `vim.lsp.config('*')`
      --  automatically, so this is explicit-but-optional (kept for clarity).
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })

      -- Per-server overrides. These merge with the defaults that nvim-lspconfig
      --  ships in its `lsp/<server>.lua` runtime files (cmd, filetypes, root).
      --  See https://luals.github.io/wiki/settings/ for lua_ls options.
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- Toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      })

      -- Install servers, formatters and linters with Mason. Names here are Mason
      --  package names (not lspconfig names). mason-lspconfig then auto-enables
      --  (`vim.lsp.enable`) every installed server.
      require('mason-tool-installer').setup {
        ensure_installed = {
          'bash-language-server',
          'black', -- Used to format Python code
          'clang-format',
          'clangd',
          'dockerfile-language-server',
          -- 'harper-ls',
          'isort', -- Used to sort Python imports
          'jdtls',
          'lua-language-server',
          'pyright',
          'ruff',
          'rust-analyzer',
          'stylua', -- Used to format Lua code
          'tinymist', -- Typst
          'typescript-language-server',
          'typstyle',
        },
      }

      -- mason-lspconfig 2.x: the old `handlers`/`setup_handlers` API was removed.
      --  It now just enables installed servers via `vim.lsp.enable()`. Exclude
      --  `stylua`: nvim-lspconfig ships an `lsp/stylua.lua` (stylua --lsp), which
      --  would otherwise start a redundant formatting server -- formatting is
      --  handled by conform.nvim.
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- installs are driven by mason-tool-installer above
        automatic_enable = { exclude = { 'stylua' } },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
