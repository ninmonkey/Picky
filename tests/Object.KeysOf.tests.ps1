BeforeAll {
    Get-module picky -All| CountOf | Remove-module
    $ModPath =
        Join-Path $PSScriptRoot '../Picky/Picky.psm1'
        # $PSCommandPath -replace '\.tests.ps1$', '.psm1'
    Import-Module -Force -PassThru $ModPath
       | Join-String -Prop { $_.Name, $_.Version -join ': ' } | out-host
    $ErrCountStart = $Error.Count
    $Error.Count
        | Join-String -f 'ErrCountStart: {0}'
        | write-host -back 'darkyellow'
}
AfterAll {
    'ErrCountEnd: {0} [ +{1} ]' -f @(
        $Error.Count
        $Error.Count - $ErrCountStart
    )
        | write-host -back 'darkyellow'
}

Describe 'Picky.Object.Keys' {
    it 'Type: <Label> has <Expect>' -foreach @(
        @{
            Label = 'Dict'
            InObj = @{ A = '10' ; B = 4 }
            # todo: future: verb that's like ExactlyExpect
            # except the order doesn't matter, as long as it contains all, and exactly all the same
            # keys
            ExpectExact = @('A', 'B') | Sort-Object
        }
        @{
            Label = 'PSObject'
            InObj = [pscustomobject]@{ A = '10' ; B = 4 }
            # todo: future: verb that's like ExactlyExpect
            # except the order doesn't matter, as long as it contains all, and exactly all the same
            # keys
            ExpectExact = @('A', 'B') | Sort-Object
        }
    ) {
        $InObj
            | Picky.Object.KeysOf
            | Sort-Object
            | Should -BeExactly $ExpectExact

    }
}
