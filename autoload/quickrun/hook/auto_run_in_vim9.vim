let s:hook = {
\   'config': { 'enable': 0 }
\ }

let s:V = vital#quickrun_hook_auto_run_in_vim9#import('Vim.Vim9context')

function s:hook.init(session) abort
  if !self.config.enable
    return
  endif

  " Disable this hook here and re-enable later if needed.
  let self.config.enable = 0

  let region = get(a:session.config, 'region', {})
  if empty(region)
    return
  endif

  let line = region.first[0]
  let stopline = region.last[0]
  while v:true
    if line > stopline || getline(line) =~# '^\s*vim9s\%[cript]\>'
      " Keep this hook disabled when there're only legacy comments or the
      " first command is :vim9s[cript].
      return
    elseif getline(line) =~# '^\s*"'
      " Skip legacy comment lines.
      let line += 1
    else
      " Neither :vim9script line or legacy comment line is the head of code
      " block.  We need script context check.  Break.
      break
    endif
  endwhile

  if s:V.get_context_pos(region.first[0], 1) == s:V.CONTEXT_VIM9_SCRIPT
    let self.config.enable = 1
  endif
endfunction


" This function is modification of s:hook.on_module_loaded() function in this
" file, which is distributed under zlib license:
" https://github.com/thinca/vim-quickrun/blob/50f9ced186cf2651f4356aa3548c2306e181ec3b/autoload/quickrun/hook/eval.vim#L18-L25
function s:hook.on_module_loaded(session, context) abort
  let src = join(readfile(a:session.config.srcfile, 'b'), "\n")
  let new_src = "vim9script\n" . src
  let srcfile = a:session.tempname(quickrun#expand(a:session.config.tempfile))
  if writefile(split(new_src, "\n", 1), srcfile, 'b') == 0
    let a:session.config.srcfile = srcfile
  endif
endfunction


function quickrun#hook#auto_run_in_vim9#new() abort
  return deepcopy(s:hook)
endfunction
