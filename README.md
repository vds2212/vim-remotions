# Remotions

## Introduction

The `;` and `,` keys are repeating the `f`, `F`, `t` and `T` motions.
But for the other motions there are no builtin ways to repeat them. 

The goal of this plugin is allow to repeat the other motions with the `;` and `,` keys

It is particularly useful for double characters motions likes next/previous method: `[m`/`]m`.

### Repetition Direction

The repetition of the motions can be configured as to be done in the direction of:
- the initial motion or of
- the document

e.g. When the `[m` motion will be repeated:

- The forward repetition `;` will do `]m` and
- The backward repetition `,` will do `[m`
If in the direction of the document as been selected then:

- The forward repetition `;` will do `[m` and
- The backward repetition `,` will do `]m`
If in the direction of the initial motion as been selected then:


## Requirements

Tested on Vim >= 8.2 and Neovim >= 0.8.3


## Installation

For [vim-plug](https://github.com/junegunn/vim-plug) users:
```vim
Plug 'vds2212/vim-remotions'
```

## Configuration

### Motions

It is possible to configure the motion that should be considered:

```vim
" For each motion pairs three information has to be provided and some options can be set:
" - The `name` of the motion
" - The `backward` action
" - The `forward` action
"
" - The `repeat_if_count` option for the motion.
"   If set the motion is repeatable only if it has been executed with a count different of 1
" - The `repeat_count` option for the motion. If present override `g:remotions_repeat_count` for the motion
" - The `direction` option for the motion. If present override `g:remotions_direction` for the motion

let g:remotions_motions = {
    \ 'EeFf' : {},
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
    \ 'EeFf' : {},
    \ 'para' : { 'backward' : '{', 'forward' : '}' },
    \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
    \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
    \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
    \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
    \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
    \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
    \
    \ 'line' : { 'backward' : 'k', 'forward' : 'j', 'repeat_if_count' : 1, 'repeat_count': 1 },
    \ 'char' : { 'backward' : 'h', 'forward' : 'l', 'repeat_if_count' : 1, 'repeat_count': 1 },
    \ 'linescroll' : { 'backward' : '<C-e>', 'forward' : '<C-y>', 'repeat_if_count' : 1, 'repeat_count' : 1, 'direction' : 0 },
    \ 'charscroll' : { 'backward' : 'zh', 'forward' : 'zl', 'repeat_if_count' : 1, 'repeat_count' : 1, 'direction' : 0 },
    \ 'word' : { 'backward' : 'b', 'forward' : 'w', 'repeat_count': 1 },
    \ 'wordend' : { 'backward' : 'ge', 'forward' : 'e', 'repeat_count': 1 },
    \ 'fullword' : { 'backward' : 'B', 'forward' : 'W', 'repeat_count': 1 },
    \ 'pos' : { 'backward' : '<C-i>', 'forward' : '<C-o>', 'repeat_count' : 1, 'direction' : 0 },
    \ 'page' : { 'backward' : '<C-u>', 'forward' : '<C-d>', 'repeat_count' : 1 },
    \ 'pagefull' : { 'backward' : '<C-b>', 'forward' : '<C-f>', 'repeat_count' : 1},
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

Remark: The `EeFf` motion correspond to the `e`, `f` motions.
The entry can be used to specify a `repeat_count` if necessary.

### Direction

The direction of the repeated motion can be configured using the `g:remotions_direction`
```vim
" Set the direction of the repetition to the initial move (the Vim default):
let g:remotions_direction = 0
```

```vim
" Set the direction of the repetition to the document:
let g:remotions_direction = 1
```

Remark: This `g:remotions_direction` setting is overridden by the `direction` option of the motion if any.

### Repeat Count

Some motions support `count` (e.g. `i`, `j`, `}`, etc.). E.g.: `2j` make the cursor go 2 lines below.

When a motion is repeated via `;` or `,` the original count is not take into consideration.
This is also the Vim default for the `f` and `t` motions.

If you want that the original count is taken in consideration:
```vim
" Make the ; and , key also repeat the count when supported by the original move
let g:remotions_repeat_count = 1
```
Remark: This `g:remotions_repeat_count` is overridden by the `repeat_count` option of the motion if any.

## Similar Projects

- [repmo.vim](https://www.vim.org/scripts/script.php?script_id=2174)
- [repeatable-motions.vim](https://www.vim.org/scripts/script.php?script_id=4914)
- [repeat-motion](https://www.vim.org/scripts/script.php?script_id=3665)

