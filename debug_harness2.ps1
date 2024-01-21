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


function Pk.TestBools {
    <#
    .SYNOPSIS
        Check if a bunch of bools are all true, or any true, or none true, or all null, or all blank, etc...
    .DESCRIPTION
        There are 4 main conditions
            All, None, Any, First

        And a few operands
            True,  False,
            Null,  NotNull
            Blank, NotBlank

    #>
    [OutputType('bool')]
    [Alias(
        'Pk.AnyTrue',
        'Pk.AnyFalse',
        'Pk.AnyNull',
        'Pk.AnyNotNull',
        'Pk.AnyBlank',
        'Pk.AnyNotBlank',

        'Pk.FirstTrue',
        'Pk.FirstFalse',
        'Pk.FirstNull',
        'Pk.FirstNotNull',
        'Pk.FirstBlank',
        'Pk.FirstNotBlank',

        'Pk.AllTrue',
        'Pk.AllFalse',
        'Pk.AllNull',
        'Pk.AllNotNull',
        'Pk.AllBlank',
        'Pk.AllNotBlank',

        'Pk.NoneTrue',
        'Pk.NoneFalse',
        'Pk.NoneNull',
        'Pk.NoneNotNull',
        'Pk.NoneBlank',
        'Pk.NoneNotBlank'
    )]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [object[]] $InputObject,

        # output the $filter_* variables as a hashtable
        [ValidateScript({throw 'nyi'})]
        [switch]$PassThru,

        # write errors, or throw, rather than returning bools
        [ValidateScript({throw 'nyi'})]
        [Alias('Strict', 'ErrorOnFail')]
        [switch]$Assert

    )
    begin {
        $AliasName   = $MyInvocation.InvocationName -replace '^(Picky|Pk)\.', ''
        $CompareMode = $AliasName
        [List[Object]] $tests = @()
    }
    process {
        $tests.AddRange( @( $InputObject ))
        $CompareMode | Join-String -op 'Alias: ' | Dotils.Write-DimText | Write-verbose
    }
    end {
        $full_list = $Tests
        $filter_TrueList     = @($Tests) -eq $true
        $filter_FalseList    = @($Tests) -eq $False

        $filter_NullList     = @($Tests) -eq $null
        $filter_NotNullList  = @($Tests) -ne $null

        $filter_BlankList    = @( $tests ).Where({ [string]::IsNullOrWhiteSpace($_) })
        $filter_NotBlankList = @( $tests ).Where({ [string]::IsNullOrWhiteSpace($_) })

        switch( $CompareMode ) {
            'AnyTrue' {
                $filter_TrueList.count -gt 0
                break
            }
            'AllTrue' {
                ($filter_TrueList.count -gt 0) -and ($filter_TrueList.count -eq $full_list.count)
                break
            }
            default { throw "Uhandled compare mode: $CompareMode !"}
        }

    }
}

$PSDefaultParameterValues['Pk.TestBools:Verbose'] = $True
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
