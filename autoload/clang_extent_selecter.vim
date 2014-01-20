" TODO
" show information of selected area

let s:context = {'pos' : [], 'stage' : -1, 'extents' : []}

function! s:prepare_temp_file()
    let temp_name = tempname() . (&filetype==#'c' ? '.c' : '.cpp')
    if -1 == writefile(map(getline(1, '$'), 'v:val =~# "^\\s*#include\\s*\\(<[^>]\\+>\\|\"[^\"]\\+\"\\)" ? "" : v:val'), temp_name)
        throw "Could not create a temporary file : ".temp_name
    endif
    return temp_name
endfunction

function! s:get_extents()
    let temp_name = s:prepare_temp_file()
    try
        return libclang#location#all_extents(temp_name, line('.'), col('.'))
    finally
        call delete(temp_name)
    endtry
endfunction

function! s:unique_extents(extents)
    let len = len(a:extents)
    if len == 0
        return []
    endif

    let unique_extents = []
    let idx = 0
    while idx < len - 1
        if a:extents[idx] != a:extents[idx+1]
            call add(unique_extents, a:extents[idx])
        endif
        let idx += 1
    endwhile
    call add(unique_extents, a:extents[-1])

    return unique_extents
endfunction

function! s:set_context(pos)
    let s:context.extents = s:unique_extents(s:get_extents())
    let s:context.stage = 0
    let s:context.pos = a:pos
endfunction

function! s:select_extent(extent)
    let mode = mode()

    let pos = getpos('.')
    let start = [pos[0], a:extent.start.line, a:extent.start.column, pos[3]]
    let end = [pos[0], a:extent.end.line, a:extent.end.column, pos[3]]
    call setpos('.', start)
    normal! v
    call setpos('.', end)
    return start
endfunction

function! clang_extent_selector#execute()
    let pos = getpos('.')
    if pos != s:context.pos
        call s:set_context(pos)
    else
        " Rotate extents
        let s:context.stage = s:context.stage + 1 >= len(s:context.extents) ? 0 : s:context.stage + 1
    endif

    if empty(s:context.extents)
        return
    endif

    let s:context.pos = s:select_extent(s:context.extents[s:context.stage])
endfunction

