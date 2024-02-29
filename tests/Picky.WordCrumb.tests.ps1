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
    # $PSStyle.OutputRendering = 'ansi'
}
AfterAll {
    # $PSStyle.OutputRendering = 'ansi'
    'ErrCountEnd: {0} [ +{1} ]' -f @(
        $Error.Count
        $Error.Count - $ErrCountStart
    )
        | write-host -back 'darkyellow'
}


Describe '[WordCrumb]' {
    it 'Simple StateUpdate Test' {
        InModuleScope Picky {
            $w1 = [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')
            $w1.CrumbCount | Should -be 9
            $w1.String = 'foo bar! cat'
            $w1.CrumbCount | Should -be 3
            $w1.String = 'foo bar'
            $w1.CrumbCount | Should -be 2
            $w1.SplitBy = 'oo'
            $w1.Crumbs | Should -BeExactly @('f', ' bar')
        }
    }
}
