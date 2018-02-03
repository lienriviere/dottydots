function! s:GitWrapper(action)
  silent exec ":silent Git" a:action
  redraw!
endfunction

function! s:OpenDirty()
  silent !git ls-files -m | pbcopy
  for file in split(@*, '\n')
    silent exec "e" file
  endfor
  redraw!
endfunction

command! -nargs=0 Gstage :call <SID>GitWrapper('add ' . expand("%:p"))
command! -nargs=0 Gadd :call <SID>GitWrapper('a')
command! -nargs=0 Gunstage :call <SID>GitWrapper('reset ' . expand("%:p"))
command! -nargs=0 Gwip :call <SID>GitWrapper('wip')
command! -nargs=0 Gnana :call <SID>GitWrapper('nana')
command! -nargs=? Gstash :call <SID>GitWrapper("stash save -u <f-args>")
command! -nargs=0 Gpop :call <SID>GitWrapper('stash pop')
command! -nargs=0 Gdrop :call <SID>GitWrapper('stash drop')
command! -nargs=1 Gapply :call <SID>GitWrapper("stash apply <f-args>")
command! -nargs=0 Gdirty :call <SID>OpenDirty()
command! -nargs=0 Gnuke :call <SID>GitWrapper('nuke')
command! -nargs=0 Gconf :e ~/.gitconfig
command! -nargs=0 Gchunk :silent Git chunk<CR>
command! -nargs=0 Gours :call <SID>GitWrapper('checkout --ours ' . expand("%:p"))
command! -nargs=0 Gtheirs :call <SID>GitWrapper('checkout --theirs ' . expand("%:p"))

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Gpush<CR>
nnoremap <silent> <leader>ga :Gstage<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gu :Gunstage<CR>
