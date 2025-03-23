"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

" Install Vim-Plug
if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"Plug 'madox2/vim-ai'
Plug 'gergap/vim-ollama'

"" Color
Plug 'chriskempson/base16-vim'

call plug#end()

filetype plugin indent on

"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set ignorecase
set smartcase

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number
set nowrap

let no_buffers_menu=1
if !exists('g:not_finish_vimplug')
  colorscheme base16-tomorrow-night-eighties
  let base16colorspace=256
endif
  colorscheme base16-tomorrow-night-eighties
  let base16colorspace=256

set t_Co=256

set background=dark

if &term =~ '256color'
  set t_ut=
endif

hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" vim-airline
let g:airline_theme='base16_tomorrow_night_eighties'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

" ale
let g:ale_completion_enabled = 1
let g:ale_linters = {'python': ['ruff']}
let g:ale_fixers = {'python': ['black']}

"*****************************************************************************
" Vim-AI
"*****************************************************************************
let s:vim_ai_endpoint_url = "https://ollama.ai.west.cafe/v1/chat/completions"
let s:vim_ai_model = "qwen2.5-coder:14b"
let s:vim_ai_temperature = 0.3

let s:vim_ai_chat_prompt =<< trim END
>>> system

You are a helpful code assistant.

Assume that all unknown symbols are properly initialized elsewhere.

Add a syntax type after ``` to enable proper syntax highlighting in fenced code blocks.
END

let s:vim_ai_edit_prompt =<< trim END
>>> system

You will act as a code generator.

Do not write any introduction, conclusion, or explanation.

Do not use fenced code blocks.

Respect the original indentation level.
END

let s:vim_ai_chat_config = #{
\  engine: "chat",
\  options: #{
\    auth_type: "none",
\    model: s:vim_ai_model,
\    initial_prompt: s:vim_ai_chat_prompt,
\    temperature: s:vim_ai_temperature,
\    endpoint_url: s:vim_ai_endpoint_url,
\    max_tokens: 0,
\    request_timeout: 60,
\  },
\  ui: #{
\    code_syntax_enabled: 1,
\  },
\}

let s:vim_ai_edit_config = #{
\  engine: "chat",
\  options: #{
\    auth_type: "none",
\    model: s:vim_ai_model,
\    initial_prompt: s:vim_ai_edit_prompt,
\    temperature: s:vim_ai_temperature,
\    endpoint_url: s:vim_ai_endpoint_url,
\    max_tokens: 0,
\    request_timeout: 60,
\  },
\  ui: #{
\    paste_mode: 1,
\  },
\}

let g:vim_ai_chat = s:vim_ai_chat_config
let g:vim_ai_complete = s:vim_ai_edit_config
let g:vim_ai_edit = s:vim_ai_edit_config


"*****************************************************************************
"*****************************************************************************
