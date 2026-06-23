-- Editor options optimized for NestJS/TypeScript development

-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Indentation
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- File encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Completion
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.pumheight = 10

-- Display
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

-- Splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99

-- Backups and undo
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Mouse
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Timeouts
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- File types
vim.filetype.plugin = true
vim.filetype.indent = true

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore = "*/node_modules/*,*/.git/*,*/dist/*,*/build/*,*.o,*.a,*.so,*.swp,*.swo"

-- Tabline
vim.opt.showtabline = 2

-- Statusline
vim.opt.laststatus = 3

-- conceallevel
vim.opt.conceallevel = 2

-- Shortmess
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Which wrap
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,[,]"

-- Fillchars
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = " ",
  foldsep = " ",
  foldclose = ">",
  diff = "╱",
  msgsep = "‾",
}
