
$t1 = [int]
[Func`2].MakeGenericType($t1, [string])




function dbg.ProcessParamLog {
    param(
        [string]$Path,
        [string]$TemplateName
    )
    $FulLName = Get-Item -ea 'stop' $Path
    $re = @'
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

        function __fmtLineTemplate {
            param(
                [Parameter(Mandatory)]
                [object]$InputObject,

                [Parameter(Mandatory)]
                [ArgumentCompletions(
                    'Default',
                    'A'
                )]
                [string]$Template = 'Default'
            )
            $T = $InputObject
            switch($Template) {
                'A' {
                    Join-String -In $T -p { @(
                        $_.Severity
                        $_.SOmeId
                        $_.Message

                    ) -join ''}
                }
                'Predent' {
                   $t | Join-String -p {@(
                        $_.Source | Join.Predent -Depth 0
                        $_.Severity | Join.Predent -Depth 1
                        $_.Message  | Join.Predent -Depth 2
                            ) -join "`n" }
                }
                '::' {@(
                    $t.Severity,
                    $t.RawMessage -join '::'
                ) -join ''}
                'PassThru' {
                    $t
                }
                default {
                    throw "Unhandled template: $Template"
                }
            }
        }


    $TemplateName | Join-String -op 'End: Template: '
        | write-verbose -Verbose

    gc -Raw $FulLName | StripAnsi | split.NL
        | %{
            if( $_ -match $Re ) { [pscustomobject]$Matches }
        } | Join-String -sep "`n" -p {
            __fmtLineTemplate -In $_ -Template $TemplateName
        }

    gc $FullLogPath | OutNull -Extra 'raw line count'
}

$FullLogPath = gi 'C:\Users\cppmo_000\AppData\Local\Temp\ParamBinding.log.raw'

dbg.ProcessParamLog -path $FullLogPath -Template 'Default'
function tryF {
    param( [string]$Template )
    dbg.ProcessParamLog -path $FullLogPath -Template $Template

}







return



function FindIndex.ForMatch {
    <#
    .synopsis
        FindIndexFor 'foo', '--no-auto-cli-prompt', '--output', 'json' -ToMatch '--output'
        # outputs 2
    #>
    [OutputType( [int] )]
    param(
        [Parameter(Mandatory)]
        [List[Object]]$Items,
        [string]$ToMatch
    )
    $sb = {
        param( $i )
        $i -match $ToMatch
    }
    return $items.FindIndex( $sb )
}
function List.FindIndex.For {
    <#
    .synopsis
        FindIndexFor 'foo', '--no-auto-cli-prompt', '--output', 'json' -ToMatch '--output'
        # outputs 2
    #>
    [Alias('FindIndex.For')]
    [OutputType( [int] )]
    param(
        [Parameter(Mandatory)]
        [List[Object]]$Items,

        [Parameter(Mandatory, ParameterSetName='AsMatchAnyRegex')]
        [string[]]$MatchAnyRegex,

        [Parameter(Mandatory, ParameterSetName='AsMatchAllRegex')]
        [string[]]$MatchAllRegex,

        [Parameter(Mandatory, ParameterSetName='AsMatchNoneRegex')]
        [string[]]$MatchNoneRegex
    )
    $sb = {
        param( $InObj )

        switch( $PSCmdlet.ParameterSetName ) {
            'AsMatchAllRegex' {
                $MatchAllRegex.ForEach({ $InObj -match $_ }).count -eq $MatchAllRegex.count
            }
            'AsMatchNoneRegex' {
                $MatchNoneRegex.Where({ $InObj -match $_ }).count  -eq 0
            }
            'AsMatchAnyRegex' {
                $MatchAnyRegex.Where({ $InObj -match $_ }, 'first').count -gt 0
            }
            default { throw ("FindIndex.For: UnhandledParameterSet: {0}" -f $PSCmdlet.ParameterSetName) }
        }
    }
    return $items.FindIndex( $sb )
}

$sample.A = @'
fd -e dll --search-path (gi ~) -d05
'@
write-warning 'note: -split ' ' will not work correctly for this example so I need to
    use AST'
