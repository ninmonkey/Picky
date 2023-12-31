using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$env:BuildModuleName = 'Picky'
# created: 2023-12-17
$App = Get-Content (Join-Path $PSScriptRoot './env.json' | gi -ea 'stop' ) | ConvertFrom-Json

class BuildItCommandNameCompleter : IArgumentCompleter {
    # auto complete functions in this file
    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [Language.CommandAst] $CommandAst,
        [System.Collections.IDictionary] $FakeBoundParameters
    ) {

        $doc = Dotils.AstFromFile -FileName $PSCommandPath
        $topLevelCommands = $doc.Ast.FindAll(
            {
                param( [Ast]$Ast )
                end {
                        $t = $Ast -is [FunctionDefinitionAst]
                        return $t
                }
            }, $false) | % Name | Sort-Object -Unique

        [List[CompletionResult]]$CompletionResults = @(
            $TopLevelCommands
                | ?{
                    $_ -match [regex]::Escape( $WordToComplete )
                }
                |  %{

                [CompletionResult]::new(
                    $_,
                    $_,
                    [CompletionResultType]::ParameterValue,
                    $_
                )
            }
        )
        return $CompletionResults
    }
}

function BuildItCmd {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter( [BuildItCommandNameCompleter] )]
        [string]$BuildCommandName
    )
    'invoke BuildIt-{0}' -f @($BuildCommand )| write-host -bg 'darkgreen'
}
function BuiltIt-TryImportInstalled {
    param(
        [Alias('Path')]
        [object]$NewestInstalledModule
    )
    Import-Module $NewestInstalledModule -force -PassThru -ea 'stop'
        | Join-string -op 'InstallModule: Import should not throw: '
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
function BuildIt-ModuleBuild {
    build-module
}

function BuildIt-TryModuleBuild {
    [CmdletBinding()]
    param(
        [string]$ModuleName
    )
    $ModuleName ??= $env:BuildModuleName


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

    $newestBuildRoot
        | Join-String -op 'newestBuildRoot =: ' | Write-Host -back 'darkgreen'

    $NewestBuildModule
        | Join-String -op 'newestBuildRoot =: ' | Write-Host -back 'darkgreen'
}
function BuildIt-TryImportModuleBuilder {
    [CmdletBinding()]
    param(
        [string]$ModuleName
    )
    $ModuleName ??= $env:BuildModuleName

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
function BuildIt-TryPublish {
    [CmdletBinding()]
    param( [string]$ModuleName )
    $ModuleName ??= $env:BuildModuleName

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

function BuildIt-TryInstallPublished {
    [CmdletBinding()]
    param(
        [string]$ModuleName
    )
    $ModuleName ??= $env:BuildModuleName

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

    BuildIt-TryImportInstalled -Path $NewestInstalledModule
    # [4]

}
