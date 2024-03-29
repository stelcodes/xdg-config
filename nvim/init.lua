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

  -- use {
  --   'Mofiqul/dracula.nvim',
  --   config = function()
  --     vim.cmd 'colorscheme dracula'
  --   end
  -- }

  use {
    --  '/home/stel/code/hydropump.nvim',
    'stelcodes/hydropump.nvim',
    config = function()
      vim.cmd 'colorscheme hydropump'
    end
  }

  -- TODO: write hydrangea.nvim plugin based on dracula.nvim
  -- use {
  --   'yuttie/hydrangea-vim',
  --   config = function()
  --     vim.cmd 'colorscheme hydrangea'
  --   end
  -- }

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
      'nvim-telescope/telescope-ui-select.nvim',
      -- 'nvim-telescope/telescope-file-browser.nvim',
      { "stelcodes/telescope-file-browser.nvim", branch = "create-trash-action"}
    },
    config = function()
      -- https://github.com/nvim-telescope/telescope.nvim#previewers
      local tele = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local browser = tele.extensions.file_browser

      local find_files_from_root = function()
        builtin.find_files {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
          search_dirs = {'/etc', '/home', '/usr'}
        }
      end
      local browse_notes = function()
        browser.file_browser {
          hidden = false,
          respect_gitignore = false,
          path = '/home/stel/sync/notes'
        }
      end
      local git_status = function()
        builtin.git_status({ default_text = vim.fn.expand('%:t'), initial_mode = "normal"})
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
          layout_strategy = 'flex',
          layout_config = {
            height=0.99,
            width=0.95,
            flex = {
              flip_columns = 120,
              flip_lines = 20,
            },
            horizontal = {
              preview_width = 0.6,
              -- Always show preview
              preview_cutoff = 0
            },
            vertical = {
              preview_height = 0.6,
              -- Always show preview
              preview_cutoff = 0
            }
          },
          -- Add hidden flag for grep to search hidden flag.
          vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden'
          }
        },
        extensions = {
          file_browser = {
            -- Open file browser in directory of currently focused file
            hidden = true,
            path = "%:p:h",
            initial_mode = "normal",
            mappings = {
              n = {
                h = browser.actions.goto_parent_dir,
                l = actions.select_default,
                d = browser.actions.trash,
                -- to match nnn
                n = browser.actions.create,
                -- x = trash_browser_selection,
                x = browser.actions.trash,
                t = actions.file_tab,
                ['.'] = browser.actions.toggle_hidden
              }
            }
          }
        }
      }
      tele.load_extension('ui-select')
      tele.load_extension('file_browser')
      vim.keymap.set('n', '<leader>ff', builtin.find_files)
      vim.keymap.set('n', '<leader>fb', browser.file_browser)
      vim.keymap.set('n', '<leader>fr', find_files_from_root)
      vim.keymap.set('n', '<leader>fn', browse_notes)
      vim.keymap.set('n', '<leader>r', function() builtin.live_grep {hidden = true} end)
      vim.keymap.set('n', '<leader>d', builtin.diagnostics)
      vim.keymap.set('n', '<leader>p', builtin.registers)
      vim.keymap.set('n', '<leader>m', builtin.marks)
      vim.keymap.set('n', '<leader>c', builtin.commands)
      vim.keymap.set('n', '<leader>o', function() builtin.colorscheme {enable_preview = true} end)
      vim.keymap.set('n', '<leader>h', builtin.help_tags)
      vim.keymap.set('n', '<leader>b', builtin.current_buffer_fuzzy_find)
      vim.keymap.set('n', '<leader>k', builtin.keymaps)
      vim.keymap.set('n', '<leader>t', builtin.builtin)
      vim.keymap.set('n', '<leader>gc', builtin.git_bcommits)
      vim.keymap.set('n', '<leader>gC', builtin.git_commits)
      vim.keymap.set('n', '<leader>gf', builtin.git_files)
      vim.keymap.set('n', '<leader>gd', builtin.git_status)
      vim.keymap.set('n', '<leader>gd', git_status)
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
        vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { buffer = 0 })
        vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, { buffer = 0 })
        vim.keymap.set('n', '<leader>ll', vim.diagnostic.open_float, { buffer = 0 })
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting, { buffer = 0 })
        vim.keymap.set('v', '<leader>lf', function() vim.lsp.buf.range_formatting({}) end, { buffer = 0 })

        -- Add borders to :LspInfo floating window
        -- https://neovim.discourse.group/t/lspinfo-window-border/1566/2
        require('lspconfig.ui.windows').default_options.border = 'rounded'

      end

      lspconfig.clojure_lsp.setup {
        on_attach = on_attach,
      }

      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
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
        { border = "rounded" }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
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
          theme = 'hydropump',
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
        -- extensions = {'nvim-tree'}
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
          vim.keymap.set('n', '<leader>gp', gs.prev_hunk)
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
          separator_style = 'thin',
          sort_by = 'tabs'
        }
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = { 'nvim-treesitter/playground' },
    -- Too many errors! Every time!
    -- run = ':TSUpdate',
    -- https://www.reddit.com/r/neovim/comments/y5rofg/recent_treesitter_update_borked_highlighting/
    commit = '4cccb6f494eb255b32a290d37c35ca12584c74d0',
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- ensure_installed = "all",
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        }
      }
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = false
      vim.opt.foldmethod = 'expr'
      vim.cmd 'set foldexpr=nvim_treesitter#foldexpr()'
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
      -- Change to true for whitespace symbols
      vim.opt.list = false
      vim.opt.listchars:append "space:⋅"
      vim.opt.listchars:append "eol:↴"
      vim.opt.listchars:append "tab:»»"
      -- require("indent_blankline").setup {
      --   show_end_of_line = true,
      --   space_char_blankline = " ",
      -- }
    end
  }

  -- :ColorizerAttachToBuffer
  use {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup {
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = false, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = false, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
          virtualtext = "■",
        },
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

  use {
    'L3MON4D3/LuaSnip',
    requires = {
      'rafamadriz/friendly-snippets'
    },
    config = function()
      local ls = require "luasnip"
      local types = require "luasnip.util.types"

      ls.config.set_config {
        -- This tells LuaSnip to remember to keep around the last snippet.
        -- You can jump back into it even if you move outside of the selection
        history = true,

        -- This one is cool cause if you have dynamic snippets, it updates as you type!
        updateevents = "TextChanged,TextChangedI",

        -- Autosnippets:
        enable_autosnippets = true,

        -- Crazy highlights!!
        -- #vid3
        -- ext_opts = nil,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " « ", "NonTest" } },
            },
          },
        },
      }
      vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      -- <c-j> is my jump backwards key.
      -- this always moves to the previous item within the snippet
      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      -- Load vs_code snippets from plugins
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim'
    },
    config = function()
      local lspkind = require('lspkind')
      lspkind.init()
      local cmp = require('cmp')
      cmp.setup {
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<c-y>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            { "i", "c" }
          ),
          ["<c-space>"] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(
              _ --[[fallback]]
            )
              if cmp.visible() then
                if not cmp.confirm { select = true } then
                  return
                end
              else
                cmp.complete()
              end
            end,
          },
          ["<tab>"] = cmp.config.disable,
          -- Testing
          ["<c-q>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
        },

        sources = {
          { name = "gh_issues" },

          -- Youtube: Could enable this only for lua, but nvim_lua handles that already.
          { name = "nvim_lua" },

          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 5 },
        },

        sorting = {
          -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        -- Youtube: mention that you need a separate snippets plugin
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        formatting = {
          -- Youtube: How to set up nice formatting for your sources.
          format = lspkind.cmp_format {
            with_text = true,
            menu = {
              buffer = "[buf]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[api]",
              path = "[path]",
              luasnip = "[snip]",
              gh_issues = "[issues]",
              tn = "[TabNine]",
            },
          },
        },

        experimental = {
          -- I like the new menu better! Nice work hrsh7th
          native_menu = false,

          -- Let's play with this for a day or two
          ghost_text = false,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }

    end
  }

  use {
    "luukvbaal/nnn.nvim",
    config = function()
      local nnn = require("nnn")
      nnn.setup({
        explorer = {
          session = "shared",
          fullscreen = false,
        },
        picker = {
          cmd = 'nnn -aeuUA',
          -- cmd = 'tmux new-session nnn -a -Pp'
          style = {
            width = 0.9, -- percentage relative to terminal size when < 1, absolute otherwise
            height = 0.8, -- ^
            border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
          },
          session = "shared",
          fullscreen = false,
        },
        mappings = {
          { "<C-t>", nnn.builtin.open_in_tab },       -- open file(s) in tab
          { "<C-s>", nnn.builtin.open_in_split },     -- open file(s) in split
          { "<C-v>", nnn.builtin.open_in_vsplit },    -- open file(s) in vertical split
          { "<C-p>", nnn.builtin.open_in_preview },   -- open file in preview split keeping nnn focused
          { "<C-y>", nnn.builtin.copy_to_clipboard }, -- copy file(s) to clipboard
          -- { "<C-w>", nnn.builtin.cd_to_path },        -- cd to file directory
          { "<C-e>", nnn.builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
          { "<C-q>", function() vim.cmd "close" end },  -- doesn't work?
        },
      })
      vim.keymap.set('n', 't', function()
        vim.cmd "NnnPicker"
      end)
    end
  }

  use 'jamespeapen/swayconfig.vim'

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
vim.keymap.set('t', '<c-q>', '<esc><c-w>q')

-- TABS
-- Navigate tabs
vim.keymap.set('n', 'T', '<cmd>tabnew<cr><cmd>terminal fish<cr>')
vim.keymap.set('n', 'H', '<cmd>tabprevious<cr>')
vim.keymap.set('n', 'L', '<cmd>tabnext<cr>')
-- Move tabs
vim.keymap.set('n', '<c-left>', '<cmd>tabmove -1<cr>')
vim.keymap.set('n', '<c-right>', '<cmd>tabmove +1<cr>')
-- Open new tab with clone of current buffer
vim.keymap.set('n', '<c-t>', function() vim.cmd "tab split" end)

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
-- Clear search highlighting
vim.keymap.set('n', '<c-/>', ':let @/=""<cr>')
vim.keymap.set('i', '<c-/>', ':let @/=""<cr>')
-- Open Git Fugitive, make it full window in a new tab positioned before other tabs
vim.keymap.set('n', '<c-g>', ':tabnew<cr>:Git<cr>:only<cr>:tabmove 0<cr>:BufferLineSortByTabs<cr>')
-- Remap visual block mode because I use <c-v> for paste
vim.keymap.set('n', '<c-b>', '<c-v>')
-- Make terminal mode easy to exit
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
vim.keymap.set('t', '<c-q>', 'q')
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
  " autocmd TabNew * BufferLineSortByTabs
  " Keep gitsigns line indicators up to date
  " autocmd FocusGained,BufEnter * Gitsigns refresh
augroup END
]]

