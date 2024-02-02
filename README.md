# quickrun-hook-auto\_run\_in\_vim9
A [quickrun.vim](https://github.com/thinca/vim-quickrun) hook to make it easy to run Vim9 script code block.

![](https://github.com/mityu/vim-quickrun-hook-auto_run_in_vim9/assets/24771416/3369dfe8-43c2-4973-82b4-0b1634edf0f4)

This demo is powered by [autoplay.vim](https://github.com/kawarimidoll/autoplay.vim) plugin.  Thank you!

# Example configuration

Write this in your .vimrc.

```vim
if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
let g:quickrun_config.vim = {'hook/auto_run_in_vim9/enable': 1}
```
