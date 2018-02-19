" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json

  " ALE linting events
  if g:has_async
    set updatetime=1000
    let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Lint()
    autocmd CursorHoldI * call ale#Lint()
    autocmd InsertEnter * call ale#Lint()
    autocmd InsertLeave * call ale#Lint()
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Escape insert mode
imap jk <esc>:w<cr>
imap kj <esc>:w<cr>
imap jj <esc>

" bind \ (backward slash) to grep shortcut
" command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind <leader>d to search Dash for word under cursor
nmap <silent><leader>d :Dash<cr>

" open scratchpad
command Scratch vsplit ~/dev/scratchpad.md

" Pre-populate a split command with the current directory
nmap <leader>v :vnew <C-r>=escape(expand("%:p:h"), ' ') . '/'<cr>

" Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

" Command aliases for typoed commands (accidentally holding shift too long)
command! Q q "Bind :Q to :q
command! Qall qall
command! QA qall
command! E e

" Paset and use current level of indentation (where cursor currently is)
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>

" Relative number with absolute line number on current line
set number
set relativenumber

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim split, <C-w> to rebalance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

nnoremap <leader>irb :VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'irb'}<cr>

" Make current split large and make others smaller
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999
nnoremap <leader>pry :VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'pry'}<cr>

" Go to the end of the line and append
nnoremap <leader>a $a

" Highlight search results
set hlsearch
hi Search cterm=underline,reverse ctermfg=0 ctermbg=11

" Clear highlighted search results
nmap <leader>h :nohlsearch<cr>
" Override ignorecase if pattern contains uppercase characters
set smartcase

" Highlight spelling mistakes in a more readable background color
hi SpellBad ctermbg=1

" Allows macOS to access clipboard
set clipboard=unnamed

" Settings for vim-textobj-rubyblock
if has("autocmd")
  filetype indent plugin on
endif

" Explore current file's directory
nmap <leader>o :Explore<cr>
" Open current file's directory in new split
nmap <leader>os :Sexplore<cr>
" Open current file's directory in new vertical split
nmap <leader>ov :Vexplore<cr>
" Open current file's directory in a new tab
nmap <leader>ot :tabe %:h<cr>

" Change ColorColumn to dark gray
hi ColorColumn ctermbg=8

" Pretty print JSON (requires 'elzr/vim-json' and 'jq')
function! s:PrettyJSON()
  %!jq .
  set filetype=json
endfunction
command! PrettyJSON :call <sid>PrettyJSON()

" Send RSpec spects to tmux panes
let g:rspec_command = 'call Send_to_Tmux("rspec {spec}\n")'

" Enter insert mode after adding newlines above and below
nmap <leader>i o<cr><esc>kcc
" Insert newline below/above without entering insert mode
nmap <leader>j o<esc>
nmap <leader>k O<esc>

" JS debugging shortcuts
nmap <leader>cl oconsole.log();<esc>hi
nmap <leader>b odebugger;<esc>:w<cr>

" Attach to pane (Vim Tmux Runner)
nmap <leader>x :VtrAttachToPane<cr>

" Send gulp test:dev to attached pane
nmap <leader>g :VtrSendCommandToRunner gul test:dev<cr>

" Configure EditorConfig to work with fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Highlight the current line
set cursorline
hi CursorLine cterm=NONE ctermbg=0

" Rename current file (from @garybernhardt)
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_nae
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" ProseMode (courtesy https://statico.github.io/vim3.html#writing-prose-in-vim)
function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
  if !has('gui_running')
    let g:solarized_termcolors=256
  endif
  colorscheme solarized
endfunction

command! ProseMode call ProseMode()
nmap \p :ProseMode<CR>

" ale config
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
