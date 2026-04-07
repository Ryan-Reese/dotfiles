return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
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
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = false, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<BS>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'Around function' },
            ['if'] = { query = '@function.inner', desc = 'Inside function' },
            ['ac'] = { query = '@class.outer', desc = 'Around class' },
            ['ic'] = { query = '@class.inner', desc = 'Inside class' },
            ['aa'] = { query = '@parameter.outer', desc = 'Around parameter' },
            ['ia'] = { query = '@parameter.inner', desc = 'Inside parameter' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = { query = '@function.outer', desc = 'Next method start' },
            [']]'] = { query = '@class.outer', desc = 'Next class start' },
          },
          goto_next_end = {
            [']M'] = { query = '@function.outer', desc = 'Next method end' },
          },
          goto_previous_start = {
            ['[m'] = { query = '@function.outer', desc = 'Prev method start' },
            ['[['] = { query = '@class.outer', desc = 'Prev class start' },
          },
          goto_previous_end = {
            ['[M'] = { query = '@function.outer', desc = 'Prev method end' },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>cs'] = { query = '@parameter.inner', desc = '[C]ode [S]wap parameter forward' },
          },
          swap_previous = {
            ['<leader>cS'] = { query = '@parameter.inner', desc = '[C]ode [S]wap parameter backward' },
          },
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  { 'nvim-treesitter/nvim-treesitter-context', event = 'VeryLazy' },
}
-- vim: ts=2 sts=2 sw=2 et
