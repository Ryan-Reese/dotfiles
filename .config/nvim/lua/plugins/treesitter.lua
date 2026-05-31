-- Treesitter on the `main` branch (the rewrite). Requires Neovim 0.12+ and the
-- `tree-sitter` CLI (>=0.26.1). Highlighting is provided by Neovim itself and
-- started per-buffer; parsers are installed via `require('nvim-treesitter').install`.
-- See `:help nvim-treesitter` and https://github.com/nvim-treesitter/nvim-treesitter
local ensure_installed = {
  'bash',
  'bibtex',
  'c',
  'comment',
  'cpp',
  'css',
  'csv',
  'diff',
  'git_config',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'html',
  'ini',
  'java',
  'javascript',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'matlab',
  'python',
  'query',
  'requirements',
  'rust',
  'ssh_config',
  'tmux',
  'toml',
  'typst',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {}

      -- Install any missing parsers (async; first run populates the parser dir).
      require('nvim-treesitter').install(ensure_installed)

      -- Highlighting is now provided by Neovim and must be started per-buffer.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('ts-highlight', { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          -- Only start for a language whose parser is actually installed.
          --  `get_lang` falls back to the filetype name (e.g. "oil"), and
          --  `get_parser` builds a tree lazily without erroring, so checking the
          --  installed set is the only reliable guard.
          if not lang or not vim.tbl_contains(require('nvim-treesitter').get_installed(), lang) then
            return
          end
          -- Skip very large files to keep things responsive.
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > 100 * 1024 then
            return
          end
          vim.treesitter.start(buf, lang)
        end,
      })
    end,
  },

  { -- Treesitter-powered text objects (also `main`-branch API)
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup { select = { lookahead = true } }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      -- Select: af/if (function), ac/ic (class), aa/ia (parameter)
      local function map_select(key, query, desc)
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = desc })
      end
      map_select('af', '@function.outer', 'Around function')
      map_select('if', '@function.inner', 'Inside function')
      map_select('ac', '@class.outer', 'Around class')
      map_select('ic', '@class.inner', 'Inside class')
      map_select('aa', '@parameter.outer', 'Around parameter')
      map_select('ia', '@parameter.inner', 'Inside parameter')

      -- Move: ]m/[m (method), ]]/[[ (class), ]M/[M (method end)
      local function map_move(key, fn, query, desc)
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          move[fn](query, 'textobjects')
        end, { desc = desc })
      end
      map_move(']m', 'goto_next_start', '@function.outer', 'Next method start')
      map_move(']]', 'goto_next_start', '@class.outer', 'Next class start')
      map_move(']M', 'goto_next_end', '@function.outer', 'Next method end')
      map_move('[m', 'goto_previous_start', '@function.outer', 'Prev method start')
      map_move('[[', 'goto_previous_start', '@class.outer', 'Prev class start')
      map_move('[M', 'goto_previous_end', '@function.outer', 'Prev method end')

      -- Swap parameters
      vim.keymap.set('n', '<leader>cs', function()
        swap.swap_next '@parameter.inner'
      end, { desc = '[C]ode [S]wap parameter forward' })
      vim.keymap.set('n', '<leader>cS', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = '[C]ode [S]wap parameter backward' })
    end,
  },

  -- Show the current code context at the top of the window.
  { 'nvim-treesitter/nvim-treesitter-context', event = 'VeryLazy' },
}
-- vim: ts=2 sts=2 sw=2 et
