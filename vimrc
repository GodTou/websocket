set nocompatible               " be iMproved

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'Markdown'
Bundle 'vimwiki'
Bundle 'winmanager'
Bundle 'bufexplorer.zip'
Bundle 'The-NERD-tree'
Bundle 'FencView.vim'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'taglist.vim'
Bundle 'snipMate'

" ...

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

colorscheme desert           " 灰褐色主题
set guifont=Courier\ New:h10 " 字体 && 字号
set tabstop=4                " 设置tab键的宽度
set expandtab                " 设置tab为4个空格
set shiftwidth=4             " 换行时行间交错使用4个空格
set autoindent               " 自动对齐

set cindent shiftwidth=4     " 自动缩进4空格
set smartindent              " 智能自动缩进
" set ai!                      " 设置自动缩进
set nu!                      " 显示行号
set showmatch               " 显示括号配对情况
"set mouse=a                  " 启用鼠标
set ruler                    " 右下角显示光标位置的状态行
set incsearch                " 查找book时，当输入/b时会自动找到
set hlsearch                 " 开启高亮显示结果
set incsearch                " 开启实时搜索功能
set nowrapscan               " 搜索到文件两端时不重新搜索
set vb t_vb=                 " 关闭提示音
"set cursorline              " 突出显示当前行
set hidden                   " 允许在有未保存的修改时切换缓冲区
set list                     " 显示Tab符，使用一高亮竖线代替
"set listchars=tab:\|\ ,trail:-
set listchars=tab:\|\ ,trail:-,extends:>,precedes:< ",eol:$
set nobomb
set foldmethod=manual


syntax enable                " 打开语法高亮
syntax on                    " 开启文件类型侦测
filetype indent on           " 针对不同的文件类型采用不同的缩进格式
filetype plugin on           " 针对不同的文件类型加载对应的插件


set writebackup              " 设置无备份文件
set nobackup
set autochdir                " 设定文件浏览器目录为当前目录
"set nowrap                  " 设置不自动换行
set foldmethod=syntax        " 选择代码折叠类型
set foldlevel=100            " 禁止自动折叠

set laststatus=2             " 开启状态栏信息
set cmdheight=2              " 命令行的高度，默认为1，这里设为2

" 每行超过80个的字符用下划线标示
au BufRead,BufNewFile *.asm,*.c,*.cpp,*.java,*.cs,*.sh,*.lua,*.pl,*.pm,*.py,*.rb,*.hs,*.vim 2match Underlined /.\%81v/

set tags=/home/godtou/site/firstp2p/tags
cs add /home/godtou/site/firstp2p/cscope.out /usr/share/vim

" 设置编码
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8,gbk,cp936,latin-1
set fileformats=unix

function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf


" ======= 编译 && 运行 ======= "

" 编译C源文件
func! CompileGcc()
    exec "w"
    let compilecmd="!gcc -Wall -pedantic -std=c99 "
    let compileflag="-o %<"
    exec compilecmd." % ".compileflag
endfunc

" 编译C++源文件
func! CompileCpp()
    exec "w"
    let compilecmd="!g++ -Wall -pedantic -std=c++98 "
    let compileflag="-o %<"
    exec compilecmd." % ".compileflag
endfunc

" 编译Java源文件
func! CompileJava()
    exec "w"
    exec "!javac %"
endfunc

" 根据文件类型自动选择相应的编译函数
func! CompileCode()
        exec "w"
        if &filetype == "c"
            exec "call CompileGcc()"
        elseif &filetype == "cpp"
            exec "call CompileCpp()"
        elseif &filetype == "java"
            exec "call CompileJava()"
        elseif &filetype == "lua"
            exec "!lua %<.lua"
        elseif &filetype == "perl"
            exec "!perl %<.pl"
        elseif &filetype == "python"
            exec "!python %<.py"
        elseif &filetype == "ruby"
            exec "!ruby %<.rb"
        elseif &filetype == "php"
            exec "!php -l %<.php"
        endif
endfunc

" 运行可执行文件
func! RunResult()
        exec "w"
        if &filetype == "c"
            exec "! %<"
        elseif &filetype == "cpp"
            exec "! %<"
        elseif &filetype == "java"
            exec "!java %<"
        elseif &filetype == "lua"
            exec "!lua %<.lua"
        elseif &filetype == "perl"
            exec "!perl %<.pl"
        elseif &filetype == "python"
            exec "!python %<.py"
        elseif &filetype == "ruby"
            exec "!ruby %<.rb"
        elseif &filetype == "php"
            exec "!php %<.php"
        endif
endfunc

" Ctrl + C 一键保存、编译
map  :call CompileCode()<CR>
imap  <ESC>:call CompileCode()<CR>
vmap  <ESC>:call CompileCode()<CR>

" Ctrl + R 一键保存、运行
map <F2>:call RunResult()<CR>
imap <F2> <ESC>:call RunResult()<CR>
vmap <F2> <ESC>:call RunResult()<CR>

func! CheckPHP()
    if &filetype == 'php'
        let result = system('php -l '.expand('%'))
        if (stridx(result, 'No syntax errors detected') == -1)
            echohl WarningMsg
            echo result
            echohl None
        endif
    endif
endfunc

autocmd BufWritePost * call CheckPHP()
