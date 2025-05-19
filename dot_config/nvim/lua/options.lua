-- [[ Setting options ]]
vim.opt.number = true

vim.opt.relativenumber = true

vim.opt.showmode = false

local function is_wsl()
  local output = vim.fn.system 'grep -i microsoft /proc/version'
  return (output ~= '' and output:find 'microsoft' ~= nil)
end

-- Set clipboard based on environment
if is_wsl() then
  -- WSL clipboard configuration using win32yank
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank -i --crlf',
      ['*'] = 'win32yank -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank -o --lf',
      ['*'] = 'win32yank -o --lf',
    },
    cache_enabled = 0,
  }
else
  -- Linux clipboard configuration using xclip
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = 'xclip -selection clipboard',
      ['*'] = 'xclip -selection clipboard',
    },
    paste = {
      ['+'] = 'xclip -selection clipboard -o',
      ['*'] = 'xclip -selection clipboard -o',
    },
    cache_enabled = 1,
  }
end

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.confirm = true
