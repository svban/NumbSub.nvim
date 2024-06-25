

ARGS-
s - start of the sequence
S - step size
n - add step size only after n substitutions, for example increase counter only after 4 substitutions
p - define the pattern here - should be a number only while using mp & ma
w[optional] - width - specify a number with w<width> or use only w for autowidth - doesn't take negative sign into account
W[optional] - Width - specify a number with W<width> or use only W for autowidth - takes negative sign into account
c[optional] - confirm on each match
mode - m - 
ms - sequence - just replace the pattern with the list of numbers generated
mr - reverse sequence - start replacing pattern from the bottom of the list generated and then take n in to account
mR - Reverse sequence - first take n into account, start replacing pattern from the bottom of the list generated
mp - progressive - add list of numbers generated to the pattern
ma - add - add step to the pattern

Usage: :NumbSub s<start> p<pattern> n<count> S<step> [w<width>|W<width>|w|W] m<s|a|p|r|R> [c]
