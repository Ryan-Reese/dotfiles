return {
  'danymat/neogen',
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { 'grg', ":lua require('neogen').generate()<CR>", desc = '[G]enerate docstring' },
  },
  opts = {
    enabled = true,
    input_after_comment = true,
    languages = {
      python = {
        template = {
          annotation_convention = 'numpydoc',
        },
      },
    },
    snippet_engine = 'luasnip',
  },
}
