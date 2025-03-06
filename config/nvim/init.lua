-- Отключение netrw для использования nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Базовые настройки
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.number = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.et = true
vim.opt.ai = true
vim.opt.si = true
vim.opt.history = 700
vim.opt.autoread = true
vim.opt.so = 7
vim.opt.lazyredraw = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "number"
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.clipboard = "unnamed"
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 1
vim.opt.backspace = "indent,eol,start"
vim.opt.laststatus = 2
vim.opt.encoding = "utf-8"
vim.opt.fillchars:append("vert: ")

-- Настройка постоянной истории
if vim.fn.isdirectory("/tmp/.vim-undo-dir") == 0 then
  vim.fn.mkdir("/tmp/.vim-undo-dir", "", 0700)
end
vim.opt.undodir = "/tmp/.vim-undo-dir"
vim.opt.undofile = true

-- Определение системного Python для Neovim
if vim.env.VIRTUAL_ENV then
  vim.g.python3_host_prog = vim.fn.substitute(vim.fn.system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
  vim.g.python3_host_prog = vim.fn.substitute(vim.fn.system("which python3"), "\n", '', 'g')
end

-- Настройка цветовой схемы
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Настройка Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- последняя стабильная версия
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Загрузка плагинов
require("lazy").setup({
  -- Интерфейс и внешний вид
  { "joshdick/onedark.vim" },
  { "rakr/vim-one" },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "Yggdroot/indentLine", config = function()
    vim.g.indentLine_char = '┊'
    vim.g.indentLine_fileType = {'yaml', 'yml', 'yaml.helm', 'yaml.custom'}
  end },
  
  -- Навигация и файловый менеджер
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-n>", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" }
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
      })
    end
  },
  { "nvim-tree/nvim-web-devicons" },
  
  -- Интеграция с Tmux
  { "christoomey/vim-tmux-navigator" },
  { "edkolev/tmuxline.vim", config = function()
    vim.g.tmuxline_preset = 'powerline'
  end },
  
  -- Редактирование и форматирование
  { "junegunn/vim-easy-align", keys = {
    { "ga", "<Plug>(EasyAlign)", mode = "x", desc = "Easy Align (Visual)" },
    { "ga", "<Plug>(EasyAlign)", mode = "n", desc = "Easy Align (Normal)" }
  }},
  
  -- Сниппеты и автодополнение
  { "neoclide/coc.nvim", branch = "release" },
  { "honza/vim-snippets" },
  { "SirVer/ultisnips", config = function()
    vim.g.UltiSnipsExpandTrigger = "<C-l>"
    vim.g.coc_snippet_next = '<c-j>'
    vim.g.coc_snippet_prev = '<c-k>'
  end },
  
  -- Git интеграция
  { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  
  -- Синтаксический анализ
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }
})

-- Настройка Airline
vim.g.airline_theme = 'one'
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_a = vim.fn["airline#section#create"]({'mode', 'crypt', 'paste', 'spell', 'iminsert'})

-- Настройка автодополнения
vim.api.nvim_set_keymap('i', '<TAB>', 'pumvisible() ? "\\<C-n>" : v:lua.check_back_space() ? "\\<TAB>" : coc#refresh()', {expr = true, noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<S-TAB>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', {expr = true, noremap = true})

function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Показ документации
vim.api.nvim_set_keymap('n', 'K', ':call v:lua.show_documentation()<CR>', {noremap = true, silent = true})

function _G.show_documentation()
  if vim.bo.filetype == 'vim' then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  else
    vim.fn.CocAction('doHover')
  end
end

-- Автокоманды
vim.cmd([[
  autocmd BufNewFile,BufRead *.py set colorcolumn=80
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

-- Включение синтаксиса и цветовой схемы
vim.cmd([[
  syntax on
  set background=dark
  colorscheme one
]])
