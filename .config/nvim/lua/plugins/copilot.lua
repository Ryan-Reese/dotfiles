return {
  'zbirenbaum/copilot.lua',
  dependencies = { 'copilotlsp-nvim/copilot-lsp' },
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        trigger_on_accept = true,
        debouce = 15,
        keymap = {
          accept = '<C-j>',
          next = false,
          prev = false,
          dismiss = '<C-k>',
          toggle_auto_trigger = '<C-l>',
        },
      },
      nes = {
        enabled = false,
        -- keymap = {
        --   accept_and_goto = '<C-S-j>',
        --   accept = false,
        --   dismiss = '<C-S-k>',
        -- },
      },
    }
  end,
}
