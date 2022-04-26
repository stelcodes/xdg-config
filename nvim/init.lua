-----------------------------------------------------------------------------
-- GLOBAL FUNCTIONS

Map = function(mode, binding, action)
  vim.api.nvim_set_keymap(mode, binding, action, {noremap = true})
end

SubstituteYanked = function()
  vim.api.nvim_input(':%s/<c-r>\"//gc<left><left><left>')
end

-----------------------------------------------------------------------------
-- PLUGINS

require('packer').startup(function(use)

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'stelcodes/dracula.nvim',
    config = function()
      vim.cmd 'colorscheme dracula'
    end
  }

  use 'tpope/vim-fugitive'

  use {
    'olical/conjure',
    ft = {'clojure'},
    config = function()
      vim.g['conjure#mapping#prefix'] = ','
      vim.g['conjure#log#hud#width'] = 1
      vim.g['conjure#log#hud#height'] = 0.6
      vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
    end
  }

  use {
    'stelcodes/paredit',
    config = function()
      vim.g['paredit_smartjump'] = 1
      vim.g['paredit_matchlines'] = 500
    end
  }

  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- https://github.com/nvim-telescope/telescope.nvim#previewers
      local tele = require('telescope')
      local builtin = require('telescope.builtin')
      local opts = {
        jump_type = 'never', -- Never jump on LSP commands with one result
        show_untracked = false, -- For git_files command
        layout_strategy = 'vertical',
        layout_config = {
          width=0.95,
          preview_height = 0.75
        }
      }
      local wrap = function(fn) return function() fn(opts) end end
      FindFiles = wrap(builtin.find_files)
      tele.setup {
        defaults = {
          file_ignore_patterns = { '%.pdf', '%.db' },
          mappings = {
            n = {
              ['<c-f>'] = require('telescope.actions').file_vsplit
            }
          }
        }
      }
      vim.keymap.set('n', '<leader>f', wrap(builtin.find_files))
      vim.keymap.set('n', '<leader>r', wrap(builtin.live_grep))
      vim.keymap.set('n', '<leader>d', wrap(builtin.diagnostics))
      vim.keymap.set('n', '<leader>p', wrap(builtin.registers))
      vim.keymap.set('n', '<leader>m', wrap(builtin.marks))
      vim.keymap.set('n', '<leader>c', wrap(builtin.commands))
      vim.keymap.set('n', '<leader>h', wrap(builtin.help_tags))
      vim.keymap.set('n', '<leader>b', wrap(builtin.current_buffer_fuzzy_find))
      vim.keymap.set('n', '<leader>k', wrap(builtin.keymaps))
      vim.keymap.set('n', '<leader>t', wrap(builtin.builtin))
      vim.keymap.set('n', '<leader>gc', wrap(builtin.git_bcommits))
      vim.keymap.set('n', '<leader>gC', wrap(builtin.git_commits))
      vim.keymap.set('n', '<leader>gf', wrap(builtin.git_files))
      vim.keymap.set('n', '<leader>lr', wrap(builtin.lsp_references))
      vim.keymap.set('n', '<leader>la', wrap(builtin.lsp_code_actions))
      vim.keymap.set('n', '<leader>ls', wrap(builtin.lsp_document_symbols))
      vim.keymap.set('n', '<leader>li', wrap(builtin.lsp_implementations))
      vim.keymap.set('n', '<leader>ld', wrap(builtin.lsp_definitions))
      vim.keymap.set('n', '<leader>lt', wrap(builtin.lsp_type_definitions))
      vim.keymap.set('n', '<leader>lS', wrap(builtin.lsp_workspace_symbols))
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

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        -- Enable completion triggered by <c-x><c-o>
        bufoption('omnifunc', 'v:lua.vim.lsp.omnifunc')
        bufmap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
        bufmap('n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>')
        bufmap('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
        bufmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        bufmap('v', '<leader>lf', '<cmd>lua vim.lsp.buf.range_formatting({})<CR>')

        -- bufmap('n', '<leader>jd', '<cmd>tab split | lua vim.lsp.buf.definition()<cr>')
        -- bufmap('n', '<leader>ja', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        -- bufmap('n', '<leader>jr', '<cmd>lua vim.lsp.buf.references()<CR>')
        -- bufmap('n', '<leader>jw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        -- bufmap('n', '<leader>jI', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        -- bufmap('n', '<leader>jD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        -- bufmap('n', '<leader>jK', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        -- bufmap('n', '<leader>jT', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        -- bufmap('n' '<leader>ja', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        -- bufmap('n', '<leader>jr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        -- bufmap('n', '<leader>js', '<cmd>lua vim.diagnostic.setloclist()<CR>')
        -- bufmap('n', '<leader>jk', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
        -- bufmap('n', '<leader>jj', '<cmd>lua vim.diagnostic.goto_next()<CR>')
      end

      lspconfig.clojure_lsp.setup {
        on_attach = on_attach,
      }

      lspconfig.sumneko_lua.setup {
        on_attach = on_attach,
      }

      lspconfig.gopls.setup {
        on_attach = on_attach,
      }

      lspconfig.java_language_server.setup {
        on_attach = on_attach,
        cmd = { '/nix/store/4w5zsa97vjgmj1wg5jk7qxrpfgqqxffi-java-language-server-0.2.38/bin/java-language-server' },
      }

      lspconfig.sumneko_lua.setup {
        on_attach = on_attach,
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

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "single" }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "single" }
      )
    end
  }

  use {
    'euclio/vim-markdown-composer',
    run = 'cargo build --release --locked',
    config = function()
      vim.g['markdown_composer_syntax_theme'] = 'dark'
      vim.g['markdown_composer_open_browser'] = 0
      vim.g['markdown_composer_autostart'] = 0
    end
  }

  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.g['better_whitespace_guicolor'] = '#ff5555'
      vim.g['better_whitespace_filetypes_blacklist'] = {
        '', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive'
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
          Map('n', '<leader>gs', ':Gitsigns stage_hunk<cr>')
          Map('v', '<leader>gs', ':Gitsigns stage_hunk<cr>')
          Map('n', '<leader>gu', ':Gitsigns undo_stage_hunk<cr>')
          Map('n', '<leader>gr', ':Gitsigns reset_hunk<cr>')
          Map('v', '<leader>gr', ':Gitsigns reset_hunk<cr>')
          Map('n', '<leader>gR', ':Gitsigns reset_buffer<cr>')
          Map('n', '<leader>gp', ':Gitsigns preview_hunk<cr>')
          Map('n', '<leader>gb', ':lua require"gitsigns".blame_line{full=true}<cr>')
          Map('n', '<leader>gS', ':Gitsigns stage_buffer<cr>')
          Map('n', '<leader>gU', ':Gitsigns reset_buffer_index<cr>')
        end
      }
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
          exists = false,
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
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local buff = require('bufferline')
      buff.setup {
        options = {
          mode = 'tabs',
          sort_by = 'tabs'
        }
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        highlight = {
          enable = true,
          disable = { 'markdown' }
        },
        indent = {
          enable = true,
          disable = { 'yaml' }
        }
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

  use 'rodjek/vim-puppet'

  use 'bakpakin/fennel.vim'

  use 'Olical/aniseed'

  use {
    'cuducos/yaml.nvim',
    ft = {'yaml'}, -- optional
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim' -- optional
    },
  }

  -- TODO https://github.com/hrsh7th/nvim-cmp

end)

----------------------------------------------------------------------------------
-- OPTIONS

vim.cmd 'filetype plugin indent on'
-- Preview pane for substitution
vim.opt.inccommand = 'split'

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
-- Have dark background by default
vim.opt.bg = 'dark'
-- Allow left/right scrolling to jump lines
vim.opt.whichwrap='h,l'
-- keep cursor centered vertically while scrolling
vim.opt.scrolloff = 999
-- make minimum width for number column smallest value so it doesn't take up much room
vim.opt.numberwidth = 1
-- write to file often
vim.opt.autowrite = true
-- enable full color support
vim.opt.termguicolors = true

----------------------------------------------------------------------------------------
-- GLOBALS

vim.g['clojure_fuzzy_indent_patterns'] = {'^with', '^def', '^let', '^try', '^do$'}
vim.g['clojure_special_indent_words'] = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn,do'
vim.g['clojure_align_multiline_strings'] = 0
vim.g['clojure_align_subforms'] = 1
-- Number of lines formatting will affect by default, 0 is no limit
vim.g['clojure_maxlines'] = 0

----------------------------------------------------------------------------------------
-- MAPPINGS

-- LEADER
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
Map('n', '<Space>', '<Nop>')
Map('x', '<leader>', '<Nop>')

-- TEXT MANIPULATION
-- Yank word under cursor
Map('n', 'Y', 'viwy')
-- Start substition of text in first register
Map('n', 'U', '<cmd>lua SubstituteYanked()<CR>')

-- BUFFERS
Map('n', 'B', '<cmd>BufferLineSortByTabs<cr>')
Map('n', 'N', '<cmd>BufferLineCyclePrev<cr>')
Map('n', 'M', '<cmd>BufferLineCycleNext<cr>')

-- WINDOWS
-- Navigate windows by direction
Map('n', '<c-j>', '<C-w>j')
Map('n', '<c-k>', '<C-w>k')
Map('n', '<c-h>', '<c-w>h')
Map('n', '<c-l>', '<c-w>l')
-- Quit the current window, also avoid Ex mode
Map('n', '<c-q>', '<c-w>q')

-- TABS
-- Navigate tabs
Map('n', 'T', '<cmd>tabnew %<cr>')
-- Avoid ex mode and close tab
Map('n', 'Q', '<cmd>tabclose<cr>')
Map('n', 'H', '<cmd>tabprevious<cr>')
Map('n', 'L', '<cmd>tabnext<cr>')
-- Move tabs
Map('n', '<c-left>', '<cmd>tabmove -1<cr>')
Map('n', '<c-right>', '<cmd>tabmove +1<cr>')

-- SCROLLING
-- tab moves cursor 10 lines down, shift-tab 10 lines up
Map('n', '<tab>', '10j')
Map('n', '<s-tab>', '10k')
-- move through wrapped lines visually
Map('n', 'j', 'gj')
Map('n', 'k', 'gk')

-- Make carriage return do nothing
Map('n', '<cr>', '<nop>')

-- SELECTIONS
-- Text manipulation
Map('x', 'K', ':move \'<-2<CR>gv-gv')
Map('x', 'J', ':move \'>+1<CR>gv-gv')
-- Keeps selection active when indenting so you can do it multiple times quickly
Map('x', '>', '>gv')
Map('x', '<', '<gv')

-- QUICKFIX
Map('n', 'q', '<nop>') -- I don't use vim macros atm
Map('n', 'qq', ':copen<cr>')
Map('n', 'qw', ':cclose<cr>')
Map('n', 'qe', ':.cc<cr>')

-- OTHER STUFF
-- Source config while inside Neovim (Doesn't work with NixOS setup)
Map('n', '<c-s>', ':source ~/.config/nvim/init.lua<cr>:PackerCompile<cr>')
-- Open file explorer
Map('n', '<c-n>', ':NvimTreeToggle<cr>')
-- Clear search highlighting
Map('n', '<c-d>', ':let @/=""<cr>')
-- Open Git Fugitive, make it full window in a new tab positioned before other tabs
Map('n', '<c-g>', ':tabnew<cr>:Git<cr>:only<cr>:tabmove 0<cr>:BufferLineSortByTabs<cr>')
-- Remap visual block mode because I use <c-v> for paste
Map('n', '<c-b>', '<c-v>')
-- Make terminal mode easy to exit
Map('t', '<esc>', '<c-\\><c-n>')
--Debugging syntax highlighting
Map('n', '<f10>', ':echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . "> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>')

---------------------------------------------------------------------------------
-- EVENT BASED COMMANDS

vim.cmd [[
" Update a buffer if it has changed when a FocusGained or BufEnter event happens
autocmd FocusGained,BufEnter * :checktime
" Change comment styles for commentary.vim
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
autocmd FileType clojure setlocal commentstring=;;\ %s
" Wrap text for certain filetypes
autocmd FileType markdown setlocal wrap
]]

