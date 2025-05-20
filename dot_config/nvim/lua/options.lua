-- [[ Setting options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false

-- Fixed WSL detection function
local function is_wsl()
	local wsl_distro_path = "/proc/sys/fs/binfmt_misc/WSLInterop"
	local has_wsl_interop = vim.fn.filereadable(wsl_distro_path) == 1

	-- Fallback to checking /proc/version if file doesn't exist
	if not has_wsl_interop then
		local f = io.open("/proc/version", "r")
		if f then
			local content = f:read("*all")
			f:close()
			return content:lower():match("microsoft") ~= nil
		end
	end

	return has_wsl_interop
end

-- Set clipboard based on environment
if is_wsl() then
	-- WSL clipboard configuration using win32yank
	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
else
	-- Linux clipboard configuration using xclip
	vim.g.clipboard = {
		name = "xclip",
		copy = {
			["+"] = "xclip -selection clipboard",
			["*"] = "xclip -selection clipboard",
		},
		paste = {
			["+"] = "xclip -selection clipboard -o",
			["*"] = "xclip -selection clipboard -o",
		},
		cache_enabled = 1,
	}
end

vim.opt.clipboard = "unnamedplus"

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.confirm = true
