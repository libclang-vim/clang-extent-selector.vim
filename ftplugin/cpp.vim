noremap <silent><buffer><Plug>(select-next-extent) :<C-u>call clang_extent_selecter#execute()<CR>
if get(g:, 'clang_extent_selecter_no_default_mapping', 0)
    map <buffer><C-t> <Plug>(select-next-extent)
endif
