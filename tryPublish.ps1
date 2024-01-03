using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
err -Clear
$env:BuildModuleName = 'Picky'
# created: 2023-12-17
$App = Get-Content (Join-Path $PSScriptRoot './app.json' | gi -ea 'stop' ) | ConvertFrom-Json

$PSDefaultParameterValues['BuildIt-*:verbose'] = $true

write-warning 'left off: __Render.ParamAstNames $curCmd.Body.ParamBlock.Parameters completer for builditcmd'
function __Render.ParamAstNames {
    param(
        [ParameterAst[]]$ParameterAst,
        [ArgumentCompletions('"`n"', ', ')]
        [string]$Separator = "`n"
    )

    $joinStringSplat = @{
        Separator = $Separator
        Property = {@(
            $_.StaticType | Fmt.ShortType
            ': '
            $_.Name
        ) -join ''}
    }
    $ParameterAst | Join-String @joinStringSplat
}


class BuildItCommandNameCompleter : IArgumentCompleter {
    # rename, it's more of a [FunctionDefinitionAst].Name Completer
        # auto complete functions in this file
    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [Language.CommandAst] $CommandAst,
        [System.Collections.IDictionary] $FakeBoundParameters
    ) {
        $doc = Dotils.AstFromFile -FileName $PSCommandPath
        [List[FunctionDefinitionAst]]$topLevelCommands = @( $doc.Ast.FindAll({
                param( [Ast]$Ast )
                end {  $Ast -is [FunctionDefinitionAst] }
            }, $false)
        )

        [List[CompletionResult]]$CompletionResults = @(
            $TopLevelCommands
                | Sort-Object Name -Unique
                | ?{
                    $_.Name -match [regex]::Escape( $WordToComplete )
                } | %{
                    [FunctionDefinitionAst]$curCmd = $_
                    [string]$Tooltip = ''

                    # if($this.UseBatSyntaxHighlighting) {
                    #     # not worth it unless it's cached
                    #     # $PSStyle.OutputRendering = 'ansi'
                    #     $Tooltip =
                    #         ($tooltip -join "`n")| bat --color always --paging never -l ps1
                    #         | Join-String -sep "`n"
                    #         # $tooltip | Bat -f -l cs
                    # }
                    $c = @{
                        Fg     = $PSStyle.Foreground.FromRgb('#b7dca8')
                        Header = $PSStyle.Foreground.FromRgb('#57785f')
                        Var    = $PSStyle.Foreground.FromRgb('#a0dcff')
                    }
                    $Str = @{
                        Pad = "`n"
                    }

                    [string]$tooltip = ''
                    $tooltip += @(
                        $Str.Pad
                        'Synopsis: '
                            | Join-String -op $c.Header

                        $curCmd.GetHelpContent().Synopsis ?? "`u{2400}"
                            | Join-String -op  $c.Fg
                        "`n"
                        'Params: '
                            | Join-String -op $c.Header
                            | Join-String -os $Str.Pad
                        $Str.Pad
                        [string]$renderParams = (__Render.ParamAstNames $curCmd.Body.ParamBlock.Parameters) ?? "`u{2400}"
                            | Join-String -op  $c.Fg
                            | Join-String -os $Str.Pad
                        $renderParams

                        $Str.Pad
                        'Notes: '
                            | Join-String -op $c.Header

                        $curCmd.GetHelpContent().Notes ?? "`u{2400}"
                            | Join-String -op  $c.Fg

                        $Str.Pad
                        'Description: '
                            | Join-String -op $c.Header

                        $curCmd.GetHelpContent().Description ?? "`u{2400}"
                            | Join-String -op  $c.Fg
                    ) | Join-String -sep ''


                    if( [string]::IsNullOrWhiteSpace( $Tooltip )) {
                        $Tooltip = "`u{2400}"
                    }

                   return  [CompletionResult]::new(
                        <# completionText#>       $curCmd.Name,
                        <# listItemText #>        $curCmd.Name,
                        [CompletionResultType]::ParameterValue,
                        <# tooltip #>                  $Tooltip
                    )
                }

        )
        return $CompletionResults
    }
}

function BuildItCmd {
    <#
    .SYNOPSIS
    base command that invokes completions for invoking the rest
    #>
    [CmdletBinding(DefaultParameterSetName='InvokeCommand')]
    param(
        [Parameter(ParameterSetName = 'ListOnly', Mandatory)]
        [switch]$ListCommands,

        [Parameter(Mandatory, ParameterSetName='InvokeCommand', Position=0)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter( [BuildItCommandNameCompleter] )]
        [string]$BuildCommandName,

        [Alias('Args', 'ArgList', 'InputObject',  'InObj')]
        [object[]]$Params
    )
    if($ListCommands) {
        'command listing....nyi'
        return
    }

    'invoke BuildIt-{0}' -f @($BuildCommand )| write-host -bg 'darkgreen'
    $VerbosePreference = 'Continue'
    & $buildCommandName $params
    $VerbosePreference = 'SilentlyContinue'
}


@'

### Summary

[1] build-module, and the path
[2] test importing the version from build-module, not local
[3] Publish-PSResource
[4] Install-Module and test importing the installed instance

todo:
    clean up the modulebuilder folder
'@

# [1]
function BuildIt-ModuleBuildOnly {
    <#
    .SYNOPSIS
        simple invoke, build-Module and nothing else
    #>
    [CmdletBinding()]
    param()
    build-module -Verbose
}

function CleanUp-ModuleBuilder {
     <#
    .SYNOPSIS
        Cleanup all folders created by 'BuildModule'
    #>
    [CmdletBinding()]
    param(
        # Module name, else falls back to:  Env:BuildModuleName
        [string]$ModuleName,
        [switch]$NoConfirm
    )
    if( -not $PSBoundParameters.ContainsKey('ModuleName') ) { $ModuleName = $Env:BuildModuleName }
    'ModuleName: {0}' -f $ModuleName | Write-verbose

    $newestPathTemplate =
        'H:\data\2023\pwsh\PsModules.Import\{0}' -f $ModuleName

    'to remove: module-builder''s root: {0}' -f $NewestPathTemplate | write-verbose -verbose
    if(-not (test-path $NewestPathTemplate)) {
        'already empty or deleted' | write-verbose
        return
    }
    remove-item -LiteralPath $newestPathTemplate -Recurse -Confirm
}
function CleanUp-InstallModule {
     <#
    .SYNOPSIS
        Cleanup all folders created by 'BuildModule'
    #>
    [CmdletBinding()]
    param(
        # Module name, else falls back to:  Env:BuildModuleName
        [string]$ModuleName
    )
    throw 'NYI'
    if( -not $PSBoundParameters.ContainsKey('ModuleName') ) { $ModuleName = $Env:BuildModuleName }
    'ModuleName: {0}' -f $ModuleName | Write-verbose
}
function BuildIt-ModuleBuilder {
    <#
    .SYNOPSIS
        build-Module and and calculate paths
    #>
    [CmdletBinding()]
    param(
        # Module name, else falls back to:  Env:BuildModuleName
        [string]$ModuleName
    )
    if( -not $PSBoundParameters.ContainsKey('ModuleName') ) { $ModuleName = $Env:BuildModuleName }
    'ModuleName: {0}' -f $ModuleName | Write-verbose

    $pathTemplate =
        'H:\data\2023\pwsh\PsModules\{0}\{0}\..\..\..\PsModules.import\{0}' -f @( $ModuleName )

    $PathTemplate | Join-String -op 'pathTemplate: ' | write-verbose
    # sample value: 'H:\data\2023\pwsh\PsModules\CacheMeIfYouCan\CacheMeIfYouCan\..\..\..\PsModules.import\CacheMeIfYouCan'
    $newestBuildRoot =
        gci $PathTemplate
            | Sort-Object LastWriteTime -Descending -Top 1

    $newestPathTemplate =
        'H:\data\2023\pwsh\PsModules.Import\{0}' -f $ModuleName

    $NewestBuildModule =
        gci $newestPathTemplate "${ModuleName}.psm1" -Recurse
        | Sort-Object LastWriteTime -Descending

    if( -not $NewestBuildRoot ) { throw "Missing NewestBuildRoot!"}
    if( -not $NewestBuildModule ) { throw "Missing NewestBuildModule!"}

    $newestBuildRoot
        | Join-String -op 'newestBuildRoot =: ' | Write-Host -back 'darkgreen'

    $NewestBuildModule
        | Join-String -op 'newestBuildRoot =: ' | Write-Host -back 'darkgreen'
}

function BuildIt-Publish {
    <#
    .SYNOPSIS
        Try invoking Publish-PSResource with confirmation
    #>
    [CmdletBinding()]
    param(
        # Module name, else falls back to:  Env:BuildModuleName
        [string]$ModuleName
    )
    if( -not $PSBoundParameters.ContainsKey('ModuleName') ) { $ModuleName = $Env:BuildModuleName }
    'ModuleName: {0}' -f $ModuleName | Write-verbose

    # remove old nugets
    gci "g:\temp\lastPwshNuget-${ModuleName}" "${ModuleName}.*.nupkg"| Remove-Item

    # Publish-Module -Name "Picky" -NuGetApiKey $App.NugetApiKey -WhatIf
    $publishPSResourceSplat = @{
        ApiKey          = $App.NuGetApiKey
        Confirm         = $true
        DestinationPath = "g:\temp\lastPwshNuget-${ModuleName}"
        Path            = $newestBuildRoot
        Repository      = 'PSGallery'
        Verbose         = $true
        # WhatIf          = $true

    }

    # [3]
    Publish-PSResource @publishPSResourceSplat

    Get-Item $publishPSResourceSplat.DestinationPath
        | Join-String -op 'Output Nuget: ' | Write-Host -back 'darkgreen'
}

function ImportFrom-ModuleBuilder {
    <#
    .SYNOPSIS
        Import-Module from the build-dist folder, rather than here
    #>
    [CmdletBinding()]
    param(
        # Module name, else falls back to:  Env:BuildModuleName
        [string]$ModuleName
    )
    if( -not $PSBoundParameters.ContainsKey('ModuleName') ) { $ModuleName = $Env:BuildModuleName }
    'ModuleName: {0}' -f $ModuleName | Write-verbose

    $pathTemplate =
        'H:\data\2023\pwsh\PsModules\{0}\{0}\..\..\..\PsModules.import\{0}' -f $ModuleName

    $PathTemplate | Join-String -op 'pathTemplate: ' | write-verbose
    # sample value: 'H:\data\2023\pwsh\PsModules\CacheMeIfYouCan\CacheMeIfYouCan\..\..\..\PsModules.import\CacheMeIfYouCan'
    $newestBuildRoot =
        gci $PathTemplate
            | Sort-Object LastWriteTime -Descending -Top 1

    $newestPathTemplate =
        'H:\data\2023\pwsh\PsModules.Import\{0}' -f $ModuleName

    $NewestBuildModule =
        gci $newestPathTemplate "${ModuleName}.psm1" -Recurse
        | Sort-Object LastWriteTime -Descending

    if( -not $NewestBuildRoot ) { throw "Missing NewestBuildRoot!"}
    if( -not $NewestBuildModule ) { throw "Missing NewestBuildModule!"}

    # [2]
    Remove-Module "${ModuleName}*"
    $newestBuildModule = gci $newestPathTemplate "${ModuleName}.psm1" -Recurse
        | Sort-Object LastWriteTime -Descending

    Import-Module $NewestBuildModule -force -PassThru -ea 'stop'
        | Join-string -op 'BuiltModule: Import should not throw: '
}
function ImportFrom-InstallModule {
    <#
    .SYNOPSIS
        Import-Module from the 'Install-MOdule's version of this module
    #>
    [CmdletBinding()]
    param(
        # Module name, else falls back to:  Env:BuildModuleName
        [string]$ModuleName
    )
    if( -not $PSBoundParameters.ContainsKey('ModuleName') ) { $ModuleName = $Env:BuildModuleName }
    'ModuleName: {0}' -f $ModuleName | Write-verbose

    Remove-Module "${ModuleName}*"
    Uninstall-module $ModuleName -ea 'continue'
    Install-Module -Confirm $ModuleName -Verbose -ea 'stop'

    $NewestInstalledModule =
        gci (Join-Path (Join-Path $env:USERPROFILE "SkyDrive\Documents\PowerShell\Modules") $ModuleName) "${ModuleName}.psm1" -Recurse
            | Sort-Object LastWriteTime -Descending -top 1

    $NewestInstalledModule
            | Join-String -op 'newestInstalledModule =: '
            | Write-Host -back 'darkgreen'

    if( -not $NewestInstalledModule ) { throw "missing NewestINstalledModule!"}

    # [4]
    $importModuleSplat = @{
        DisableNameChecking = $true
        ErrorAction         = 'stop'
        Force               = $true
        Name                = $NewestInstalledModule
        PassThru            = $true
        Verbose             = $true
    }

    Import-Module @importModuleSplat
        | Join-string -op 'InstallModule: Import should not throw: '

}
