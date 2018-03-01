let g:switch_mapping = ""
nnoremap >s :Switch<CR>
nnoremap <s :SwitchReverse<CR>

augroup SwitchDefinitions
  autocmd!
  autocmd FileType coffee let b:switch_custom_definitions =
    \ [
    \   ['Given', 'When', 'Then', 'And'],
    \   ['@service', '@scope'],
    \   ['toBe', 'toEqual'],
    \   ['toHaveBeenCalled', 'toHaveBeenCalledWith'],
    \   ['thenResolveWith', 'thenRejectWith'],
    \   ['thenResolve', 'thenReject'],
    \   ['context', 'describe'],
    \   ['spyOn', 'spyOnAll']
    \ ]
  autocmd FileType html let b:switch_custom_definitions =
    \ [
    \   {
    \     '{{#\([^}]\{-}\)}}': '{{^\1}}',
    \     '{{^\([^}]\{-}\)}}': '{{/\1}}',
    \     '{{/\([^}]\{-}\)}}': '{{#\1}}'
    \   },
    \   {
    \     '<h1\([^>]\{-}\)>\([^<]\{-}\)</h1>': '<h2\1>\2</h2>',
    \     '<h2\([^>]\{-}\)>\([^<]\{-}\)</h2>': '<h3\1>\2</h3>',
    \     '<h3\([^>]\{-}\)>\([^<]\{-}\)</h3>': '<h4\1>\2</h4>',
    \     '<h4\([^>]\{-}\)>\([^<]\{-}\)</h4>': '<h5\1>\2</h5>',
    \     '<h5\([^>]\{-}\)>\([^<]\{-}\)</h5>': '<h6\1>\2</h6>',
    \     '<h6\([^>]\{-}\)>\([^<]\{-}\)</h6>': '<h1\1>\2</h1>'
    \   },
    \   {
    \     '<div\([^>]\{-}\)>\([^<]\{-}\)</div>': '<span\1>\2</span>',
    \     '<span\([^>]\{-}\)>\([^<]\{-}\)</span>': '<div\1>\2</div>'
    \   },
    \   {
    \     '<a\([^>]\{-}\)>\([^<]\{-}\)</a>': '<button\1>\2</button>',
    \     '<button\([^>]\{-}\)>\([^<]\{-}\)</button>': '<a\1>\2</a>'
    \   },
    \   {
    \     'col-\(xs\|sm\|md\|lg\)-12': 'col-\1-6',
    \     'col-\(xs\|sm\|md\|lg\)-6': 'col-\1-4',
    \     'col-\(xs\|sm\|md\|lg\)-4': 'col-\1-3',
    \     'col-\(xs\|sm\|md\|lg\)-3': 'col-\1-2',
    \     'col-\(xs\|sm\|md\|lg\)-2': 'col-\1-12'
    \   }
    \ ]
  autocmd FileType javascript let b:switch_custom_definitions =
    \ [
    \   {
    \     'function(\([^)]\{-}\))': '(\1) =>',
    \     '(\([^)]\{-}\)) =>': 'function(\1)'
    \   },
    \   ['var', 'let', 'const']
    \ ]
augroup END
