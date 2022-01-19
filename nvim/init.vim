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

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin config

let g:markdown_composer_syntax_theme = 'dark'

colorscheme dracula

let g:paredit_smartjump=1
let g:better_whitespace_guicolor='#ff5555'
let g:markdown_composer_open_browser=0
" Find files using Telescope command-line sugar.
nnoremap F <cmd>Telescope find_files<cr>
nnoremap R <cmd>Telescope live_grep<cr>
nnoremap B <cmd>Telescope buffers<cr>

let g:conjure#log#hud#width = 1
let g:conjure#log#hud#height = 0.6

let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^try', '^do$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn,do'
let g:clojure_align_multiline_strings = 0
let g:clojure_align_subforms = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP Config
" https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion

lua << END
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
END

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader

let mapleader=" "
let maplocalleader=" "
nnoremap <Space> <Nop>
xnoremap <leader> <Nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Substitution

" preview pane
set icm=split

nnoremap <leader>y viwy
nnoremap <leader>u :call StartSubstitution()<CR>

function! StartSubstitution()
  call nvim_input(":%s/<C-r>\"//gc<left><left><left>")
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
" From vim-sensible
filetype plugin indent on
syntax enable
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set incsearch
set laststatus=2
set ruler
set wildmenu
set scrolloff=1
set sidescrolloff=5
set display+=lastline
set autoread
set formatoptions+=j " Delete comment character when joining commented lines
set history=1000
set tabpagemax=50
" save undo history
set undofile
" treat dash separated words as a word text object
set iskeyword+=-
" Stop newline continution of comments
set formatoptions-=cro
" Required to keep multiple buffers open
set hidden
" The encoding displayed
set encoding=utf-8
" The encoding written to file
set fileencoding=utf-8
" Disable the mouse
set mouse+=a
" Insert 2 spaces for a tab
set tabstop=2
" Change the number of space characters inserted for indentation
set shiftwidth=2
" Converts tabs to spaces
set expandtab
" Makes indenting smart
set smartindent
" Faster completion
set updatetime=300
" Wait forever fo mappings
set notimeout
" Copy paste between vim and everything else
set clipboard=unnamedplus
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visuals

" Display long lines as just one line
set nowrap
" Makes popup menu smaller
set pumheight=10
" Enables syntax highlighing
syntax enable
" Show the cursor position all the time
set ruler
" More space for displaying messages
set cmdheight=2
" Line numbers
set nonumber
set norelativenumber
" Enable highlighting of the current line
set cursorline
" Always show tabs
set showtabline=2
" We don't need to see things like -- INSERT -- anymore
set noshowmode
" enable full color support
set termguicolors
" Always show the signcolumn in the number column
set signcolumn=yes
" Setting this fixed my tmux rendering issues :)
set lazyredraw
" Horizontal splits will automatically be below
set splitbelow
" Vertical splits will automatically be to the right
set splitright
" Break lines at word boundaries for readability
set linebreak
set bg=dark
" set t_ut=
" set term=screen-256color
set whichwrap=h,l
" keep cursor centered vertically while scrolling
set scrolloff=999
" make minimum width for number column smallest value so it doesn't take up much room
set numberwidth=1
" write to file often
set autowrite
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigating

" stel's original window navigation solution
" ctrl-[hjkl] moves window focus in that direction, moving to another tab if necessary
function! MoveLeft()
  if (winnr() == winnr('1h'))
    :BufferLineCyclePrev
  else
    :call nvim_input("<Esc><C-w>h")
  endif
endfunction

function! MoveRight()
  if (winnr() == winnr('1l'))
    :BufferLineCycleNext
  else
    :call nvim_input("<Esc><C-w>l")
  endif
endfunction

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> :call MoveLeft()<CR>
nnoremap <C-l> :call MoveRight()<CR>

" tab moves cursor 10 lines down, shift-tab 10 lines up
nnoremap <silent> <TAB> 10j
nnoremap <silent> <S-TAB> 10k

" move through wrapped lines visually
nnoremap j gj
nnoremap k gk

nnoremap <CR> <Nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto complete

" <TAB>: completion.
inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text manipulation

" Move selected line / block of text in visual mode
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Keeps selection active when indenting so you can do it multiple times quickly
vnoremap > >gv
vnoremap < <gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Formatting
let g:clojure_maxlines = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" My personal ctrl prefixed commmands

" Delete the current buffer, also avoid Ex mode
nnoremap <C-q> :bd<CR>

" Source config while inside Neovim (Doesn't work with NixOS setup)
nnoremap <C-s> :source ~/.config/nvim/init.vim<CR>

" Open file explorer
nnoremap <C-n> :NvimTreeToggle<CR>

" Clear search highlighting
nnoremap <C-d> :let @/=""<CR>

" Open Git Fugitive, make it full window
nnoremap <C-g> :Git<CR>:only<CR>

" Remap visual block mode because I use <c-v> for paste
nnoremap <C-b> <C-v>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" lightline config
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'hydrangea',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly'],
      \             ['myfilename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly'],
      \             ['myfilename', 'modified' ] ],
      \   'right': [ ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"":""}',
      \   'obsession': '%{ObsessionStatus("")}'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineFugitive',
      \   'myfilename': 'MyFilename'
      \ },
      \ 'separator':    { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [['obsession']]
      \ },
      \ 'tab_component_function': {
      \   'filename': 'MyTabFilename'
      \ }
      \ }

" I'm not actually using this filename component function anymore because I
" switched to absolutepath and it's much better for me!
" EDIT: switched back to myfilename because with work I'm using long git branch names and long paths
" https://git.io/J3uxJ
function! MyFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" https://git.io/J3sfo
function! MyTabFilename(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnum = buflist[winnr - 1]
  let bufname = expand('#'.bufnum.':t')
  let buffullname = expand('#'.bufnum.':p')
  let buffullnames = []
  let bufnames = []
  for i in range(1, tabpagenr('$'))
    if i != a:n
      let num = tabpagebuflist(i)[tabpagewinnr(i) - 1]
      call add(buffullnames, expand('#' . num . ':p'))
      call add(bufnames, expand('#' . num . ':t'))
    endif
  endfor
  let i = index(bufnames, bufname)
  if strlen(bufname) && i >= 0 && buffullnames[i] != buffullname
    return substitute(buffullname, '.*/\([^/]\+/\)', '\1', '')
  else
    return strlen(bufname) ? bufname : '[No Name]'
  endif
endfunction

function! LightlineFugitive()
    if exists('*FugitiveHead')
	let branch = FugitiveHead()
	return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Event Triggers

" this makes it so vim will update a buffer if it has changed
" on the filesystem when a FocusGained or BufEnter event happens
autocmd FocusGained,BufEnter * :checktime
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s "change comment style for commentary.vim
autocmd FileType clojure setlocal commentstring=;;\ %s
autocmd FileType markdown setlocal wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal
tnoremap <Esc> <C-\><C-n>
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Debugging neovim
nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>r
