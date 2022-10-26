-----------------------------------------------------------------------------
-- GLOBAL FUNCTIONS

SubstituteYanked = function()
  vim.api.nvim_input(':%s/<c-r>\"//gc<left><left><left>')
end

SearchWord = function()
  vim.api.nvim_input('viwy/<c-r>\"<cr>N')
end

-----------------------------------------------------------------------------
-- PLUGINS

-- For bootstrapping Packer
-- https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')
packer.startup(function(use)

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
      vim.g['conjure#eval#gsubs'] = {
        ['do-comment'] = {'^%(comment[%s%c]', '(do '}
      }
      vim.g['conjure#eval#result_register'] = '*'
    end
  }

  use {
    'kovisoft/paredit',
    config = function()
      vim.g['paredit_smartjump'] = 1
      vim.g['paredit_matchlines'] = 500
    end
  }

  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      -- https://github.com/nvim-telescope/telescope.nvim#previewers
      local tele = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local find_system_files = function()
        builtin.find_files {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
          search_dirs = {'/etc', '/home'}
        }
      end
      tele.setup {
        defaults = {
          file_ignore_patterns = {
            '%.pdf$', '%.db$', '%.opus$', '%.mp3$', '%.wav$', '%.git/', '%.clj%-kondo/%.cache/', '%.lsp/', '%.cpcache/',
            '%target/'
          },
          mappings = {
            -- I use ctrl-v in terminal for paste so use ctrl-f for vsplit
            n = { ['<c-f>'] = actions.file_vsplit }
          },
          show_untracked = false, -- For git_files command
          layout_strategy = 'vertical',
          layout_config = {
            height=0.99,
            width=0.95,
            preview_height = 0.6,
            -- Always show preview
            preview_cutoff = 0
          },
          -- Add hidden flag for grep to search hidden flag.
          vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden'
          }
        }
      }
      tele.load_extension('fzf')
      tele.load_extension('ui-select')
      vim.keymap.set('n', '<leader>f', builtin.find_files)
      vim.keymap.set('n', '<leader>F', find_system_files)
      vim.keymap.set('n', '<leader>r', function() builtin.live_grep {hidden = true} end)
      vim.keymap.set('n', '<leader>d', builtin.diagnostics)
      vim.keymap.set('n', '<leader>p', builtin.registers)
      vim.keymap.set('n', '<leader>m', builtin.marks)
      vim.keymap.set('n', '<leader>c', builtin.commands)
      vim.keymap.set('n', '<leader>h', builtin.help_tags)
      vim.keymap.set('n', '<leader>b', builtin.current_buffer_fuzzy_find)
      vim.keymap.set('n', '<leader>k', builtin.keymaps)
      vim.keymap.set('n', '<leader>t', builtin.builtin)
      vim.keymap.set('n', '<leader>gc', builtin.git_bcommits)
      vim.keymap.set('n', '<leader>gC', builtin.git_commits)
      vim.keymap.set('n', '<leader>gf', builtin.git_files)
      vim.keymap.set('n', '<leader>gd', builtin.git_status)
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references)
      vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols)
      -- Add jump_type=never option to still show telescope window when only one result
      vim.keymap.set('n', '<leader>li', function() builtin.lsp_implementations { jump_type = 'never' } end)
      vim.keymap.set('n', '<leader>ld', function() builtin.lsp_definitions { jump_type = 'never' } end)
      vim.keymap.set('n', '<leader>lt', function() builtin.lsp_type_definitions { jump_type = 'never' } end)
      vim.keymap.set('n', '<leader>lS', builtin.lsp_workspace_symbols)
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
      local on_attach = function()
        vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, { buffer = 0 })
        vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, { buffer = 0 })
        vim.keymap.set('n', '<leader>ll', vim.diagnostic.open_float, { buffer = 0 })
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting, { buffer = 0 })
        vim.keymap.set('v', '<leader>lf', function() vim.lsp.buf.range_formatting({}) end, { buffer = 0 })

        -- Add borders to :LspInfo floating window
        -- https://neovim.discourse.group/t/lspinfo-window-border/1566/2
        local win = require('lspconfig.ui.windows')
        local _default_opts = win.default_opts
        win.default_opts = function(options)
          local opts = _default_opts(options)
          opts.border = 'single'
          return opts
        end

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

      -- pip install --user python-lsp-server
      -- lspconfig.pylsp.setup {
      --   on_attach = on_attach,
      -- }

      -- nix-env -iA nixpkgs.pyright
      -- npm install -g pyright
      lspconfig.pyright.setup {
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
    'iamcco/markdown-preview.nvim',
    run = 'cd app && npm install',
    setup = function() vim.g.mkdp_filetypes = { 'markdown' } end,
    ft = { 'markdown' }
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
          local gs = require('gitsigns')
          -- the :w is so fugitive will pick up the staging changes
          vim.keymap.set({'n','v'}, '<leader>gs', gs.stage_hunk)
          vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk)
          vim.keymap.set({'n', 'v'}, '<leader>gr', gs.reset_hunk)
          vim.keymap.set('n', '<leader>gR', gs.reset_buffer)
          vim.keymap.set('n', '<leader>gp', gs.preview_hunk)
          vim.keymap.set('n', '<leader>gn', gs.next_hunk)
          vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end)
          vim.keymap.set('n', '<leader>gS', gs.stage_buffer)
          vim.keymap.set('n', '<leader>gU', gs.reset_buffer_index)
          vim.keymap.set('n', '<leader>gq', gs.setqflist)
        end
      }
    end
  }

  use {
    'Pocco81/auto-save.nvim',
    config = function()
      require("auto-save").setup {
        enabled = true,
        events = {"InsertLeave", "TextChanged"},
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
          separator_style = 'slant',
          sort_by = 'tabs'
        }
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    -- Too many errors! Every time!
    -- run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        highlight = {
          enable = true,
          disable = { 'markdown', 'markdown-inline' }
        },
        indent = {
          enable = true,
          disable = { 'yaml', 'markdown', 'markdown-inline' }
        }
      }
      vim.cmd [[
        " Use builtin markdown folding
        let g:markdown_folding = 1
        set foldlevelstart=1
        " set foldmethod=expr
        " set foldexpr=nvim_treesitter#foldexpr()
      ]]
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require'nvim-tree'.setup {
        update_focused_file = {
          enable = true
        },
        view = {
          float = {
            enable = true,
            open_win_config = {
              relative = "editor",
              border = "rounded",
              width = 60,
              height = 30,
              row = 1,
              col = 1,
            }
          }
        }
      }
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
      local ft = require('Comment.ft')
      ft.set('clojure', ';; %s')
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

  use 'lambdalisue/suda.vim'

  use 'fladson/vim-kitty'

  use {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup {
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_vheight = 999,
          win_height = 999
        }
      }
    end
  }

  use {
    'tpope/vim-eunuch',
    config = function()
      local delete_eunuch_cmds = function()
        vim.cmd 'delcommand SudoEdit'
        vim.cmd 'delcommand SudoWrite'
      end
      vim.api.nvim_create_autocmd({'VimEnter'}, {
        callback = delete_eunuch_cmds
      })
    end
  }

  -- TODO https://github.com/hrsh7th/nvim-cmp

  -- Automatically set up your configuration after cloning packer.nvim
  -- Must be ran after all plugins are defined
  if packer_bootstrap then
    packer.sync()
  end

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
vim.opt.cursorline = false
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
-- ignore case when searching
vim.opt.ignorecase = true
-- don't ignore case when searching with capital letters
vim.opt.smartcase = true

----------------------------------------------------------------------------------------
-- GLOBALS

vim.g['clojure_fuzzy_indent_patterns'] = {'^with', '^def', '^let', '^try', '^do'}
vim.g['clojure_align_multiline_strings'] = 0
vim.g['clojure_align_subforms'] = 1
-- Number of lines formatting will affect by default, 0 is no limit
vim.g['clojure_maxlines'] = 0

----------------------------------------------------------------------------------------
-- MAPPINGS

-- LEADER
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<Space>', '<Nop>')
vim.keymap.set('x', '<leader>', '<Nop>')

-- TEXT MANIPULATION
-- Yank word under cursor
vim.keymap.set('n', 'Y', 'viwy')
vim.keymap.set('n', 'U', SearchWord)
-- Start substition of text in first register
vim.keymap.set('n', 'R', SubstituteYanked)

-- WINDOWS
-- Navigate windows by direction
vim.keymap.set('n', '<c-j>', '<C-w>j')
vim.keymap.set('n', '<c-k>', '<C-w>k')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')
-- Quit the current window, also avoid Ex mode
vim.keymap.set('n', '<c-q>', '<c-w>q')

-- TABS
-- Navigate tabs
vim.keymap.set('n', 't', '<cmd>tabnew<cr>')
vim.keymap.set('n', 'T', '<cmd>tabnew<cr><cmd>terminal fish<cr>')
vim.keymap.set('n', 'H', '<cmd>tabprevious<cr>')
vim.keymap.set('n', 'L', '<cmd>tabnext<cr>')
-- Move tabs
vim.keymap.set('n', '<c-left>', '<cmd>tabmove -1<cr>')
vim.keymap.set('n', '<c-right>', '<cmd>tabmove +1<cr>')

-- SCROLLING
-- tab moves cursor 10 lines down, shift-tab 10 lines up
vim.keymap.set('n', '<tab>', '10j')
vim.keymap.set('n', '<s-tab>', '10k')
-- move through wrapped lines visually
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('x', 'j', 'gj')
vim.keymap.set('x', 'k', 'gk')

-- Make carriage return do nothing
vim.keymap.set('n', '<cr>', '<nop>')
-- Avoid ex mode
vim.keymap.set('n', 'Q', '<nop>')

-- SELECTIONS
-- Text manipulation
vim.keymap.set('x', 'K', ':move \'<-2<CR>gv-gv')
vim.keymap.set('x', 'J', ':move \'>+1<CR>gv-gv')
-- Keeps selection active when indenting so you can do it multiple times quickly
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', '<', '<gv')

-- QUICKFIX
vim.keymap.set('n', 'q', '<nop>') -- I don't use vim macros atm
vim.keymap.set('n', 'qq', ':copen<cr>')
vim.keymap.set('n', 'qw', ':cclose<cr>')
vim.keymap.set('n', 'qe', ':.cc<cr>')

-- OTHER STUFF
-- Copy relative path of file
vim.keymap.set('n', 'f', ':let @+=expand("%")<cr>:echo expand("%")<cr>')
-- Copy absolute path of file
vim.keymap.set('n', 'F', ':let @+=expand("%:p")<cr>:echo expand("%:p")<cr>')
-- Source config while inside Neovim (Doesn't work with NixOS setup)
vim.keymap.set('n', 'r', ':source ~/.config/nvim/init.lua<cr>:PackerCompile<cr>')
-- Open file explorer
vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<cr>')
-- Clear search highlighting
vim.keymap.set('n', '<c-/>', ':let @/=""<cr>')
vim.keymap.set('i', '<c-/>', ':let @/=""<cr>')
-- Open Git Fugitive, make it full window in a new tab positioned before other tabs
vim.keymap.set('n', '<c-g>', ':tabnew<cr>:Git<cr>:only<cr>:tabmove 0<cr>:BufferLineSortByTabs<cr>')
-- Remap visual block mode because I use <c-v> for paste
vim.keymap.set('n', '<c-b>', '<c-v>')
-- Make terminal mode easy to exit
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
--Debugging syntax highlighting
vim.keymap.set('n', '<f10>', ':echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . "> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>')
-- Toggle wrap
vim.keymap.set('n', '<c-w>', ':set wrap!<cr>')
-- Toggle spell
vim.keymap.set('n', '<c-s>', ':set spell!<cr>')

---------------------------------------------------------------------------------
-- EVENT BASED COMMANDS

vim.cmd [[
augroup init
  " Remove all autocommands to prevent duplicates on config reload
  autocmd!
  " Update a buffer if it has changed when a FocusGained or BufEnter event happens
  autocmd FocusGained,BufEnter * checktime
  " Wrap text for certain filetypes
  autocmd FileType markdown setlocal wrap
  " Option sort_by = 'tabs' isn't working. This is a workaround.
  autocmd TabNew * BufferLineSortByTabs
  " Keep gitsigns line indicators up to date
  autocmd FocusGained,BufEnter * Gitsigns refresh
augroup END
]]

