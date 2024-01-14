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

Describe 'Picky.String.EndsWith' {
    it '<SubStr> in <Str> using <ComparisonType>' -ForEach @(
        @{
            In = 'foo.PS1'
            SubStr = '.ps1'
            ComparisonType = 'CurrentCulture'
            Expect = $false
        }
        @{
            In = 'foo.PS1'
            SubStr = '.ps1'
            ComparisonType = 'CurrentCultureIgnoreCase'
            Expect = $true
        }
        # todo: parameterset needs tweaking to work when no ComparisonType is aet
        @{
            In = 'foo.PS1'
            SubStr = '.ps1'
            UsingCaseSensitive = $false
            Expect = $true
        }
        @{
            In = 'foo.PS1'
            SubStr = '.ps1'
            UsingCaseSensitive = $true
            Expect = $false
        }
        # Picky.String.EndsWith -InputText 'foo.ps1' -SubString '.ps1' -ComparisonType CurrentCulture
    ) {
        Picky.String.EndsWith -in $In -SubString $SubStr -ComparisonType $ComparisonType
            | Should -be $Expect
    }
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
