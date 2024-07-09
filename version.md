History
=======

Version 2.3 (2024/07/09)
------------------------

Make the code more robust to wrong g:remotions_motions values.
In particular `g:remotions_motions = { 'TtFf' : [] }` induced by:
```lua
vim.g.remotions_motions = { TtFf = {}}
```


Version 2.2 (2024/05/25)
------------------------

Make sure custom `t`, `T`, `f`, `F` mappings are not overridden (if defined) (issue #8)

Prevent the warning message to appear (issue #7):
```
Error detected while processing function <SNR>183_RepeatMotion:
line   15:
E1206: Dictionary required for argument 1
```

Version 2.1 (2023/12/04)
----------------------

Correct the hijacking of global mapping.


Version 2 (2023/11/24)
----------------------

Add `motion` and `motion_plug` option.

Add support for [leap](https://github.com/ggandor/leap.nvim)


Version 1 (2023/10/20)
----------------------

Initial version

