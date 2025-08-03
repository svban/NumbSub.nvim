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
:NumbSub p<pattern> m<s|a|p|r|R> [s<start>] [n<count>] [S<step>] [w|W|w<width>|W<width>] [l<loop>|L<loop>] [c]
```

## Arguments
- **p** - define the pattern here - should be a number only pattern while using mp & ma
- [**s**] - start of the sequence - defaults to 0 if not provided
- [**S**] - step size - defaults to 1 if not provided
- [**n**] - add step size only after n substitutions, for example increase counter only after 4 substitutions - defaults to 1 if not provided
- [**w**] - width - specify a number with w<width> or use only w for auto width - doesn't take negative sign into account
- [**W**] - Width - specify a number with W<width> or use only W for auto width - takes negative sign into account
- [**l**] - loop - loop the pattern after l*n.
- [**L**] - loop - loop the pattern after l.
- [**c**] - confirm on each match
- [**fmt:**] - uses lua string.format(), similar to C's printf. 
### Modes
- **ms** : sequence - just replace the pattern with the list of numbers generated
- **mr** : reverse sequence - start replacing pattern from the bottom of the list generated and then take n in to account
- **mR** : Reverse sequence - first take number of matches into account then start replacing pattern from the bottom of the list generated
- **mp** : progressive - add list of numbers generated to the pattern
- **ma** : add - add step to the pattern, only **S** and **p** is mandatory when using this mode

## Examples

### Before
``` vim
0
0
0
0
0
0
10
0
0
0
```

### After
``` vim
:NumbSub s1 p\d\+$ n2 ms
1
1
2
2
3
3
4
4
5
5
```

``` vim
:NumbSub p\d\+$ S5 ma w
05
05
05
05
05
05
15
05
05
05
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 mp w3
001
001
002
002
003
003
014
004
005
005
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 mr
5
5
4
4
3
3
2
2
1
1
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 mR
10
10
9
9
8
8
7
7
6
6
```

``` vim
:NumbSub s1 p\d\+$ S-1 n1 ms W
01
00
-1
-2
-3
-4
-5
-6
-7
-8
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 ms l3
1
1
2
2
3
3
1
1
2
2
```

``` vim
:NumbSub s1 p\d\+$ S1 n2 ms L3
1
1
2
1
1
2
1
1
2
1
```

``` vim
:NumbSub p\d\+$ ms s0 S0.25 fmt:%.2f
0.00
0.25
0.50
0.75
1.00
1.25
1.50
1.75
2.00
2.25
```

``` vim
:NumbSub p\d\+ ms s0 S0.25 fmt:Label_%02d
Label_00
Label_00
Label_00
Label_00
Label_01
Label_01
Label_01
Label_01
Label_02
Label_02
```

## Inspirations
- [Increment.vim](https://www.vim.org/scripts/script.php?script_id=842) - William Natter
- [Increment_new.vim](https://www.vim.org/scripts/script.php?script_id=1199) - Ely Schoenfeld
