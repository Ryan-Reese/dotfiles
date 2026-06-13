-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Append next line to current line' })

-- maintain screen centering when moving around
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll window downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll window upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result' })

vim.keymap.set('n', 'Q', '<nop>', { desc = 'nop' })

-- paste over visual selection without clobbering register
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without clobbering register' })

-- insert [count] blank lines above or below without moving the cursor or leaving normal mode
local function insert_blank_lines(above)
  local count = vim.v.count1
  local pos = vim.api.nvim_win_get_cursor(0) -- { row (1-based), col (0-based) }
  local row = pos[1]
  local blanks = {}
  for _ = 1, count do
    blanks[#blanks + 1] = ''
  end
  local at = above and row - 1 or row -- 0-based insertion index
  vim.api.nvim_buf_set_lines(0, at, at, false, blanks)
  -- keep the cursor on the original line (it shifts down by `count` when inserting above)
  vim.api.nvim_win_set_cursor(0, { above and row + count or row, pos[2] })
end

vim.keymap.set('n', '<leader>o', function()
  insert_blank_lines(false)
end, { desc = 'Insert line below' })
vim.keymap.set('n', '<leader>O', function()
  insert_blank_lines(true)
end, { desc = 'Insert line above' })

-- toggle line wrapping
vim.keymap.set('n', '<leader>tw', function()
  vim.cmd 'set wrap!'
end, { desc = '[T]oggle [W]rap lines' })

-- toggle color column
vim.keymap.set('n', '<leader>tc', function()
  local value = vim.api.nvim_get_option_value('colorcolumn', {})
  if value == '' then
    vim.api.nvim_set_option_value('colorcolumn', '80', {})
  else
    vim.api.nvim_set_option_value('colorcolumn', '', {})
  end
end, { desc = '[T]oggle [C]olour column' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- vim: ts=2 sts=2 sw=2 et
