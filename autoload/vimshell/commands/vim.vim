"=============================================================================
" FILE: vim.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 16 Sep 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:command_vim = {
      \ 'name' : 'vim',
      \ 'kind' : 'internal',
      \ 'description' : 'vim [{filename}]',
      \}
function! s:command_vim.execute(program, args, fd, context)"{{{
  " Edit file.
  let l:filename = empty(a:args) ? a:fd.stdin : a:args[0]

  " Save current directiory.
  let l:cwd = getcwd()

  let [l:new_pos, l:old_pos] = vimshell#split(g:vimshell_split_command)

  try
    if l:filename == ''
      enew
    elseif len(a:args) > 1
      execute 'edit' '+'.a:args[1] l:filename
    else
      edit `=l:filename`
    endif
  catch
    echohl Error | echomsg v:errmsg | echohl None
  endtry

  let l:bufnr = bufnr('%')

  " Call explorer.
  doautocmd BufEnter

  call vimshell#cd(l:cwd)

  call vimshell#restore_pos(l:old_pos)

  if has_key(a:context, 'is_single_command') && a:context.is_single_command
    call vimshell#print_prompt(a:context)
    call vimshell#restore_pos(l:new_pos, l:bufnr)
    stopinsert
  endif
endfunction"}}}

function! vimshell#commands#vim#define()
  let s:command_vi = deepcopy(s:command_vim)
  let s:command_vi.name = 'vi'
  let s:command_vi.description = 'vi [{filename}]'

  return [s:command_vim, s:command_vi]
endfunction
