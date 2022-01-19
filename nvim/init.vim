"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'olical/conjure'
Plug 'stelcodes/paredit'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release --locked' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'Mofiqul/dracula.nvim'
Plug 'Pocco81/AutoSave.nvim'
Plug 'akinsho/bufferline.nvim'
" :TSInstallInfo to list langs, :TSInstall <lang> to get lang support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'kyazdani42/nvim-tree.lua'
Plug 'rmagatti/auto-session'
Plug 'numToStr/Comment.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
" :ColorizerAttachToBuffer
Plug 'norcalli/nvim-colorizer.lua'
call plug#end()


lua << EOF
local map = vim.api.nvim_set_keymap
local map_opts = { noremap = true }

vim.g['markdown_composer_syntax_theme'] = 'dark'
vim.g['paredit_smartjump'] = 1
vim.g['better_whitespace_guicolor'] = '#ff5555'
vim.g['markdown_composer_open_browser'] = 0

-- Find files using Telescope command-line sugar.
map('n', '<c-f>', '<cmd>Telescope find_files<cr>', map_opts)
map('n', '<c-r>', '<cmd>Telescope live_grep<cr>', map_opts)

vim.g['conjure#log#hud#width'] = 1
vim.g['conjure#log#hud#height'] = 0.6
vim.g['clojure_fuzzy_indent_patterns'] = {'^with', '^def', '^let', '^try', '^do$'}
vim.g['clojure_special_indent_words'] = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn,do'
vim.g['clojure_align_multiline_strings'] = 0
vim.g['clojure_align_subforms'] = 1

-- https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n' '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('v', '<space>f', '<cmd>lua vim.lsp.buf.range_formatting({})<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { 'clojure_lsp' }
local servers = { 'clojure_lsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

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
  extensions = {'nerdtree'}
}

require("bufferline").setup{}

require('gitsigns').setup()

-- :ASToggle
require("autosave").setup(
    {
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
)

require'nvim-tree'.setup {}

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
require('auto-session').setup()

require('Comment').setup()

require("indent_blankline").setup {}

require 'colorizer'.setup{
  "css"
}

----------------------------------------------------------------------------------

vim.cmd 'colorscheme dracula'

-- Leader

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map('n', '<Space>', '<Nop>', map_opts)
map('x', '<leader>', '<Nop>', map_opts)


-- Substitution
-- Preview pane for substitution
vim.opt.inccommand = 'split'

local start_substitution = function()
  vim.api.nvim_input(':%s/<c-r>\"//gc<left><left><left>')
end

map('n', '<leader>y', 'viwy', map_opts)
map('n', '<leader>u', '<cmd>lua start_substitution()<CR>', map_opts)

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
-- enable full color support
vim.opt.termguicolors = true
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
    nvim.api.nvim_input '<Esc><C-w>h'
  end
end

move_right = function()
  if vim.api.nvim_win_get_number(0) == vim.api.nvim_win_get_number('1l') then
    vim.cmd ':BufferLineCycleNext'
  else
    nvim.api.nvim_input '<Esc><C-w>l'
  end
end

map('n', '<c-j>', '<C-w>j', map_opts)
map('n', '<c-k>', '<C-w>k', map_opts)
map('n', '<c-h>', ':lua move_left()<cr>', map_opts)
map('n', '<c-l>', ':lua move_right()<cr>', map_opts)


-- tab moves cursor 10 lines down, shift-tab 10 lines up
map('n', '<tab>', '10j', map_opts)
map('n', '<s-tab>', '10k', map_opts)

-- move through wrapped lines visually
map('n', 'j', 'gj', map_opts)
map('n', 'k', 'gk', map_opts)

-- Make carriage return do nothing
map('n', '<cr>', '<nop>', map_opts)

-- Auto complete
local pum_tab_action = function()
  if vim.fn.pumvisible() == true then
    vim.api.nvim_input '<c-n>'
  else
    vim.api.nvim_input '<tab>'
  end
end

map('i', '<expr><tab>', '<cmd>:lua pum_tab_action()', map_opts)

-- Text manipulation
map('x', 'K', ':move \'<-2<CR>gv-gv', map_opts)
map('x', 'J', ':move \'>+1<CR>gv-gv', map_opts)

-- Keeps selection active when indenting so you can do it multiple times quickly
map('v', '>', '>gv', map_opts)
map('v', '<', '<gv', map_opts)

-- Formatting
-- Number of lines formatting will affect by default, 0 is no limit
vim.g['clojure_maxlines'] = 0

-- Delete the current buffer, also avoid Ex mode
map('n', '<c-q>', ':bd<cr>', map_opts)
-- Source config while inside Neovim (Doesn't work with NixOS setup)
map('n', '<c-s>', ':source ~/.config/nvim/init.vim<cr>', map_opts)
-- Open file explorer
map('n', '<c-n>', ':NvimTreeToggle<cr>', map_opts)
-- Clear search highlighting
map('n', '<c-d>', ':let @/=""<cr>', map_opts)
-- Open Git Fugitive, make it full window
map('n', '<c-g>', ':Git<cr>:only<cr>', map_opts)
-- Remap visual block mode because I use <c-v> for paste
map('n', '<c-b>', '<c-v>', map_opts)

-- this makes it so vim will update a buffer if it has changed
-- on the filesystem when a FocusGained or BufEnter event happens
vim.cmd [[
  autocmd FocusGained,BufEnter * :checktime
  autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s "change comment style for commentary.vim
  autocmd FileType clojure setlocal commentstring=;;\ %s
  autocmd FileType markdown setlocal wrap
]]

-- Terminal
map('t', '<esc>', '<c-\\><c-n>', map_opts)

--Debugging syntax highlighting
map('n', '<f10>', ':echok"hi<" . synIDattr(synID(line("."),col("."),1),"name") . "> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>r', map_opts)

EOF



