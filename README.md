## Description
- This plugin will replace the pattern with the list of numbers generated.

## Installation
###  with Lazy.nvim
``` lua
    {
        "svban/NumbSub.nvim",
        cmd = { "NumbSub" },
        opts = {},
    },
```

## Usage: 
``` vim
:NumbSub p<pattern> s<start> n<count> S<step> [w<width>|W<width>|w|W] m<s|a|p|r|R> [c]
```

## Arguments
- **s** - start of the sequence
- **S** - step size
- **n** - add step size only after n substitutions, for example increase counter only after 4 substitutions
- **p** - define the pattern here - should be a number only while using mp & ma
- [**w**] - width - specify a number with w<width> or use only w for autowidth - doesn't take negative sign into account
- [**W**] - Width - specify a number with W<width> or use only W for autowidth - takes negative sign into account
- [**c**] - confirm on each match
### Modes
- **ms** : sequence - just replace the pattern with the list of numbers generated
- **mr** : reverse sequence - start replacing pattern from the bottom of the list generated and then take n in to account
- **mR** : Reverse sequence - first take n into account, start replacing pattern from the bottom of the list generated
- **mp** : progressive - add list of numbers generated to the pattern
- **ma** : add - add step to the pattern, only **S** and **p** is mandatory when using this mode

## Examples

### Before
``` vim
define MEM_ADD0 0
define MEM_ADD1 0
define MEM_ADD1 0
define MEM_ADD2 0
define MEM_ADD3 0
define MEM_ADD0 0
define MEM_ADD1 10
define MEM_ADD2 0
define MEM_ADD3 0
define MEM_ADD3 0
```

### After
``` vim
:NumbSub s1 p@ S1 n2 ms
define MEM_ADD0 1
define MEM_ADD1 1
define MEM_ADD1 2
define MEM_ADD2 2
define MEM_ADD3 3
define MEM_ADD0 3
define MEM_ADD1 4
define MEM_ADD2 4
define MEM_ADD3 5
define MEM_ADD3 5
```

``` vim
:NumbSub p\d\+$ S5 ma w
define MEM_ADD0 06
define MEM_ADD1 06
define MEM_ADD1 07
define MEM_ADD2 07
define MEM_ADD3 08
define MEM_ADD0 08
define MEM_ADD1 09
define MEM_ADD2 09
define MEM_ADD3 10
define MEM_ADD3 10
```
