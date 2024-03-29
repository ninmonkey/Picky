err -clear
Import-Module -force -passthru (Join-Path $PSScriptRoot './Picky/Picky.psm1')
    | Render.ModuleName
# impo picky -PassThru -Force
    # | Render.ModuleName
$PSDefaultParameterValues['Pk.TestBools:Verbose'] = $True
$PSDefaultParameterValues.Remove('Pk.TestBools:Verbose')
hr

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

function Sample.Rebuild {
    param()

    $h       = [ordered]@{}
    $h.Mixed = @( $false, $true, $true, $null, '', ' ')

    $h.SomeTrue = @( $false, $true, $true, $null, '', ' ')
    $h.OnlyTrue = @( $true, $true )
    $h.NoneTrue = @( $false, '', '  ' )

    $h.SomeFalse = @( $false, $true, $true, $null, '', ' ')
    $h.OnlyFalse = @( $false, $false )
    $h.NoneFalse = @( $true, ' ' )

    $h.SomeNull = @( $false, $true, $true, $null, '', ' ')
    $h.OnlyNull = @( $Null, $Null )
    $h.NoneNull = @( 0, '', $false, ' ' )

    $h.SomeBlank = @( $false, $true, $true, $null, '', ' ')
    $h.OnlyBlank = @( ' ', '' )

    $h.EmptyList      = @()
    $h.ScalarNull     = $Null
    $h.ScalarTrue     = $True
    $h.ScalarFalse    = $false
    $h.ScalarBlank    = ''
    $h.ScalarEmptyStr = [string]::Empty
    return $h
}
$Samples = Sample.Rebuild

$targetCmd = gcm Picky.TestBools


Pk.AnyTrue -InputObject @( $false, $true ) | SHould -be $True
@( $false, $true ) | Pk.AnyTrue | SHould -be $True
Pk.AllTrue -InputObject @( $false, $true ) | SHould -be $false
@( $false, $true ) | Pk.AllTrue | SHould -be $false
# find-blank
function FindBlank { process {
    if( Picky.String.Test -In $_ Blank ) { $_ }

    # if( [string]::IsNullOrWhiteSpace( $_.Verb  ) ) {
    #     $_
    # }
}}

function InlineHardTestsBeforePesterStructure {
    $Samples.OnlyTrue    | Pk.AnyTrue    | Should -be $true
    $Samples.NoneTrue    | Pk.AnyTrue    | Should -be $false

    $Samples.SomeFalse   | Pk.AllFalse   | Should -be $false
    $Samples.OnlyFalse   | Pk.AllFalse   | Should -be $true

    $Samples.SomeFalse   | Pk.AllTrue    | Should -be $false
    $Samples.OnlyFalse   | Pk.AllTrue    | Should -be $false
    $Samples.OnlyTrue    | Pk.AllTrue    | Should -be $true

    $Samples.SomeTrue    | Pk.NoneTrue   | Should -be $false
    $Samples.OnlyFalse   | Pk.NoneTrue   | Should -be $true
    $Samples.OnlyTrue    | Pk.NoneTrue   | Should -be $false
    $Samples.ScalarTrue  | Pk.NoneTrue   | Should -be $false
    $Samples.ScalarFalse | Pk.NoneTrue   | Should -be $true
    $Samples.ScalarNull  | Pk.NoneTrue   | Should -be $true
    $Samples.ScalarBlank | Pk.NoneTrue   | Should -be $true

    $Samples.OnlyNull    | Pk.NoneNull   | Should -be $false
    $Samples.NoneNull    | Pk.NoneNull   | Should -be $true
    $Samples.OnlyFalse   | Pk.NoneNull   | Should -be $true
    $Samples.OnlyTrue    | Pk.NoneNull   | Should -be $true
}
InlineHardTestsBeforePesterStructure
hr
'finished inline pester' | write-host -fore white -bg 'darkgreen'
hr

# function Picky.Coalesce {

# }
$blanky = gcm  | Group { [string]::IsNullOrWhiteSpace( $_.Source ) } | ? Name  -eq $true | % Group
# $blanky | one 21 | FindBlank
$blanky | one 21 | FindBlank | ft Verb, *

h1 'try new filter'

$blanky[0] | Picky.Where-Object -BlankProp Source
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
