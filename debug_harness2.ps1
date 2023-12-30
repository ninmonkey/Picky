err -clear
# Import-Module -force -passthru Join-Path ($PSScriptRoot './Picky/Picky.psm1')
#     | Render.ModuleName

$sample ??= @{}

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
