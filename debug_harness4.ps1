$error.Clear()

Import-module -Force -pass -ea 'stop' (gi -ea stop 'H:\data\2024\pwsh\Modules.devNin.🦍\Picky\Picky\Picky.psm1')


( $found_multi = [regex]::Matches('2 d23 ew', '(?x)
    (?<Term>.+?)' ) ) | Ft
( $found_one = [regex]::Matches('32 d23 ew', '(?x)
    (?<Term>^.*)$' ) ) | Ft

h1 'multi'
$found_multi| Picky.ConvertFrom.RegexCollection
h1 'one'
$found_one | Picky.ConvertFrom.RegexCollection


$Sample ??= @{}
$Sample.Basic = @'
file="fod  fbarsf" bar="sdfds"
        file="fod  fbarsf" bar="sdf     ds"

    key=value file="foo bar"

  key=00000215a1d221f0
  bar=3.4255
File"dsfs"
'@

$Sample.Real = @'
file="modi  nfo.lua" indx=2408 inflSize=0kb readTime=0ms
file="modinfo.lua" indx=2408 inflSize=0kb readTime=0ms

file=".luacheckrc" indx=4 inflSize=1kb readTime=0ms
       file="anims  /icexuick_100/cursornormal_0.png" indx=8 inflSize=2kb readTime=0ms
[t=00:00:00.843381] 	file=cursornormal_0.png indx=9 inflSize=3kb readTime=0ms
[t=00:00:00.843388] 	file="anims  cursornormal_0.png" indx=7 inflSize=2kb readTime=0ms
'@
$Sample.Real_AsList = $Sample.Real -split '\r?\n'

( $found_basic = [regex]::Matches(
    $Sample.Real, '(?xm)(?<Crumb>\w+)' ) ) | ft -auto

$found_basic | Pk.From-RegexGroup

( $found_asList = [regex]::Matches(
    $Sample.Real_AsList, '(?xm)(?<Crumb>\w+)' ) ) | ft -auto

$found_asList | Pk.From-RegexGroup
