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


# Requirements

Tested on Vim >= 8.2 and Neovim >= 0.8.3


# Installation

For [vim-plug](https://github.com/junegunn/vim-plug) users:
```
Plug 'vds2212/vim-remotions
```

## Configuration

### Direction

The direction of the repeated motion can be configured using the `g:remotions_direction`
```
" Set the direction of the repetition to the initial move (the Vim default):
let g:remotions_direction = 0
```

```
" Set the direction of the repetition to the document:
let g:remotions_direction = 1
```

### Motions

It is possible to configure the motion that should be considered:

```
" For each motion pairs three information has to be provided:
" - Name of the pair
" - The backward action
" - The forward action
let g:remotions_motions = {
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
```
let g:remotions_motions = {
    \ 'para' : { 'backward' : '{', 'forward' : '}' },
    \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
    \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
    \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
    \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
    \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
    \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
    \
    \ 'line' : { 'backward' : 'k', 'forward' : 'j' },
    \ 'word' : { 'backward' : 'b', 'forward' : 'w' },
    \ 'fullword' : { 'backward' : 'B', 'forward' : 'W' },
    \ 'wordend' : { 'backward' : 'ge', 'forward' : 'e' },
    \ 'cursor' : { 'backward' : 'h', 'forward' : 'l' },
    \ 'pos' : { 'backward' : '<C-i>', 'forward' : '<C-o>' },
    \ 'page' : { 'backward' : '<C-u>', 'forward' : '<C-d>' },
    \ 'pagefull' : { 'backward' : '<C-b>', 'forward' : '<C-f>' },
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

## Similar Projects

- [repmo.vim](https://www.vim.org/scripts/script.php?script_id=2174)
- [repeatable-motions.vim](https://www.vim.org/scripts/script.php?script_id=4914)
- [repeat-motion](https://www.vim.org/scripts/script.php?script_id=3665)

