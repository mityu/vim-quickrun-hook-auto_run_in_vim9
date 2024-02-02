" Usage: vim -u demo.vim and then type '@'
" Requirements: This plugin, quickrun.vim, autoplay.vim

unlet! g:skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set packpath^=~/.cache/vim
packadd! autoplay.vim
packadd! vim-quickrun
packadd! vim-quickrun-hook-auto_run_in_vim9

let g:quickrun_config = {
\   '_': {
\     'outputter/buffer/opener': '5new',
\   },
\ }

function s:getExcmdScript(command, wait_time = 500) abort
  return [
  \  {'text': ':' . a:command, 'spell_out': v:true},
  \ {'wait': a:wait_time},
  \ "\<CR>",
  \]
endfunction

let s:intro =<< trim END
This is a quickrun.vim hook to run Vim9 code block easily.
This hook adds ":vim9script" line to the head of the code block automatically
and make it able to run Vim9 script code block!
END

let s:intro = substitute(join(s:intro), '\r\zs\s\+', '', 'g')

call autoplay#reserve({
\ 'wait': 23,
\ 'spell_out': v:true,
\ 'remap': v:false,
\ 'scripts': [
\    {'exec': 'setlocal buftype=nofile filetype=vim expandtab shiftwidth=2'},
\    {'exec': 'nnoremap <buffer> q <Cmd>qa<CR>'},
\    'i" ' . s:intro . "\<ESC>",
\    {'text': "Go\<C-u>\<CR>"},
\    "vim9script\<CR>\<CR>execute('echo \"This is Vim9 script code block\"', '')\<ESC>",
\    {'text': 'GO'},
\    "# First, run just this line without this hook.  Execution will fail.\<ESC>",
\    {'text': 'GV', 'wait': 500},
\    s:getExcmdScript('QuickRun'),
\    {'text': "mmggg'm"},
\    {'wait': 1000},
\    {'text': 'Gko'},
\    "Certainly failed.  Then, let's enable this auto_run_in_vim9 hook!\<ESC>",
\    s:getExcmdScript("let b:quickrun_config = {'hook/auto_run_in_vim9/enable': 1}"),
\    {'wait': 1000},
\    {'text': 'Gko'},
\    "Now auto_run_in_vim9 hook is enabled.  Let's run this line again.\<ESC>",
\    {'text': 'GV', 'wait': 500},
\    s:getExcmdScript('QuickRun'),
\    {'wait': 1000},
\    {'text': 'Gko'},
\    "Successfully executed 🎉\<ESC>",
\    {'wait': 1000},
\    {'text': "Go\<CR>"},
\    "# Then, let's try legacy vim script code block execution.\<CR>",
\    "\<C-u>function! LegacyFunction() abort\<CR>",
\    "let s:var = 'This is legacy vim script code block.'\<CR>",
\    "echo s:var\<CR>",
\    "endfunction\<ESC>",
\    {'text': "G2kO"},
\    "\" Let's execute the following two lines.  As :let command is invalid in " .
\       "Vim9 script, the execution will fail if this hook always complete :vim9script " .
\       "line.\<ESC>",
\    {'text': 'jVj', 'wait': 500},
\    s:getExcmdScript('QuickRun'),
\    {'text': 'ko'},
\    "Yes, this code block is also executed successfully!" .
\       "  This hook is clever enough to add :vim9script line ONLY IF NECESSARY.\<ESC>",
\  ],
\})

nnoremap @ <Cmd>call autoplay#run()<CR>
