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
        | write-host -back 'darkyellow'
}


Describe 'Picky.String.Clamp' {
    It 'Clamp <In> <RelPos> is <ExpectExact>' -ForEach @(

            @{
                In = 'abcd'
                RelPos = 4
                ExpectExact = 'abcd'
            }
            @{
                In = 'abcd'
                RelPos = 0
                ExpectExact = ''
            }
            @{
                In = 'abcd'
                RelPos = -1
                ExpectExact = 'abc'
            }
            @{
                In = 'abcd'
                RelPos = -10
                ExpectExact = ''
            }
            @{
                In = 'abcd'
                RelPos = 20
                ExpectExact = 'abcd'
            }
    ) {
        Picky.String.Clamp -InputText $In -RelativePos $RelPos
        | SHould -BeExactly $ExpectExact
    }
}
