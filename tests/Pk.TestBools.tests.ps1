BeforeAll {
    Get-module picky -All| CountOf | Remove-module
    $ModPath =
        Join-Path $PSScriptRoot '../Picky/Picky.psm1'
        # $PSCommandPath -replace '\.tests.ps1$', '.psm1'
    Import-Module -Force -PassThru $ModPath
       | Join-String -Prop { $_.Name, $_.Version -join ': ' }| out-host
    $ErrCountStart = $Error.Count
    $Error.Count
        | Join-String -f 'ErrCountStart: {0}'
        | write-host -bg 'darkyellow'
    $PSStyle.OutputRendering = 'ansi'

    $PSDefaultParameterValues['Pk.TestBools:Verbose'] = $True
}
AfterAll {
    $PSDefaultParameterValues.Remove('Pk.TestBools:Verbose')
    $PSStyle.OutputRendering = 'ansi'
    'ErrCountEnd: {0} [ +{1} ]' -f @(
        $Error.Count
        $Error.Count - $ErrCountStart
    )
        | write-host -back 'darkwyellow'
}

Describe 'Picky.TestBools : All Aliases are Implemented'  -Skip -tag 'waiting on implementation question' {
    BeforeAll {
        $All_Command_AliasNames = @(
            Nin.Ast.FromGcm.GetCommandAliases -CommandName 'Picky.TestBools'
        )
        $All_AliasNames_AsCmdInfo =
            ( Get-Command Picky.TestBools ).ScriptBlock.Attributes.Where({$_ -is [Alias]}).AliasNames.forEach({gcm $_})
            # @(Nin.Ast.FromGcm.GetCommandAliases -CommandName Picky.TestBools).ForEach({ Get-Command $_ })

    }
    Context 'Mode: <ModeName>' -ForEach @(
        @{ ModeName = 'AsPipeline' }
        @{ ModeName = 'AsParameter' }
    ) -Tag @('Alias.IsImplemented') {
        it '<_> : <name> does not throw' -ForEach @(
            @( $All_AliasNames_AsCmdInfo )
        ) {
            $whichAlias = $_
            $data = $true, $false
            switch( $ModeName ) {
                'AsParameter' {
                    { & ($WhichAlias) -in $data } | Should -not -throw
                }
                'AsPipeline' {
                    $data | Pk.SomeTrue | Should -be $Expected
                }
                default { throw "UnhandledMode: $WhichMode"}
            }
        }
    }
}
Describe 'Picky.TestBools Cases'  {
    BeforeAll {
        $Samples           = [ordered]@{}
        $Samples.Mixed     = @( $false, $true, $true, $null, '', ' ')
        $Samples.SomeTrue  = @( $false, $true, $true, $null, '', ' ')
        $Samples.SomeFalse = @( $false, $true, $true, $null, '', ' ')
        $Samples.SomeNull  = @( $false, $true, $true, $null, '', ' ')
        $Samples.SomeBlank = @( $false, $true, $true, $null, '', ' ')
    }
    Context 'Mode: <_>' -ForEach @(
        'AsPipeline', 'AsParameter'
    ) -Tag @() {
        it '<_> : <name> is <expected>' -ForEach @(
            @{
                Name = 'SomeTrue'
                In = $Samples.SomeTrue
                Expected = $true
            }
            @{ Name = 'Last'  }
        ) {
            $whichMode = $_
            switch( $WhichMode ) {
                'AsParameter' {
                    Pk.SomeTrue -in $In | Should -be $Expected
                }
                'AsPipeline' {
                    $In | Pk.SomeTrue | Should -be $Expected
                }
                default { throw "UnhandledMode: $WhichMode"}
            }
        }
    }
    # it '<SubStr> in <Str> using <ComparisonType>' -ForEach @(
    #     @{
    #         In = 'foo.PS1'
    #         SubStr = '.ps1'
    #         ComparisonType = 'CurrentCulture'
    #         Expect = $false
    #     }
    # ) {
    #     Picky.String.EndsWith -in $In -SubString $SubStr -ComparisonType $ComparisonType
    #         | Should -be $Expect
    # }
}
