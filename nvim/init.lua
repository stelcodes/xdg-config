-- enable full color support
vim.opt.termguicolors = true

map = function(mode, binding, action)
  vim.api.nvim_set_keymap(mode, binding, action, {noremap = true})
end

-- Plugins
require('packer').startup(function(use)

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-fugitive'

  use {
    'olical/conjure',
    config = function()
      vim.g['conjure#log#hud#width'] = 1
      vim.g['conjure#log#hud#height'] = 0.6
      vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
    end
  }

  use {
    'stelcodes/paredit',
    config = function()
      vim.g['paredit_smartjump'] = 1
    end
  }

  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}},
    config = function()
      map('n', '<c-f>', '<cmd>Telescope find_files<cr>')
      map('n', '<c-r>', '<cmd>Telescope live_grep<cr>')
    end
  }

  -- Check here to add more LSP's
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  use {
    'neovim/nvim-lspconfig',
    config = function()
      -- https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion
      local lspconfig = require('lspconfig')

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(_, bufnr)
        local function bufmap(mode, binding, action) vim.api.nvim_buf_set_keymap(bufnr, mode, binding, action, {noremap = true}) end
        local function bufoption(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        bufoption('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        -- Bindings I will definitely use a lot
        bufmap('n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        bufmap('n', '<leader>jk', '<cmd>lua vim.lsp.buf.hover()<CR>')
        bufmap('n', '<leader>jn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        bufmap('n', '<leader>ja', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        bufmap('n', '<leader>jw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        bufmap('n', '<leader>jl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
        bufmap('n', '<leader>jr', '<cmd>lua vim.lsp.buf.references()<CR>')

        -- Bindings that I may use in the future for some langs
        bufmap('n', '<leader>jI', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        bufmap('n', '<leader>jD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        bufmap('n', '<leader>jK', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        bufmap('n', '<leader>jT', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        -- bufmap('n' '<leader>ja', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        -- bufmap('n', '<leader>jr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        -- bufmap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
        -- bufmap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
        -- bufmap('n', '<leader>j', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
        bufmap('n', '<leader>jz', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        bufmap('v', '<leader>jz', '<cmd>lua vim.lsp.buf.range_formatting({})<CR>')

      end

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'clojure_lsp', 'sumneko_lua' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end

      lspconfig.sumneko_lua.setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150
        },
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      }

      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importGranularity = "module",
              importPrefix = "by_self",
            },
            cargo = {
              loadOutDirsFromCheck = true
            },
            procMacro = {
              enable = true
            },
          }
        }
      }

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

    end
  }

  use {
    'euclio/vim-markdown-composer',
    run = 'cargo build --release --locked',
    config = function()
      vim.g['markdown_composer_syntax_theme'] = 'dark'
      vim.g['markdown_composer_open_browser'] = 0
    end
  }

  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.g['better_whitespace_guicolor'] = '#ff5555'
      vim.g['better_whitespace_filetypes_blacklist'] = {
        '', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'fugitive'
      }
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {{'kyazdani42/nvim-web-devicons'}},
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'dracula',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'%f'},
          lualine_x = {'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {'nvim-tree'}
      }
    end
  }

  use 'kyazdani42/nvim-web-devicons'

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        on_attach = function()
          map('n', '<leader>hs', ':Gitsigns stage_hunk<cr>')
          map('v', '<leader>hs', ':Gitsigns stage_hunk<cr>')
          map('n', '<leader>hu', ':Gitsigns undo_stage_hunk<cr>')
          map('n', '<leader>hr', ':Gitsigns reset_hunk<cr>')
          map('v', '<leader>hr', ':Gitsigns reset_hunk<cr>')
          map('n', '<leader>hR', ':Gitsigns reset_buffer<cr>')
          map('n', '<leader>hp', ':Gitsigns preview_hunk<cr>')
          map('n', '<leader>hb', ':lua require"gitsigns".blame_line{full=true}<cr>')
          map('n', '<leader>hS', ':Gitsigns stage_buffer<cr>')
          map('n', '<leader>hU', ':Gitsigns reset_buffer_index<cr>')
        end
      }
    end
  }

  -- TODO https://github.com/hrsh7th/nvim-cmp

  use {
    'stelcodes/dracula.nvim',
    config = function()
      vim.cmd 'colorscheme dracula'
    end
  }

  use {
    'Pocco81/AutoSave.nvim',
    config = function()
      require("autosave").setup {
        enabled = true,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
          exists = true,
          filename_is_not = {},
          filetype_is_not = {},
          modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
      }
    end
  }

  use {
    'akinsho/bufferline.nvim',
    requires = {{'kyazdani42/nvim-web-devicons'}},
    config = function()
      require('bufferline').setup {}
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
        -- Markdown module is trash atm
        ignore_install = { 'markdown' },
        disable = { 'markdown' },
        highlight = { enable = true },
        -- Experimental
        indent = { enable = true }
      }
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require'nvim-tree'.setup {}
    end
  }

  -- :ASToggle
  use {
    'rmagatti/auto-session',
    config = function()
      vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
      require('auto-session').setup {
        auto_restore_enabled = false
      }
    end
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {}
    end
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("indent_blankline").setup {}
    end
  }

  -- :ColorizerAttachToBuffer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup {
        'css'
      }
    end
  }

end)

----------------------------------------------------------------------------------

-- Clojure
vim.g['clojure_fuzzy_indent_patterns'] = {'^with', '^def', '^let', '^try', '^do$'}
vim.g['clojure_special_indent_words'] = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn,do'
vim.g['clojure_align_multiline_strings'] = 0
vim.g['clojure_align_subforms'] = 1

-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map('n', '<Space>', '<Nop>')
map('x', '<leader>', '<Nop>')

-- Substitution
-- Preview pane for substitution
vim.opt.inccommand = 'split'

start_substitution = function()
  vim.api.nvim_input(':%s/<c-r>\"//gc<left><left><left>')
end

map('n', '<leader>y', 'viwy')
map('n', '<leader>u', '<cmd>lua start_substitution()<CR>')

-- General Settings
vim.cmd 'filetype plugin indent on'

vim.opt.autoindent = true

vim.opt.backspace = 'indent,eol,start'

vim.opt.complete = '.,w,b,u,t'

vim.opt.smarttab = true

vim.opt.nrformats = 'bin,hex'

vim.opt.incsearch = true

vim.opt.laststatus = 2

vim.opt.ruler = true

vim.opt.wildmenu = true

vim.opt.scrolloff = 1

vim.opt.sidescrolloff = 5

vim.opt.display = 'lastline,msgsep'

vim.opt.autoread = true
-- Stop newline continution of comments
vim.opt.formatoptions = 'qlj'

vim.opt.history = 1000

vim.opt.tabpagemax = 50
-- save undo history
vim.opt.undofile = true
-- treat dash separated words as a word text object
vim.opt.iskeyword = { '@', '48-57', '_', '192-255', '-', '#' }
-- Required to keep multiple buffers open
vim.opt.hidden = true
-- The encoding displayed
vim.opt.encoding = 'utf-8'
-- The encoding written to file
vim.opt.fileencoding = 'utf-8'
-- Enable the mouse
vim.opt.mouse = 'a'
-- Insert 2 spaces for a tab
vim.opt.tabstop = 2
-- Change the number of space characters inserted for indentation
vim.opt.shiftwidth = 2
-- Converts tabs to spaces
vim.opt.expandtab = true
-- Makes indenting smart
vim.opt.smartindent = true
-- Faster completion
vim.opt.updatetime = 300
-- Wait forever for mappings
vim.opt.timeout = false
-- Copy paste between vim and everything else
vim.opt.clipboard='unnamedplus'
-- Display long lines as just one line
vim.opt.wrap = false
-- Makes popup menu smaller
vim.opt.pumheight = 10
-- Enables syntax highlighing
vim.cmd 'syntax enable'
-- Show the cursor position all the time
vim.opt.ruler = true
-- More space for displaying messages
vim.opt.cmdheight = 2
-- Line numbers
vim.opt.number = false
vim.opt.relativenumber = false
-- Enable highlighting of the current line
vim.opt.cursorline = true
-- Always show tabs
vim.opt.showtabline = 2
-- We don't need to see things like -- INSERT -- anymore
vim.opt.showmode = false
-- Always show the signcolumn in the number column
vim.opt.signcolumn = 'yes'
-- Setting this fixed my tmux rendering issues :)
vim.opt.lazyredraw = true
-- Horizontal splits will automatically be below
vim.opt.splitbelow = true
-- Vertical splits will automatically be to the right
vim.opt.splitright = true
-- Break lines at word boundaries for readability
vim.opt.linebreak = true

vim.opt.bg = 'dark'

vim.opt.whichwrap='h,l'
-- keep cursor centered vertically while scrolling
vim.opt.scrolloff = 999
-- make minimum width for number column smallest value so it doesn't take up much room
vim.opt.numberwidth = 1
-- write to file often
vim.opt.autowrite = true

move_left = function()
  if vim.api.nvim_win_get_number(0) == vim.api.nvim_win_get_number('1h') then
    vim.cmd ':BufferLineCyclePrev'
  else
    vim.api.nvim_input '<C-w>h'
  end
end

move_right = function()
  if vim.api.nvim_win_get_number(0) == vim.api.nvim_win_get_number('1l') then
    vim.cmd ':BufferLineCycleNext'
  else
    vim.api.nvim_input '<C-w>l'
  end
end

map('n', '<c-j>', '<C-w>j')
map('n', '<c-k>', '<C-w>k')
map('n', '<c-h>', ':lua move_left()<cr>')
map('n', '<c-l>', ':lua move_right()<cr>')

-- Can't remap c-i? Weird
-- map('n', '<c-i>', ':tabnext<cr>')
map('n', '<c-t>', ':tabnew %<cr>')
map('n', '<c-y>', ':tabnext<cr>')

-- tab moves cursor 10 lines down, shift-tab 10 lines up
map('n', '<tab>', '10j')
map('n', '<s-tab>', '10k')

-- move through wrapped lines visually
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Make carriage return do nothing
map('n', '<cr>', '<nop>')

-- Auto complete
pum_tab_action = function()
  if vim.fn.pumvisible() == true then
    vim.api.nvim_input '<c-n>'
  else
    vim.api.nvim_input '<tab>'
  end
end

map('i', '<expr><tab>', '<cmd>:lua pum_tab_action()')

-- Text manipulation
map('x', 'K', ':move \'<-2<CR>gv-gv')
map('x', 'J', ':move \'>+1<CR>gv-gv')

-- Keeps selection active when indenting so you can do it multiple times quickly
map('x', '>', '>gv')
map('x', '<', '<gv')

-- Formatting
-- Number of lines formatting will affect by default, 0 is no limit
vim.g['clojure_maxlines'] = 0

-- Delete the current buffer, also avoid Ex mode
map('n', '<c-q>', ':wq<cr>')
-- Source config while inside Neovim (Doesn't work with NixOS setup)
map('n', '<c-s>', ':source ~/.config/nvim/init.lua<cr>:PackerCompile<cr>')
-- Open file explorer
map('n', '<c-n>', ':NvimTreeToggle<cr>')
-- Clear search highlighting
map('n', '<c-d>', ':let @/=""<cr>')
-- Open Git Fugitive, make it full window
map('n', '<c-g>', ':Git<cr>:only<cr>')
-- Remap visual block mode because I use <c-v> for paste
map('n', '<c-b>', '<c-v>')

-- Quickfix bindings
map('n', 'q', '<nop>') -- I don't use vim macros atm
map('n', 'qq', ':copen<cr>')
map('n', 'qw', ':cclose<cr>')
map('n', 'qe', ':.cc<cr>')


-- this makes it so vim will update a buffer if it has changed
-- on the filesystem when a FocusGained or BufEnter event happens
vim.cmd [[
autocmd FocusGained,BufEnter * :checktime
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s "change comment style for commentary.vim
autocmd FileType clojure setlocal commentstring=;;\ %s
autocmd FileType markdown setlocal wrap
]]

-- Terminal
map('t', '<esc>', '<c-\\><c-n>')

--Debugging syntax highlighting
map('n', '<f10>', ':echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . "> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>')
