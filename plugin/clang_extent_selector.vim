if exists('g:loaded_clang_extent_selector')
    finish
endif

noremap <silent><Plug>(clang-select-next-extent) :<C-u>call clang_extent_selector#execute()<CR>

augroup plugin-clang-extent-selector
    autocmd!
augroup END

if get(g:, 'clang_extent_selector_use_default_mapping', 1)
    autocmd plugin-clang-extent-selector FileType c,cpp map <buffer><C-t> <Plug>(clang-select-next-extent)
endif

let g:loaded_clang_extent_selector = 1
