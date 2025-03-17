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
vim.opt.laststatus = 3
vim.opt.encoding = "utf-8"
vim.opt.fillchars:append({ vert = "│", vertleft = "┃", vertright = "┃", horiz = "━", horizup = "┻", horizdown = "┳", verthoriz = "╋" })

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

-- Функция для получения случайных подсказок по Vim
local function get_random_tips(count)
  local tips = {
    "Tip: <leader>ff для поиска файлов, <leader>fg для поиска текста",
    "Tip: <C-n> открывает файловый менеджер NvimTree",
    "Tip: <leader>gs показывает статус Git, <leader>gb для Git blame",
    "Tip: gd переходит к определению под курсором (LSP)",
    "Tip: K показывает документацию для элемента под курсором",
    "Tip: <space>rn переименовывает символ под курсором",
    "Tip: <space>ca показывает доступные code actions",
    "Tip: gcc комментирует текущую строку, gc в визуальном режиме комментирует выделение",
    "Tip: ga в визуальном режиме для выравнивания текста (EasyAlign)",
    "Tip: <C-Space> вызывает автодополнение",
    "Tip: <Tab> и <S-Tab> для навигации по меню автодополнения",
    "Tip: gr показывает все ссылки на символ под курсором",
    "Tip: <space>f форматирует текущий буфер или выделение",
    "Tip: <C-b> и <C-f> для прокрутки документации в меню автодополнения",
    "Tip: <M-e> для быстрого оборачивания текста в скобки/кавычки",
    "Tip: <leader>fb показывает список открытых буферов",
    "Tip: <leader>fh поиск по справке Neovim",
    "Tip: Используйте русскую раскладку без переключения режимов",
    "Tip: gcb комментирует блок кода",
    "Tip: Используйте :Git для работы с Git репозиторием",
    "Tip: gi переходит к месту последнего редактирования",
    "Tip: <C-o> и <C-i> для перемещения по истории перемещений",
    "Tip: zz центрирует экран по курсору",
    "Tip: zt перемещает курсор в верхнюю часть экрана",
    "Tip: zb перемещает курсор в нижнюю часть экрана",
    "Tip: % перемещает курсор к парной скобке",
    "Tip: * ищет слово под курсором вперед, # - назад",
    "Tip: <C-w>v разделяет окно вертикально, <C-w>s - горизонтально",
    "Tip: <C-w>h/j/k/l перемещение между окнами",
    "Tip: :bd закрывает текущий буфер",
    "Tip: :e перезагружает текущий файл",
    "Tip: :w !sudo tee % сохраняет файл с правами sudo",
    "Tip: gg перемещает в начало файла, G - в конец",
    "Tip: f{char} перемещает к следующему вхождению символа в строке",
    "Tip: t{char} перемещает перед следующим вхождением символа",
    "Tip: ; повторяет последний поиск f, F, t или T",
    "Tip: ci\" изменяет содержимое внутри кавычек",
    "Tip: di( удаляет содержимое внутри скобок",
    "Tip: yi{ копирует содержимое внутри фигурных скобок",
    "Tip: va[ выделяет содержимое внутри квадратных скобок включая скобки",
    "Tip: :set spell включает проверку орфографии",
    "Tip: ]s переходит к следующей ошибке орфографии",
    "Tip: z= показывает варианты исправления слова под курсором",
    "Tip: <C-x><C-f> автодополнение имен файлов в режиме вставки",
    "Tip: <C-x><C-l> автодополнение целых строк",
    "Tip: <C-a> увеличивает число под курсором, <C-x> уменьшает",
    "Tip: gUiw делает слово под курсором ПРОПИСНЫМ",
    "Tip: guiw делает слово под курсором строчным",
    "Tip: g~iw инвертирует регистр слова под курсором",
    "Tip: :jumps показывает историю перемещений",
    "Tip: :changes показывает историю изменений",
    "Tip: :registers показывает содержимое регистров",
    "Tip: :marks показывает все установленные метки",
    "Tip: ma устанавливает метку a, `a переходит к ней",
    "Tip: '. переходит к последнему изменению",
  }

  -- Перемешиваем массив подсказок
  for i = #tips, 2, -1 do
    local j = math.random(i)
    tips[i], tips[j] = tips[j], tips[i]
  end

  -- Возвращаем первые count элементов
  local result = {}
  for i = 1, count do
    table.insert(result, tips[i])
  end

  return result
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
            { icon = " ", key = "f", desc = "Find File", action = "Telescope find_files" },
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
            { icon = " ", key = "g", desc = "Find Text", action = "Telescope live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = "Telescope oldfiles" },
            { icon = "󰒓 ", key = "c", desc = "Edit Config", action = "edit $MYVIMRC" },
            { icon = "󱏒 ", key = "<C-n>", desc = "File Explorer (NvimTree)", action = "NvimTreeToggle" },
            { icon = " ", key = "q", desc = "Quit", action = "qa" },
          },
          footer = function()
            return get_random_tips(1)
          end,
          vertical_center = true,
          header_highlight = "DashboardHeader",
          footer_highlight = "DashboardFooter"
        }
      })
    end
  },
  { "joshdick/onedark.vim", priority = 1000 },
  { "rakr/vim-one", priority = 1000 },

  -- Telescope для поиска файлов и текста
  { "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons" 
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules" },
        }
      })
    end
  },
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
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
  { "Yggdroot/indentLine", 
    ft = {'yaml', 'yml', 'yaml.helm', 'yaml.custom'},
    config = function()
    vim.g.indentLine_char = '┊'
    vim.g.indentLine_fileType = {'yaml', 'yml', 'yaml.helm', 'yaml.custom'}
  end },

  -- Навигация и файловый менеджер
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "NvimTreeToggle",
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
  { "edkolev/tmuxline.vim", 
    cmd = {"Tmuxline", "TmuxlineSnapshot"},
    config = function()
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
  
  -- LSP и автодополнение (группировка для оптимизации)
  { "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/nvim-cmp", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
      { "hrsh7th/cmp-buffer", event = "InsertEnter" },
      { "hrsh7th/cmp-path", event = "InsertEnter" },
      { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
      { "L3MON4D3/LuaSnip", event = "InsertEnter" },
      { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
      { "rafamadriz/friendly-snippets", event = "InsertEnter" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "honza/vim-snippets", event = "InsertEnter" },
    }
  },
  
  -- Git интеграция
  { "airblade/vim-gitgutter", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-fugitive", cmd = {"Git", "Gstatus", "Gblame", "Gpush", "Gpull"} },
  
  -- Синтаксический анализ
  { "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "bash", "yaml", "json", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
        additional_vim_regex_highlighting = false,
      })
    end
  }
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
    cache = {
      enabled = true,
    },
    reset_packpath = true,
  },
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🔑",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})

-- Добавление команд для dashboard
vim.api.nvim_create_user_command('DashboardFindFiles', function()
  vim.cmd('Telescope find_files')
end, {})

vim.api.nvim_create_user_command('DashboardFindText', function()
  vim.cmd('Telescope live_grep')
end, {})

vim.api.nvim_create_user_command('DashboardRecentFiles', function()
  vim.cmd('Telescope oldfiles')
end, {})

-- Настройка сочетаний клавиш для Git
vim.keymap.set('n', '<leader>gs', ':Git<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { noremap = true, silent = true })

-- Цвета для дашборда
vim.api.nvim_command('autocmd ColorScheme * highlight DashboardHeader guifg=#E06C75')
vim.api.nvim_command('autocmd ColorScheme * highlight DashboardFooter guifg=#98C379')
vim.api.nvim_command('autocmd ColorScheme * highlight DashboardDesc guifg=#61AFEF')
vim.api.nvim_command('autocmd ColorScheme * highlight DashboardKey guifg=#C678DD')

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
  ensure_installed = { "lua_ls", "pyright", "bashls", "yamlls" },
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

 -- YAML и Kubernetes
 lspconfig.yamlls.setup {
   capabilities = capabilities,
   on_attach = on_attach,
   settings = {
     yaml = {
       schemas = {
         ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.3/all.json"] = "*.yaml",
         ["https://json.schemastore.org/chart.json"] = "Chart.yaml"
       },
       format = {
         enable = true,
       },
       validate = true,
       completion = true,
       hover = true,
     },
   },
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
