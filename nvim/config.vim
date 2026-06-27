"VIM Configuration - Yannick Gladow)

let mapleader=" "
set nocompatible
set cursorline
set hidden

" Plugins are managed by home-manager (programs.neovim.plugins).
" Plugin settings that used to live inside the vim-plug block:
silent! call repeat#set("\<Plug>VSurround", v:count)
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:lightline = { 'colorscheme': 'ayu_light' }

" spelling and markdown writing settings
augroup markdownWriting
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd BufRead,BufNewFile *.md setlocal spell
    autocmd FileType markdown setlocal conceallevel=2 concealcursor=
    autocmd FileType markdown nnoremap <buffer> j gj
    autocmd FileType markdown nnoremap <buffer> k gk
augroup END

lua << EOF
require('render-markdown').setup {
  heading = { enabled = true },
  code = { enabled = true },
  render_modes = true,
}
require('zen-mode').setup {
  window = {
    width = 120,
    backdrop = 1,
    options = {
      number = false,
      relativenumber = false,
    },
  },
}
require('neo-tree').setup {
  default_component_configs = {
    icon = { enabled = false },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
}
EOF

command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete! ".num
    endif
  endfor
endfunction

" ensure windows are not resized when buffer change
set noequalalways
set background=light
if has('termguicolors')
  set termguicolors
endif

colorscheme rose-pine-dawn

" -- Display
" no numbers in term
au TermOpen * setlocal nonumber norelativenumber

set number
set relativenumber	  " relative numbers
set ruler                 " Display cursor position
set wrap                  " Wrap lines when they are too long
set linebreak             " Wrap at word boundaries, not mid-word

set scrolloff=3           " Display at least 3 lines around you cursor
                          " (for scrolling)
                          "
" copy and paste to os clipboard as well
 set clipboard^=unnamed

" indent
set tabstop=2
set shiftwidth=2
set expandtab
setlocal autoindent
filetype plugin indent on

" -- better backuo
set backupdir=~/backup/vim
set dir=~/backup/vim/swap
set undodir=~/backup/vim/undos
set undofile
set bk

" -- Longer history than default 20
set history=1000

let g:rainbow_active = 1



" Ignore files
set wildignore+=*/.git/*,*.cache,*.swp,*.swo,**/cache/**,*.min.js

" -- Search
set ignorecase            " Ignore case when searching
set smartcase             " If there is an uppercase in your search term
                          " search case sensitive again
set incsearch             " Highlight search results when typing
set hlsearch              " Highlight search results

" -- Beep
set visualbell            " Prevent Vim from beeping
set noerrorbells          " Prevent Vim from beeping


" -- Color
syntax on
filetype on


" Backspace behaves as expected
set backspace=indent,eol,start

set softtabstop=2
set shiftround


" -- Uses ripgrep to fuzzy search through all files which are not git ignored
command! -bang -nargs=* GitGrep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" -- Uses ripgrep to fuzzy search through all files
command! -bang -nargs=* Grep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --no-ignore --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Populates the args list with file search results from fzf
func s:fnameescape(key, val)
  return fnameescape(a:val)
endfunc

function! s:populate_arg_list(lines)
  execute 'args ' . join(map(a:lines, function('s:fnameescape')), ' ')
endfunction

let g:fzf_action = {
      \ 'ctrl-l': function('s:populate_arg_list'),
       \ 'ctrl-x': 'split',
       \ 'ctrl-v': 'vsplit' }


"" -- Keymap
" close all buffers
nnoremap <leader>cb :CloseHiddenBuffers<CR>
" opening and closing braces
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap [[     [
inoremap []     []

tnoremap <c-w>h <c-\><c-n><c-w>h
tnoremap <c-w>j <c-\><c-n><c-w>j
tnoremap <c-w>k <c-\><c-n><c-w>k
tnoremap <c-w>l <c-\><c-n><c-w>l

nnoremap <leader>b :Buffers<CR>

" quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" also use flags again when using last substitution
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap <S-TAB> :b#<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>ft :Tags<CR>
nnoremap <Leader>ff :GFiles<CR>
nnoremap <Leader>fg :GitGrep<CR>
nnoremap <Leader>m :Neotree toggle<CR>
nnoremap <Leader>gd gx
" go to alternate file with projectionist
nnoremap <Leader>gt :A<CR>

" -- Git hunk
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)


" Reload the .vimrc config
nnoremap <Leader>vr :so ~/.config/nvim/init.vim<CR>
"
" Edit .vimrc
nnoremap <Leader>ve :edit ~/.vimrc<CR>

" removes current highlighted search result clutter
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Terminal
" to be able to leave insert mode in the terminal window for scrolling
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
endif

map <leader>gf :let mycurf=expand("<cfile>")<cr><c-w>h :execute("e ".mycurf)<cr>

" zoom features
nnoremap <leader>z :Zoom<CR>

" -- commands
" \b <- mru of last buffers
" ctrl w w <- last window
" in visual mode + or - <- more or less marked
" cs'" <- replace surround with
" ds' <- delte surround with
" ysiw[ <- surround with (you surround)
" S" <- when in visual mode
" c gn <- change current search result (c can be also d or others)
" * <- select all occurences, jumps to next (# same but jumps to last)
" ci ( <- change anything insed of ( or whatever x
" ca ( <- change including the ( (change aouter)
" ctrl ^ <- jump to last buffer
" f x <- jump to next occurences of x
" <Leader>f <- find files
" <Leader>r <- find tags
" <Leader>fg <- find GitFiles
" <Leader>y <- find find nerdtree
" <Leader>g <- grep search in all
" <Leader>cc <- comment line or visual (ca toggle comment mode)
" :bd close current buffer
" <leader>be <- mru of buffers (d to close buffer)
" [h ]h next or last hunk for git stage
" <leader>hs <- stage hunk
" <leader>hp <- preview hunk changes
" <leader>hu <- undo changes (if not staged)
" <leader>bt <- show mru of buffers
" <leader>g(d|i|r|t) <- go to definition|implementation|referenc|type impl
" <leader>ac <- code action on line
" <C + e|y> <- scroll up or down
" <leader>y <- show list of yanks
" s <- delete under cursor, enter insert
" ;, <- repeat last search command (forward | back)
" <C-x|a> add|subtract from next number (increment)
" = autoindent
" g~ swap case
 "gu|U lower upper case
 " zz scroll to have cursor in the middle of screen
 " gv select last visual mode selection again
 " o in visual mode, toggle free end
 " it inner tag <a>DASD</a>
 " <C-r>= expression mode in insert mode
 " :%normal A; <- each line apply command (% could be range 1,10 as well)
 " <C-r><C-w> place current word in command prompt
 " q: command line window! nice
 " J join with next line
 " d/ge<CR> delete and search for where to end!! nice
 " m{Char} set mark jump back with `{Char}` upperacase global/lower case local
 " :reg a <- show register a
 " qA <- append to reg a
 " :let i=1 <- set var (:let i +=1)
 " \v in search pattern for regex
 " \v<dasd> match only complete word dasd (word boundaries)
 " \zs and \ze for crop search match (zoom start and zoom end)
 " gn visual mode search match or next match (repeat with . <- super powerful)
 " while searching <C-r><C-w> autocomplete with current word match
 " :g or :v /pattern/cmd to apply command to all matched lines, powerful
 " g/{/.+1,/}/-1 for all lines matching "{" do from "line +1" to pattern "} minus 1" line sort
 " {visual}g <C-A> increment all numbers, each time one more
 " spellcheck
 " set width 150<C-w>|
 " fzf search to quickfix list tab or shift + tab to select result, enter to
 " qf
