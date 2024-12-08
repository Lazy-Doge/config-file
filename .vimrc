""""""""""""""""""""""""
" 插件安装

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Use release branch (recommend)
" 自动补全插件
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""
" vim设置

" 显示行号
set number
" 显示命令候选彩蛋
set wildmenu
" tab缩进为4
set tabstop=4
" 语法高亮
syntax on

""""""""""""""""""""""""
" coc补全设置

" 补全框背景
highlight CocFloating ctermbg=60
" 选中框背景
highlight CocMenuSel ctermbg=35

" 显示最大补全为10
set pumheight=10

" 将错误提醒改为红线
highlight CocErrorLine cterm=undercurl ctermfg=Red

" utf-8字节序列
set encoding=utf-8

" 一些服务器有备份文件的问题，见#649
set nobackup
set nowritebackup

" 拥有更长的更新时间(默认是4000毫秒=4秒)会导致明显的
" 延迟和糟糕的用户体验"
set updatetime=200

" 总是显示signcolumn，否则它会每次
" 诊断出现/得到解决时移动文本"
set signcolumn=yes

" 使用tab来触发带有前面字符的完成并导航"
" 注意:默认情况下总是有完整的项目选择，你可能想启用
" no select by `suggest.noselect`: true"在你的配置文件中
" 注意:在将此放入你的配置之前，使用命令':verbose imap <tab>'来确保tab没有被其他插件映射"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 使<CR>接受选择的完成项目或通知coc.nvim格式化
" <C-g>u破坏当前撤销，请自行选择
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 使用<c-space>触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" 使用`[g`和`]g`来导航诊断
" 使用`:CocDiagnostics`来获取当前缓冲区位置列表中的所有诊断信息
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo代码导航"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" 使用K在预览窗口中显示文档"
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 当光标停留时，突出显示符号及其引用"
autocmd CursorHold * silent call CocActionAsync('highlight')

" 符号重命名"
nmap <leader>rn <Plug>(coc-rename)

" 格式化选定的代码"
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  "设置指定的文件类型格式化表达式"
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "更新跳转占位符上的签名帮助
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" 将代码操作应用到选定的代码块
" 示例:当前段落的`<leader>aap`
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 在游标位置应用代码操作的重映射键
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" 影响整个缓冲区应用代码操作的重映射键
nmap <leader>as  <Plug>(coc-codeaction-source)
" 在当前行上应用最喜欢的快速修复操作来修复诊断
nmap <leader>qf  <Plug>(coc-fix-current)

" 应用重构代码操作的重映射键
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" 在当前行上运行代码透视图操作
nmap <leader>cl  <Plug>(coc-codelens-action)

" 映射函数和类文本对象
" 注意:需要语言服务器支持'textDocument.documentSymbol'
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" 重新映射<C-f>和<C-b>以滚动浮动窗口/弹出窗口"
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" 使用CTRL-S进行选择范围"
" 需要语言服务器支持'textDocument/selectionRange'
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" 添加`:Format`命令来格式化当前缓冲区
command! -nargs=0 Format :call CocActionAsync('format')

" 添加`:Fold`命令来折叠当前缓冲区
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" 添加`:OR`命令来组织当前缓冲区的导入
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" 添加(Neo)Vim的本地状态行支持
" 注意:请参阅`:h coc-status`以了解与外部插件的集成
" 提供自定义状态线:lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CoCList映射
" 显示所有诊断
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" 管理扩展
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" 显示命令
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" 查找当前文档的符号
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" 搜索工作空间符号
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" 为下一个项目执行默认操作
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" 为前一个项目执行默认操作
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" 恢复最新的coc列表
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
