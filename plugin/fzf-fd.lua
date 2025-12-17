-- 二重読み込み防止
if vim.g.loaded_fzf_fd then
  return
end
vim.g.loaded_fzf_fd = true

-- キーマッピング設定
vim.keymap.set('n', '<Plug>fzf-rg', function()
  require('fzf-rg').run()
end, { silent = true })

