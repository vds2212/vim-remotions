# Remotions

## Introduction

The `;` and `,` keys are repeating the `f`, `F`, `t` and `T` motions.
But for the other motions there are no builtin ways to repeat them.

The goal of this plugin is allow to repeat the other motions with the `;` and `,` keys.

It is particularly useful for double characters motions likes next/previous method: `[m`/`]m`.

### Count

It is also useful for motions with a count `10j` (10 lines down).
It is possible to configure some motions to be repeatable only if they are executed with a count above 1.

### Repetition Direction

The repetition of the motions can be configured as to be done in the direction of:
- the initial motion (`;` repeat the motion, `,` undo the motion, the Vim default) or of
- the document (`;` goes forward, `,` goes backward)

e.g. When the `[m` motion will be repeated:

If "direction of the document" has been selected then:
- The forward repetition `;` will do `]m` and
- The backward repetition `,` will do `[m`

If "direction of the initial motion" has been selected then:
- The forward repetition `;` will do `[m` and
- The backward repetition `,` will do `]m`

### Advantages

The advantages of remotions on the other existing plugins identified are:
- support also plugin motions/operation defined both globally or at buffer level
- support repetition of movements including their count if different from 1 (optional)


## Requirements

Tested on Vim >= 8.2 and Neovim >= 0.8.3


## Installation

For [vim-plug](https://github.com/junegunn/vim-plug) users:
```vim
Plug 'vds2212/vim-remotions'
```

## Configuration

### Motions

It is possible to configure the motions that should be considered:
For each motion three information have to be provided and some options can be set:
- The `name` of the motion (e.g. `para`)

- The `backward` motion key sequence (e.g. `{`)
- The `forward` motion key sequence (e.g. `}`)

- The `repeat_if_count` option for the motion.
  If set the motion is repeatable only if it has been executed with a count above of 1.

- The `repeat_count` option for the motion.
  If present overrides `g:remotions_repeat_count` of the motion.
  Remark: Not all motions support count.
  If the original motion does not support count the repetition will also not.

- The `direction` option for the motion.
  If present overrides `g:remotions_direction` of the motion.

Here is the Remotions default:
```vim
let g:remotions_motions = {
    \ 'TtFf' : {},
    \ 'para' : { 'backward' : '{', 'forward' : '}' },
    \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
    \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
    \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
    \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
    \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
    \
    \ 'buffer' : { 'backward' : '[b', 'forward' : ']b'},
    \ 'location' : { 'backward' : '[l', 'forward' : ']l'},
    \ 'quickfix' : { 'backward' : '[q', 'forward' : ']q'},
    \ 'tag' : { 'backward' : '[t', 'forward' : ']t'},
    \
    \ 'diagnostic' : { 'backward' : '[g', 'forward' : ']g'},
    \ }
```

Here is an more extensive list of motions:
```vim
let g:remotions_motions = {
    \ 'TtFf' : {},
    \ 'para' : { 'backward' : '{', 'forward' : '}' },
    \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
    \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
    \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
    \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
    \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
    \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
    \
    \ 'line' : {
    \    'backward' : 'k',
    \    'forward' : 'j',
    \    'repeat_if_count' : 1,
    \    'repeat_count': 1
    \ },
    \ 'displayline' : {
    \    'backward' : 'gk',
    \    'forward' : 'gj',
    \ },
    \
    \ 'char' : { 'backward' : 'h',
    \    'forward' : 'l',
    \    'repeat_if_count' : 1,
    \    'repeat_count': 1
    \ },
    \
    \ 'word' : {
    \    'backward' : 'b',
    \    'forward' : 'w',
    \    'repeat_if_count' : 1,
    \    'repeat_count': 1
    \ },
    \ 'fullword' : { 'backward' : 'B',
    \    'forward' : 'W',
    \    'repeat_if_count' : 1,
    \    'repeat_count': 1
    \ },
    \ 'wordend' : { 'backward' : 'ge',
    \    'forward' : 'e',
    \    'repeat_if_count' : 1,
    \    'repeat_count': 1
    \ },
    \
    \ 'pos' : { 'backward' : '<C-i>', 'forward' : '<C-o>' },
    \
    \ 'page' : { 'backward' : '<C-u>', 'forward' : '<C-d>' },
    \ 'pagefull' : { 'backward' : '<C-b>', 'forward' : '<C-f>' },
    \
    \ 'undo' : { 'backward' : 'u', 'forward' : '<C-r>', 'direction' : 1 },
    \
    \ 'linescroll' : { 'backward' : '<C-e>', 'forward' : '<C-y>' },
    \ 'columnscroll' : { 'backward' : 'zh', 'forward' : 'zl' },
    \ 'columnsscroll' : { 'backward' : 'zH', 'forward' : 'zL' },
    \
    \ 'vsplit' : { 'backward' : '<C-w><', 'forward' : '<C-w>>' },
    \ 'hsplit' : { 'backward' : '<C-w>-', 'forward' : '<C-w>+' },
    \
    \ 'arg' : { 'backward' : '[a', 'forward' : ']a'},
    \ 'buffer' : { 'backward' : '[b', 'forward' : ']b'},
    \ 'location' : { 'backward' : '[l', 'forward' : ']l'},
    \ 'quickfix' : { 'backward' : '[q', 'forward' : ']q'},
    \ 'tag' : { 'backward' : '[t', 'forward' : ']t'},
    \
    \ 'diagnostic' : { 'backward' : '[g', 'forward' : ']g'},
    \ }
```

Remark: The `TtFf` motion corresponds to the `e`, `f` motions.
The entry can be used to specify the options for that motion (i.e.: `repeat_if_count`, `repeat_count`, `direction`).

#### Lua example
The following is an example of usage with [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
local motions = {
  para = { backward = "{", forward = "}" },
  sentence = { backward = "(", forward = ")" },
  change = { backward = "g,", forward = "g;" },
  class = { backward = "[[", forward = "]]" },
  classend = { backward = "[]", forward = "][" },
  method = { backward = "[m", forward = "]m" },
  methodend = { backward = "[M", forward = "]M" },
  line = { backward = "k", forward = "j", repeat_if_count = 1, repeat_count = 1 },
  char = { backward = "h", forward = "l", repeat_if_count = 1, repeat_count = 1 },
  word = { backward = "b", forward = "w", repeat_if_count = 1, repeat_count = 1 },
  fullword = { backward = "B", forward = "W", repeat_if_count = 1, repeat_count = 1 },
  wordend = { backward = "ge", forward = "e", repeat_if_count = 1, repeat_count = 1 },
  pos = { backward = "<C-i>", forward = "<C-o>" },
  page = { backward = "<C-u>", forward = "<C-d>" },
  pagefull = { backward = "<C-b>", forward = "<C-f>" },
  undo = { backward = "u", forward = "<C-r>", direction = 1 },
  linescroll = { backward = "<C-e>", forward = "<C-y>" },
  charscroll = { backward = "zh", forward = "zl" },
  vsplit = { backward = "<C-w><", forward = "<C-w>>" },
  hsplit = { backward = "<C-w>-", forward = "<C-w>+" },
  arg = { backward = "[a", forward = "]a" },
  buffer = { backward = "[b", forward = "]b" },
  location = { backward = "[l", forward = "]l" },
  quickfix = { backward = "[q", forward = "]q" },
  tag = { backward = "[t", forward = "]t" },
  diagnostic = { backward = "[g", forward = "]g" },
}

local leap_motions = {
  leap_fwd = {
    backward = "<Plug>(leapbackward)",
    forward = "<Plug>(leapforward)",
    motion = "s",
    motion_plug = "<Plug>(leap-forward-to)",
  },
  leap_bck = {
    backward = "<Plug>(leapforward)",
    forward = "<Plug>(leapbackward)",
    motion = "S",
    motion_plug = "<Plug>(leap-backward-to)",
  },
}

return {
  "vds2212/vim-remotions",
  event = { "BufRead", "BufWinEnter", "BufNewFile" },

  config = function()
    if vim.g.loaded_leap then
      vim.g.remotions_motions = vim.tbl_deep_extend("error", motions, leap_motions)
    else
      vim.g.remotions_motions = motions
    end
  end,
}
```
Note: If using leap.nvim, you'll need to manually set `vim.g.loaded_leap` until [this leap issue](https://github.com/ggandor/leap.nvim/issues/200) is resolved.

### Direction

The direction of the repeated motion can be configured using the `g:remotions_direction`
```vim
" Set the direction of the repetition to the direction of the initial move (the Vim default):
let g:remotions_direction = 0
```

```vim
" Set the direction of the repetition to the direction of the document:
let g:remotions_direction = 1
```

Remark: This `g:remotions_direction` setting is overridden by the `direction` option of the motion if set.

### Repeat Count

Some motions support `count` (e.g. `i`, `j`, `}`, etc.). E.g.: `2j` make the cursor go 2 lines below.

When a motion is repeated via `;` or `,` the original count is not take into consideration.
This is also the Vim default for the `f` and `t` motions.

If you want that the original count is taken in consideration:
```vim
" Make the ; and , key also repeat the count when supported by the original move
let g:remotions_repeat_count = 1
```
Remark: This `g:remotions_repeat_count` is overridden by the `repeat_count` option of the motion if set.


### Special Motion

Motion plugins are special because:
- They are triggered by a key or a key combination that is not the one used to repeat the action
- The hijacking of the trigger could requires some hint

Here are the configurations proposed for some of the popular ones:
- [vim-easymotion](https://github.com/easymotion/vim-easymotion)
- [leap.nvim](https://github.com/ggandor/leap.nvim)
- [vim-sneak](https://github.com/justinmk/vim-sneak)


#### EasyMotion

Here is a solution for repeating the [vim-easymotion](https://github.com/easymotion/vim-easymotion) motions:

```vim
let g:remotions_motions = {
   \   'leap_fwd' : {
   \       'backward' : '<Plug>(easymotion-prev)',
   \       'forward' : '<Plug>(easymotion-next)',
   \       'motion': '<leader><leader>',
   \       'motion_plug' : '<Plug>(easymotion-prefix)'
   \   },
   \ }
```

#### Leap

Here is a solution for repeating the [leap.nvim](https://github.com/ggandor/leap.nvim) motions:

```vim
lua require('leap').add_repeat_mappings('<Plug>(leapforward)', '<Plug>(leapbackward)')

let g:remotions_motions = {
   \   'leap_fwd' : {
   \       'backward' : '<Plug>(leapbackward)',
   \       'forward' : '<Plug>(leapforward)',
   \       'motion': 's',
   \       'motion_plug' : '<Plug>(leap-forward-to)'
   \   },
   \   'leap_bck' : {
   \       'backward' : '<Plug>(leapbackward)',
   \       'forward' : '<Plug>(leapforward)',
   \       'motion': 's',
   \       'motion_plug' : '<Plug>(leap-backward-to)'
   \   },
   \ }
```

#### Sneak

Here is a solution for repeating the [vim-sneak](https://github.com/justinmk/vim-sneak) motions:

```vim
let g:remotions_motions = {
      \ 'sneak_fwd' : {
      \     'backward' : '<Plug>Sneak_,',
      \     'forward' : '<Plug>Sneak_;',
      \     'motion': 's',
      \     'motion_plug' : '<Plug>Sneak_s'
      \ },
      \ 'sneak_bckwd' : {
      \     'backward' : '<Plug>Sneak_,',
      \     'forward' : '<Plug>Sneak_;',
      \     'motion': 's',
      \     'motion_plug' : '<Plug>Sneak_S'
      \ },
```

## Similar Projects

### Repmo

The [repmo.vim](https://www.vim.org/scripts/script.php?script_id=2174)
or its new [version](https://github.com/Houl/repmo-vim)
is mature plugin used by a number of people.

In my experience repmo works well for builtin commands.
But when the builtin command are overridden for a specific `filetype` (e.g. `]m` for the `python` `filetype`).
or when it is overridden by a `filetype` plugin (e.g. `]m` with [pythonsense](https://github.com/jeetsukumaran/vim-pythonsense))
I had difficulty to make it working (I failed).

I'm wondering also how repmo handle commands that are overridden by two different plugins for two different `filetype`.

These difficulty made me write [remotions](https://github.com/vds2212/vim-remotions).

If one of the previous statements about repmo is imprecise or wrong I'll more than happy to rectify the text.
Raise an issue and I will adapt the text of this readme file.


### Repeatable-Motions

The [repeatable-motions.vim](https://www.vim.org/scripts/script.php?script_id=4914) is a mature plugin.

It introduces four keys to repeat the motions:
- <kbd>Ctrl j</kbd>, <kbd>Ctrl k</kbd> for the vertical motions.
- <kbd>Ctrl h</kbd>, <kbd>Ctrl l</kbd> for the horizontal motions.

In my experience repeatable-motions works well for builtin commands.
It supports a number of builtin motions.

But when the builtin command are overridden for a specific `filetype` (e.g. `]m` for the `python` `filetype`).
or when it is overridden by a `filetype` plugin (e.g. `]m` with [pythonsense](https://github.com/jeetsukumaran/vim-pythonsense))
I had difficulty to make it working (I failed).

If one of the previous statements about repeatable-motions is imprecise or wrong I'll more than happy to rectify the text.
Raise an issue and I will adapt the text of this readme file.


### Repeat Motion

According to the documentation [repeat-motion](https://www.vim.org/scripts/script.php?script_id=3665)
only repeat a set of predefined builtin motions (i.e. `k`, `j`, `h`, `l`, `w`, `b`, `W`, `B`, `e`, `E`, `ge`, `gE`)

