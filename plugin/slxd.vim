" Define color variables using 256 colors
let g:StslineColorGreen  = 2       " green
let g:StslineColorBlue   = 4       " blue
let g:StslineColorViolet = 13      " violet
let g:StslineColorYellow = 11      " yellow
let g:StslineColorOrange = 9       " orange
let g:StslineColorLight  = 7       " white
let g:StslineColorDark   = 0       " black
let g:StslineColorDark1  = 8       " grey
let g:StslineColorDark2  = 235     " dark grey
let g:StslineColorDark3  = 239     " darker grey

" Set background color to NONE for transparency
let g:StslineBackColor   = 'NONE'   " Transparent background
let g:StslineOnBackColor = g:StslineColorLight
let g:StslineOnPriColor  = g:StslineColorDark
let g:StslineSecColor    = g:StslineColorDark3
let g:StslineOnSecColor  = g:StslineColorLight

" Create highlight groups using ctermfg and ctermbg
execute 'highlight StslineSecColorFG ctermfg=' . g:StslineSecColor . ' ctermbg=' . g:StslineBackColor
execute 'highlight StslineSecColorBG ctermfg=' . g:StslineColorLight . ' ctermbg=' . g:StslineBackColor
execute 'highlight StslineBackColorBG ctermfg=' . g:StslineColorLight . ' ctermbg=' . g:StslineBackColor
execute 'highlight StslineBackColorFGSecColorBG ctermfg=' . g:StslineBackColor . ' ctermbg=' . g:StslineSecColor
execute 'highlight StslineSecColorFGBackColorBG ctermfg=' . g:StslineSecColor . ' ctermbg=' . g:StslineBackColor
execute 'highlight StslineModColorFG ctermfg=' . g:StslineColorYellow . ' ctermbg=' . g:StslineBackColor

" Highlighting unbloat
highlight Pmenu ctermbg=none guibg=none cterm=bold gui=bold blend=0
highlight MatchParen ctermbg=none guibg=none cterm=bold gui=bold blend=0
highlight ErrorMsg ctermfg=none ctermbg=none
highlight Error ctermfg=none ctermbg=none
highlight SpecialKey ctermfg=none ctermbg=none
highlight SpellBad ctermfg=red ctermbg=none gui=bold
highlight SpellCap ctermfg=red ctermbg=none gui=bold
highlight SpellRare ctermfg=red ctermbg=none gui=bold
highlight SpellLocal ctermfg=red ctermbg=none gui=bold
highlight Visual ctermfg=Red ctermbg=Black gui=bold
highlight Conceal guifg=Cyan guibg=none ctermbg=none
highlight SignColumn ctermbg=none guibg=none cterm=bold gui=bold blend=0
highlight StatusLine ctermbg=none guibg=none cterm=none gui=none blend=0
highlight StatusLineNC ctermbg=none guibg=none cterm=none gui=none blend=0

" Tab bar styling with your custom colors
highlight TabLine      ctermfg=white    guifg=#A0A0A0    ctermbg=none guibg=none cterm=bold gui=none
highlight TabLineSel   ctermfg=green    guifg=#FFFFFF    ctermbg=none guibg=#3B4252 cterm=bold gui=bold
highlight TabLineFill  ctermfg=white    guifg=#4C566A    ctermbg=none guibg=none   cterm=bold gui=none

" For when changing vim colorschemes in tmux
augroup TransparentBackground
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=none | highlight NonText ctermbg=none
augroup END

" Some visual separations
set tabline=%!TabPageNumber()
let &statusline='%#Normal# '

" Find tab page number
function! TabPageNumber()
  let s = ''
  for i in range(1, tabpagenr('$'))
    " Highlight the current tab
    if i == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " Add tab number and file name
    let s .= i . ':' . fnamemodify(bufname(tabpagebuflist(i)[tabpagewinnr(i) - 1]), ':t') . ' '
  endfor
  " Fill the rest of the line
  let s .= '%#TabLineFill#%T'
  return s
endfunction

" Change foreground color for primary text to green
execute 'highlight StslinePriColorFG ctermfg=' . g:StslineColorGreen . ' ctermbg=' . g:StslineBackColor

" Statusline configuration
set laststatus=2
set noshowmode  " Disable showmode

" Function to get the count of open buffers
function! GetOpenBufferCount()
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

" Active statusline
function! ActivateStatusline()
    call GetFileType()
    setlocal statusline=%#StslinePriColorFG#\ %{StslineMode()}%#StslinePriColorFG#%{get(b:,'coc_git_status',b:GitBranch)}%{get(b:,'coc_git_blame','')}%#StslinePriColorFG#%#StslinePriColorFG#\ %{&readonly?\"\ \":\"\"}%f\ %#StslineModColorFG#%{&modified?\"\ \":\"\"}%=%#StslinePriColorFG#\%{b:FiletypeIcon}\%#StslineSecColorBG#%#StslineSecColorBG#%{&fenc!='utf-8'?\"\ \":''}%{&fenc!='utf-8'?&fenc:''}%{&fenc!='utf-8'?\"\ \":''}%#StslinePriColorFGSecColorFG#%#StslinePriColorFG#\ %p\%%\ %#StslinePriColorFG#%l%#StslinePriColorFG#/%L\:%c\ \%{getfsize(expand('%'))}\:B\ %{wordcount().words}\:w\ %{&fileformat}\ [%n]:\%{GetOpenBufferCount()}
endfunction

" Inactive statusline
function! DeactivateStatusline()
    if !exists("b:GitBranch") || b:GitBranch == ''
        setlocal statusline=%#StslineSecColorBG#\ inactive\ %#StslineSecColorBG#%{get(b:,'coc_git_statusline',b:GitBranch)}%{get(b:,'coc_git_blame','')}%#StslineBackColorFGSecColorFG#%#StslineBackColorBG#\ %{&readonly?\"\ \":\"\"}%f\ %#StslineModColorFG#%{&modified?\"\ \":\"\"}%=%#StslineBackColorBG#\%{b:FiletypeIcon}\%#StslineSecColorFGBackColorBG#%#StslineSecColorBG#\ %p\%%\ %l/%L\:%c\ %{getfsize(expand('%'))}\:B\ %{wordcount().words}\:w\ %{&fileformat}\ [%n]
    else
        setlocal statusline=%#StslineSecColorBG#%{get(b:,'coc_git_statusline',b:GitBranch)}%{get(b:,'coc_git_blame','')}%#StslineBackColorFGSecColorFG#%#StslineBackColorBG#\ %{&readonly?\"\ \":\"\"}%f\ %#StslineModColorFG#%{&modified?\"\ \":\"\"}%=%#StslineBackColorBG#\ %{b:FiletypeIcon}\%#StslineSecColorFGBackColorBG#%#StslineSecColorBG#\ %p\%%\ %l/%L\:%c\ %{getfsize(expand('%'))}\:B\ %{wordcount().words}\:w\ %{&fileformat}\ [%n]
    endif
endfunction

" Get Statusline mode & also set primary color for that mode
function! StslineMode()
    let l:CurrentMode=mode()

    if l:CurrentMode==#"n"
        let g:StslinePriColor     = g:StslineColorGreen
        let b:CurrentMode = "normal "

    elseif l:CurrentMode==#"i"
        let g:StslinePriColor     = g:StslineColorViolet
        let b:CurrentMode = "insert "

    elseif l:CurrentMode==#"c"
        let g:StslinePriColor     = g:StslineColorYellow
        let b:CurrentMode = "command "

    elseif l:CurrentMode==#"v"
        let g:StslinePriColor     = g:StslineColorBlue
        let b:CurrentMode = "visual "

    elseif l:CurrentMode==#"V"
        let g:StslinePriColor     = g:StslineColorBlue
        let b:CurrentMode = "v-line "

    elseif l:CurrentMode==#"\<C-v>"
        let g:StslinePriColor     = g:StslineColorBlue
        let b:CurrentMode = "v-block "

    elseif l:CurrentMode==#"R"
        let g:StslinePriColor     = g:StslineColorViolet
        let b:CurrentMode = "replace "

    elseif l:CurrentMode==#"s"
        let g:StslinePriColor     = g:StslineColorBlue
        let b:CurrentMode = "select "

    elseif l:CurrentMode==#"t"
        let g:StslinePriColor     = g:StslineColorYellow
        let b:CurrentMode = "term "

    elseif l:CurrentMode==#"!"
        let g:StslinePriColor     = g:StslineColorYellow
        let b:CurrentMode = "shell "

    endif

    call UpdateStslineColors()
    return b:CurrentMode
endfunction

" Update colors. Recreate highlight groups with new Primary color value.
function! UpdateStslineColors()
    execute 'highlight StslinePriColorBG           guifg=' . g:StslineOnPriColor ' guibg=' . g:StslinePriColor
    execute 'highlight StslinePriColorBGBold       guifg=' . g:StslineOnPriColor ' guibg=' . g:StslinePriColor ' gui=bold'
    execute 'highlight StslinePriColorFG           guifg=' . g:StslinePriColor   ' guibg=' . g:StslineBackColor
    execute 'highlight StslinePriColorFGSecColorBG guifg=' . g:StslinePriColor   ' guibg=' . g:StslineSecColor
    execute 'highlight StslineSecColorFGPriColorBG guifg=' . g:StslineSecColor   ' guibg=' . g:StslinePriColor

    if !exists("b:GitBranch") || b:GitBranch == ''
        execute 'highlight StslineBackColorFGPriColorBG guifg=' . g:StslineBackColor ' guibg=' . g:StslinePriColor
    endif
endfunction

" Get git branch name
function! GetGitBranch()
    let b:GitBranch=""
    try
        let l:dir=expand('%:p:h')
        let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
        if !v:shell_error
            let b:GitBranch="   ".substitute(l:gitrevparse, '\n', '', 'g')." "
            execute 'highlight StslineBackColorFGPriColorBG guifg=' . g:StslineBackColor ' guibg=' . g:StslineSecColor
        endif
    catch
    endtry
endfunction

" Get filetype & custom icon. Put your most used file types first for optimized performance.
function! GetFileType()

if &filetype == ''
let b:FiletypeIcon = ''

elseif &filetype == 'sh' || &filetype == 'zsh'
let b:FiletypeIcon = ' '

elseif &filetype == 'tex'
let b:FiletypeIcon = ' '

elseif &filetype == 'markdown'
let b:FiletypeIcon = ' '

elseif &filetype == 'c'
let b:FiletypeIcon = ' '

elseif &filetype == 'vim'
let b:FiletypeIcon = ' '

elseif &filetype == 'cpp'
let b:FiletypeIcon = ' '

elseif &filetype == 'go'
let b:FiletypeIcon = ' '

elseif &filetype == 'lua'
let b:FiletypeIcon = ' '

elseif &filetype == 'rust'
let b:FiletypeIcon = ' '

elseif &filetype == 'r'
let b:FiletypeIcon = ' '

elseif &filetype == 'typescript'
let b:FiletypeIcon = ' '

elseif &filetype == 'html'
let b:FiletypeIcon = ' '

elseif &filetype == 'scss'
let b:FiletypeIcon = ' '

elseif &filetype == 'css'
let b:FiletypeIcon = ' '

elseif &filetype == 'javascript'
let b:FiletypeIcon = ' '

elseif &filetype == 'javascriptreact'
let b:FiletypeIcon = ' '

elseif &filetype == 'ruby'
let b:FiletypeIcon = ' '

elseif &filetype == 'haskell'
let b:FiletypeIcon = ' '

else
let b:FiletypeIcon = ''

endif
endfunction

" Get git branch name after entering a buffer
augroup GetGitBranch
    autocmd!
    autocmd BufEnter * call GetGitBranch()
augroup END

" Set active / inactive statusline after entering, leaving buffer
augroup SetStslineline
    autocmd!
    autocmd BufEnter,WinEnter * call ActivateStatusline()
    autocmd BufLeave,WinLeave * call DeactivateStatusline()
augroup END
