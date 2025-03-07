-- Настройка лидер-клавиши
vim.g.mapleader = " " -- Пробел как leader-клавиша

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
  { "nvimdev/dashboard-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "                                                     ",
            "  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ ",
            "  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ",
            " ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ ",
            " ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  ",
            " ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ ",
            " ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ ",
            " ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ ",
            "    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    ",
            "          ░    ░  ░    ░ ░        ░   ░         ░    ",
            "                                 ░                   ",
            "                                                     "
          },
          center = {
            { icon = " ", key = "f", desc = "[Not Implemented] Find File" },
            { icon = " ", key = "n", desc = "New File",
               action = function()
                 local filename = vim.fn.input({
                   prompt = "Введите имя файла: ",
                   default = "",
                   completion = "file"
                 })

                 if filename and filename ~= "" then
                   -- Создаем директории, если они не существуют
                   local dir = vim.fn.fnamemodify(filename, ":h")
                   if dir ~= "." and vim.fn.isdirectory(dir) == 0 then
                     vim.fn.mkdir(dir, "p")
                   end

                   -- Открываем новый файл
                   vim.cmd("edit " .. filename)
                   vim.notify("Создан новый файл: " .. filename, vim.log.levels.INFO)
                 end
               end 
            },
            { icon = " ", key = "g", desc = "[Not Implemented] Find Text" },
            { icon = " ", key = "r", desc = "[Not Implemented] Recent Files" },
            { icon = " ", key = "c", desc = "[Not Implemented] Config" },
            { icon = " ", key = "s", desc = "[Not Implemented] Restore Session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          footer = {
            "Let the blood begin!"
          },
          vertical_center = true,
          header_highlight = "DashboardHeader",
          footer_highlight = "DashboardFooter"
        }
      })
    end
  },
  { "joshdick/onedark.vim" },
  { "rakr/vim-one" },
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "onedark",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 500,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { { "mode", separator = { left = '' }, right_padding = 2 } },
          lualine_b = { { "branch", "diff", "diagnostics", separator = { right = '' }, left_padding = 2 } },
          lualine_c = {
            {
              "filename",
              file_status = true,
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { { "progress", separator = { left = '' }, right_padding = 2 } },
          lualine_z = { { "location", separator = { right = '' }, left_padding = 2 } }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "fugitive" }
      })
    end
  },
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
              folder_arrow = false,
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
    vim.g.tmuxline_theme = 'onedark'
  end },
  
  -- Редактирование и форматирование
  { "junegunn/vim-easy-align", keys = {
    { "ga", "<Plug>(EasyAlign)", mode = "x", desc = "Easy Align (Visual)" },
    { "ga", "<Plug>(EasyAlign)", mode = "n", desc = "Easy Align (Normal)" }
  }},
  { "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,  -- Интеграция с treesitter
        ts_config = {
          lua = {'string'},  -- Не добавлять пары в строках lua
          javascript = {'template_string'},
          java = false,  -- Не проверять treesitter в java
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",  -- Alt+e для быстрого оборачивания
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment"
        },
      })
      
      -- Интеграция с nvim-cmp, если он используется
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  },
  { "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup({
        -- Добавляем поддержку для JSX/TSX
        pre_hook = function(ctx)
          local U = require("Comment.utils")
          
          -- Определяем, находимся ли мы в jsx/tsx контексте
          local location = nil
          if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif vim.bo.filetype == "vue" or vim.bo.filetype == "svelte" then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          end
          
          if location == "comment" then
            return
          end
          
          local node_type = nil
          if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
            node_type = require("ts_context_commentstring.utils").get_node_type()
          elseif vim.bo.filetype == "vue" or vim.bo.filetype == "svelte" then
            node_type = require("ts_context_commentstring.utils").get_node_type()
          end
          
          if node_type == "jsx_element" or node_type == "jsx_fragment" or
             node_type == "vue_element" or node_type == "svelte_element" then
            local U = require("Comment.utils")
            
            -- Определяем тип комментария
            local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"
            
            -- Определяем строки комментария
            local location_end = nil
            if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
              location_end = require("ts_context_commentstring.utils").get_node_type()
            elseif vim.bo.filetype == "vue" or vim.bo.filetype == "svelte" then
              location_end = require("ts_context_commentstring.utils").get_node_type()
            end
            
            return require("ts_context_commentstring.internal").calculate_commentstring({
              key = type,
              location = location_end,
            })
          end
        end,
      })
    end,
    keys = {
      { "gcc", desc = "Комментировать строку" },
      { "gc", mode = "v", desc = "Комментировать выделение" },
      { "gcb", desc = "Комментировать блок" },
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  
  -- LSP и автодополнение
  { "neovim/nvim-lspconfig" },           -- Базовая конфигурация LSP
  { "hrsh7th/nvim-cmp" },                -- Движок автодополнения
  { "hrsh7th/cmp-nvim-lsp" },            -- Источник LSP для nvim-cmp
  { "hrsh7th/cmp-buffer" },              -- Дополнение из буфера
  { "hrsh7th/cmp-path" },                -- Дополнение путей
  { "hrsh7th/cmp-cmdline" },             -- Дополнение командной строки
  { "L3MON4D3/LuaSnip" },                -- Движок сниппетов
  { "saadparwaiz1/cmp_luasnip" },        -- Интеграция LuaSnip с cmp
  { "rafamadriz/friendly-snippets" },    -- Коллекция сниппетов
  { "williamboman/mason.nvim" },         -- Менеджер установки LSP серверов
  { "williamboman/mason-lspconfig.nvim" },-- Интеграция mason с lspconfig
  { "honza/vim-snippets" },
  
  -- Git интеграция
  { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  
  -- Синтаксический анализ
  { "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "bash", "yaml", "json", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
        additional_vim_regex_highlighting = false,
      })
    end
  }
})

-- Цвета для дашборда
vim.api.nvim_command('autocmd ColorScheme * highlight DashboardHeader guifg=#E06C75')
vim.api.nvim_command('autocmd ColorScheme * highlight DashboardFooter guifg=#E06C75')

-- Настройка цветовой схемы для lualine происходит в конфигурации плагина

-- Настройка Mason (менеджер LSP серверов)
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Интеграция Mason с lspconfig
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "bashls" },
  automatic_installation = true,
})

-- Настройка LuaSnip
require("luasnip.loaders.from_vscode").lazy_load()

-- Настройка nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Настройка автодополнения для командной строки
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Настройка возможностей LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Настройка LSP серверов
local lspconfig = require('lspconfig')

-- Настройка общих опций для всех серверов
local on_attach = function(client, bufnr)
  -- Включение подсветки документации
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds({ group = "lsp_document_highlight", buffer = bufnr })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
    })
  end

  -- Настройка сочетаний клавиш
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
end

-- Настройка конкретных серверов
-- Lua
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Python
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}


-- Bash
lspconfig.bashls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

-- Настройка диагностики
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Настройка значков для диагностики
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
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
