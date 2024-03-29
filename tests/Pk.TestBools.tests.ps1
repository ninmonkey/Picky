﻿BeforeAll {
    $Config = @{
        SuperVerbose = $false
    }
    $PSStyle.OutputRendering = 'ansi'  # because extension turns it off
    Get-module picky -All| Remove-module
    $ModPath =
        Join-Path $PSScriptRoot '../Picky/Picky.psm1'
        # $PSCommandPath -replace '\.tests.ps1$', '.psm1'
    Import-Module -Force -PassThru $ModPath
       | Join-String -Prop { $_.Name, $_.Version -join ': ' } | write-host
    $ErrCountStart = $Error.Count
    if($Config.SuperVerbose) {
        $Error.Count
            | Join-String -f 'ErrCountStart: {0}'
            | write-host -bg 'darkyellow'
        $PSDefaultParameterValues['Pk.TestBools:Verbose'] = $True
    }
}
AfterAll {
    $PSDefaultParameterValues.Remove('Pk.TestBools:Verbose')
    $PSStyle.OutputRendering = 'ansi'  # because extension turns it off
    'ErrCountEnd: {0} [ +{1} ]' -f @(
        $Error.Count
        $Error.Count - $ErrCountStart
    )
        | write-host -back 'darkyellow'
}

# Describe 'Picky.TestBools : All Aliases are Implemented'  -Skip -tag 'waiting on implementation question' {
#     BeforeAll {
#         $All_Command_AliasNames = @(
#             Nin.Ast.FromGcm.GetCommandAliases -CommandName 'Picky.TestBools'
#         )
#         $All_AliasNames_AsCmdInfo =
#             ( Get-Command Picky.TestBools ).ScriptBlock.Attributes.Where({$_ -is [Alias]}).AliasNames.forEach({gcm $_})
#             # Nin.Ast.FromGcm.GetCommandAliases -CommandName Picky.TestBools -PassThru

#     }
#     Context -skip 'Mode: <ModeName>' -ForEach @(
#         @{ ModeName = 'AsPipeline' }
#         @{ ModeName = 'AsParameter' }
#     ) -Tag @('Alias.IsImplemented') {
#         it '<_> : <name> does not throw' -ForEach @(
#             @( $All_AliasNames_AsCmdInfo )
#         ) {
#             $whichAlias = $_
#             $data = $true, $false
#             switch( $ModeName ) {
#                 'AsParameter' {
#                     { & ($WhichAlias) -in $data } | Should -not -throw
#                 }
#                 'AsPipeline' {
#                     $data | Pk.AnyTrue | Should -be $Expected
#                 }
#                 default { throw "UnhandledMode: $WhichMode"}
#             }
#         }
#     }
# }
Describe 'Picky.TestBools Hardcoded Cases'  {
    BeforeAll {
        $Samples           = [ordered]@{}
        $Samples.Mixed     = @( $false, $true, $true, $null, '', ' ')

        $Samples.SomeTrue  = @( $false, $true, $true, $null, '', ' ')
        $Samples.OnlyTrue =  @( $true, $true )
        $Samples.NoneTrue =  @( $false, '', '  ' )

        $Samples.SomeFalse = @( $false, $true, $true, $null, '', ' ')
        $Samples.OnlyFalse =  @( $false, $false )
        $Samples.NoneFalse =  @( $true, ' ' )

        $Samples.SomeNull  = @( $false, $true, $true, $null, '', ' ')
        $Samples.OnlyNull  = @( $Null, $Null )
        $Samples.NoneNull  = @( 0, '', $false, ' ' )

        $Samples.SomeBlank = @( $false, $true, $true, $null, '', ' ')
        $Samples.OnlyBlank = @( ' ', '' )

        $Samples.EmptyList      = @()
        $Samples.ScalarNull     = $Null
        $Samples.ScalarTrue     = $True
        $Samples.ScalarFalse    = $false
        $Samples.ScalarBlank    = ''
        $Samples.ScalarEmptyStr = [string]::Empty
    }
        # or pester mode will throw 'UnhandledMode: System.Collections.Hashtable'
    Context 'AnyTrue: <Label> is <Expect>' -tag '🐒' -ForEach @(
        @{
            In = $Samples.SomeTrue
            Expect = $true
            Label = 0
        }
        @{
            In = $Samples.OnlyTrue
            Expect = $true
            Label = 1
        }
        @{
            In = $Samples.NoneTrue
            Expect = $false
            Label = 2
        }
        @{
            In = $Samples.EmptyList
            Expect = $false
            Label = 3
        }
    ) {
        it 'Mode: <_>' -ForEach @(
            'AsPipeline', 'AsParameter'
        ) {
            $whichMode = $_
            switch( $whichMode ) {
                'AsParameter' {
                    Picky.AnyTrue -in $In | SHould -be $Expect
                }
                'AsPipeline' {
                    $In | Picky.AnyTrue | SHould -be $Expect
                }
            }
        }
    }
}


    # Context 'HardCodedInvokes: <_>' -Tag 'StaticTest', 'HardCoded' -ForEach @(
    #     'AsPipeline', 'AsParameter'
    # ) {
    #     It 'Picky.AnyTrue <_>' {
    #         $whichMode = $_
    #         switch( $WhichMode ) {
    #             'AsParameter' {
    #                 Picky.AnyTrue -in $Samples.SomeTrue  | Should -be $true
    #                 Picky.AnyTrue -in $Samples.OnlyTrue  | Should -be $true
    #                 Picky.AnyTrue -in $Samples.NoneTrue  | Should -be $false
    #                 Picky.AnyTrue -in $Samples.EmptyList | Should -be $false
    #             }
    #             'AsPipeline' {
    #                 $Samples.SomeTrue  | Picky.AnyTrue | Should -be $true
    #                 $Samples.OnlyTrue  | Picky.AnyTrue | Should -be $true
    #                 $Samples.NoneTrue  | Picky.AnyTrue | Should -be $false
    #                 $Samples.EmptyList | Picky.AnyTrue | Should -be $false
    #             }
    #             default { throw "UnhandledMode: $WhichMode"}
    #         }
    #     }
    # }
