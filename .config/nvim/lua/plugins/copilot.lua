return {
  'zbirenbaum/copilot.lua',
  dependencies = { 'copilotlsp-nvim/copilot-lsp' },
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'InsertEnter',
  keys = {
    {
      '<leader>ta',
      function()
        require('copilot.suggestion').toggle_auto_trigger()
      end,
      desc = '[T]oggle [A]I auto-trigger',
    },
  },
  opts = {
    panel = {
      enabled = false,
    },
    suggestion = {
      enabled = true,
      auto_trigger = false,
      trigger_on_accept = true,
      debounce = 15,
      keymap = {
        accept = '<C-j>',
        next = false,
        prev = false,
        dismiss = '<C-k>',
      },
    },
    nes = {
      enabled = false,
    },
  },
}
