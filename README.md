## Description
- This plugin helps you replace the pattern with the list of numbers generated.
- Its basically \<C-a> or \<C-x> on steroids from command-line 
- See [examples](https://github.com/svban/NumbSub.nvim?tab=readme-ov-file#examples) to better understand

## Installation
###  with Lazy.nvim
``` lua
{
    "svban/NumbSub.nvim",
    cmd = { "NumbSub" }, -- lazy load on this command
    opts = {},
}
```

## Usage: 
``` vim
:NumbSub p<pattern> m<s|a|p|r|R> [s<start>] [n<count>] [S<step>] [w|W|w<width>|W<width>] [c]
```

## Arguments
- **p** - define the pattern here - should be a number only pattern while using mp & ma
- [**s**] - start of the sequence - defaults to 0 if not provided
- [**S**] - step size - defaults to 1 if not provided
- [**n**] - add step size only after n substitutions, for example increase counter only after 4 substitutions - defaults to 1 if not provided
- [**w**] - width - specify a number with w<width> or use only w for auto width - doesn't take negative sign into account
- [**W**] - Width - specify a number with W<width> or use only W for auto width - takes negative sign into account
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
:NumbSub s1 p\d\+$ n2 ms
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
define MEM_ADD0 05
define MEM_ADD1 05
define MEM_ADD1 05
define MEM_ADD2 05
define MEM_ADD3 05
define MEM_ADD0 05
define MEM_ADD1 15
define MEM_ADD2 05
define MEM_ADD3 05
define MEM_ADD3 05
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 mp w3
define MEM_ADD0 001
define MEM_ADD1 001
define MEM_ADD1 002
define MEM_ADD2 002
define MEM_ADD3 003
define MEM_ADD0 003
define MEM_ADD1 014
define MEM_ADD2 004
define MEM_ADD3 005
define MEM_ADD3 005
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 mr
define MEM_ADD0 5
define MEM_ADD1 5
define MEM_ADD1 4
define MEM_ADD2 4
define MEM_ADD3 3
define MEM_ADD0 3
define MEM_ADD1 2
define MEM_ADD2 2
define MEM_ADD3 1
define MEM_ADD3 1
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 mR
define MEM_ADD0 10
define MEM_ADD1 10
define MEM_ADD1 9
define MEM_ADD2 9
define MEM_ADD3 8
define MEM_ADD0 8
define MEM_ADD1 7
define MEM_ADD2 7
define MEM_ADD3 6
define MEM_ADD3 6
```

``` vim
:NumbSub s1 p\d\+$ S-1 n1 ms W
define MEM_ADD0 01
define MEM_ADD1 00
define MEM_ADD1 -1
define MEM_ADD2 -2
define MEM_ADD3 -3
define MEM_ADD0 -4
define MEM_ADD1 -5
define MEM_ADD2 -6
define MEM_ADD3 -7
define MEM_ADD3 -8
```

## Inspirations
- [Increment.vim](https://www.vim.org/scripts/script.php?script_id=842) - William Natter
- [Increment_new.vim](https://www.vim.org/scripts/script.php?script_id=1199) - Ely Schoenfeld
