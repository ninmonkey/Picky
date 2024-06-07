'first: workflow try, tag, publish'

@"
next ideas

ContainsAllKeys
   ContainsAllKeys( keyNames[s] )
   ContainsAnyKeys( keyNames[s] )
NotContainsKeys( keyName[s] )  # missing any of
MissingAnyKeys ( keyName[s] )

Pk.New-ObjectFromMatch
    should generate objects with keys in the same order

    [regex]::Match('sdfds231324','(?<a>.*)(?<d>\d+)')


it'd be cool if arg completer would drill down, autodisplaying results
    like firefox

"@
... | Pk.Skip -After $StartPattern -before $EndPattern

# first completion list populated by:
$| jq '. | keys' -C

# step 1
get-culture | Json -Depth 9 -wa Ignore
| jq '. | keys' -C

# step 2
get-culture | Json -Depth 9 -wa Ignore
| jq '.Calendar | keys' -C

# step3 .... continue
JqDive 'Calendar'
$firstCompletions = get-culture | Json -Depth 9 -wa Ignore| jq '. | keys'
JqDive 'Eras'
$firstCompletions = get-culture | Json -Depth 9 -wa Ignore| jq '.Calendar | keys'

# sequence evaluates as
JqDive -Path '.' -relPath 'Calendar'
JqDive -Path '.Calendar' -Relpath 'Eras'
JqDive -Path '.Calendar.Eras' -Relpath '...next'


h1 'another commmand, to allow inline regex that are (?x) for the user'

docker --help
    | Pk.SkipBeforeMatch 'Global Options:' -IncludeMatch
    | Pk.SkipAfterMatch '^$' <# empty line #>
    | Pk.New-ObjectFromMatch @'
(?x)
    not super clean or nice

'@
