err -clear
Import-Module -force -passthru (Join-Path $PSScriptRoot './Picky/Picky.psm1')
    | Render.ModuleName
# impo picky -PassThru -Force
    # | Render.ModuleName

hr
'sdf'.EndsWith


$testy = [pscustomobject]@{
    Blank = ''
    stuff = 12305
}
#  move to tests
Picky.Test-Object -PropertyName Name, Length, Missing -InputObject $testy|ft

Picky.Test-Object -in $testy -PropertyName 'Blank', 'stuff', 'dsfdsf' -NotBlank 'Blank' -BlankProp 'Blank', 'stuff'
hr
$pkSplat = @{
    PropertyName = 'Blank', 'Stuff'
    NotBlank = 'Blank', 'df'
    MissingProperty = 'cat', 'dog'
    BlankProp = 'Blank', 'Stuff'
    InputObject = $testy
}

Picky.Test-Object @pkSplat
|ft
h1 'early exit. refactor test.'




# find-blank
function FindBlank { process {
    if( [string]::IsNullOrWhiteSpace( $_.Verb  ) ) {
        $_
    }
}}

# function Picky.Coalesce {

# }
# $blanky | one 21 | FindBlank
$blanky | one 21 | FindBlank | ft Verb, *
return


$regex = @{}
$regex.ParamBindLog_SingleLine = @'
(?x)
    ^
    (?<Source>.*?)
    \s
    (?<Severity>\S*)
    :\s
    (?<SomeId>\d+)
    \s:
    (?<RawMessage>
        (?<Indent>\s+)
        (?<Message>.*)
    )
    (?<Rest>.*?)
    $
'@

gc $Log_ParamBind -Raw | StripAnsi | CountOf | SPlit.NL | %{
    if( $_ -match $Regex.ParamBindLog_SingleLine ) {
        $matches.remove(0)
        $found = [pscustomobject]$matches
    }
    $found
}| ft Source, Severity, Message

Str.EndsWith -in 'foo.NL' -SubStr '.nl' # -UsingCaseSensitive -culture 'en-us'

$Log_ParamBind = gi (Join-path temp: 'paramBind.cs')
$Log_ParamBind ??= (Join-path temp: 'paramBind.cs')

# return
Clear-Content -Path $Log_ParamBind
Trace-Command -Name '*Param*' -FilePath $Log_ParamBind -Expression {
    Str.EndsWith -in 'a.NL' -SubString '.nl'
} # it appends
$log_paramBind | join-string -f 'wrote: {0}' | write-verbose -verb
return
'a.NL' | Str.EndsWith -SubStr '.nl' # -UsingCaseSensitive -culture 'en-us'

# Str.EndsWith -InputText '.NL' -Substring '.nl' -UsingCaseSensitive -Culture 'en-us'
# Str.EndsWith -InputText '.NL' -Substring '.nl' -ComparisonType InvariantCultureIgnoreCase
return
