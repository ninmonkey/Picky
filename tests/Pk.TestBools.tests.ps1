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
        | write-host -back 'darkyellow'
    $PSStyle.OutputRendering = 'ansi'
}
AfterAll {
    $PSStyle.OutputRendering = 'ansi'
    'ErrCountEnd: {0} [ +{1} ]' -f @(
        $Error.Count
        $Error.Count - $ErrCountStart
    )
        | write-host -back 'darkwyellow'
}

Describe 'Picky.TestBools' {
    Context 'Mode: <_>' -ForEach @(
        'AsPipeline', 'AsParameter'
    ) -Tag @() {
        it '<_> was <name>' -ForEach @(
            @{ Name = 'first' }
            @{ Name = 'Last'  }
        ) {
            $false | should -be $true
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
