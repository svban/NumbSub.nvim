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
