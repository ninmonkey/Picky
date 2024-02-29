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


Describe 'Picky.Text.SkipBeforeMatch' {
    it 'Skip -IncludeMatch'  {
        'a'..'f'
            | Picky.Text.SkipBeforeMatch -BeforePattern 'd' -IncludeMatch
            | Should -BeExactly ('d'..'f')
    }
    it 'Skip'  {
        'a'..'f'
            | Picky.Text.SkipBeforeMatch -BeforePattern 'd'
            | Should -BeExactly ('e'..'f')
    }
}
Describe 'Picky.Object.FirstN' {
    it 'FirstN Underflow'  {
        0..100
            | Picky.Object.FirstN 4
            | Should -BeExactly (0..3)
    }
    it 'FirstN Overflow'  {
        0..5
            | Picky.Object.FirstN 30
            | Should -BeExactly (0..5)
    }
}
