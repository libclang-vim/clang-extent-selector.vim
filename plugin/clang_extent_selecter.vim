if exists('g:loaded_clang_extent_selecter')
    finish
endif

noremap <silent><buffer><Plug>(select-next-extent) :<C-u>call clang_extent_selecter#execute()<CR>
map <buffer><C-t> <Plug>(select-next-extent)

let g:loaded_clang_extent_selecter = 1
