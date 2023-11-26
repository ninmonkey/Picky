$HarnessConfig = @{
    Path = @{
        PSModulesRoot = 'C:/Users/cppmo_000/SkyDrive/Documents/PowerShell/Modules' # find: what's the standard path?
    }
}

Import-Module pansies -DisableNameChecking -PassThru
[ValidateSet('FromLocal', 'FromModuleBuilder', 'FromInstall', 'Implicit', 'Picky')]
$importMode =
    #                       # I am: H:\data\2023\pwsh\PsModules\Picky\debug_harness.ps1
    'FromLocal'             # was H:\data\2023\pwsh\PsModules\Picky\Picky\Picky.psm1
    # 'Implicit'              # was H:\data\2023\pwsh\PsModules\Picky\Picky\Picky.psm1
    # 'FromModuleBuilder'       # was H:\data\2023\pwsh\PsModules.Import\Picky\0.0.6\Picky.psm1
    # 'FromInstall'           # was C:\Users\cppmo_000\SkyDrive\Documents\PowerShell\Modules\Picky\0.0.5\Picky.psm1

Join-String -in $ImportMode -op 'ImportMode: ' | New-Text -bg 'darkblue' -fg 'white' | write-verbose -verbose

$newestModulePath = switch($ImportMode){
    { $_ -in @('Implicit', 'Picky' ) } { 'Picky' }
    'FromLocal' {
        # some reason FromLocal shows version number == 0.0, is there a modulebuilder config missing?
        # (Join-Path $PSScriptRoot 'Picky.psm1')
        gci $PSScriptRoot 'Picky.psm1' -Depth 3
            | Sort-Object LastWriteTime -Descending -Top 1
        break }

    'FromModuleBuilder' {

            $getChildItemSplat = @{
                Recurse = $true
                Path = 'H:\data\2023\pwsh\PsModules\Picky\Picky\..\..\..\PsModules.Import\Picky'
                Filter = 'Picky.psm1'
            }

            $newestBuild =
                Get-ChildItem @getChildItemSplat
                | Sort-Object LastWriteTime -Descending -Top 1

            $newestBuild
                | Join-String -op 'newestBuild =: ' | Write-Host -back 'darkgreen'
            $newestBuild

         break }
    'FromInstall' {
        gci $HarnessConfig.Path.PSModulesRoot Picky.psm1 -Depth 3
             Sort-Object LastWriteTime -Descending -Top 1
        break }
    default  { throw "ShouldNeverReach: Unhandled mode: $ImportMode" }
}
if( -not (test-path $newestModulePath)) {
    throw "ModulePath was null"
}
# $modPath = (Join-Path $PSScriptRoot 'Picky.psm1')
$hasDotils = gcm 'Render.ModuleName' -m 'Dotils' -ea 'ignore'

function RebuildModule.Picky {
    'building Picky ...' | write-host -back 'darkgreen'
    pushd 'H:\data\2023\pwsh\PsModules\Picky' -StackName 'builder'
    Build-Module
    popd -StackName 'builder'
}

switch($ImportMode){
    'FromLocal' {
        # 'pass'
    }
    default {
        rebuildModule.Picky && ('BuildWorked' | write-host -back 'darkblue')
    }
}

# if($false) {
#     # Import-Module -Force -PassThru $newestModulePath -DisableNameChecking
# } else {
if($HasDotils) {
    Import-Module $newestModulePath -Force -Passthru -DisableNameChecking
        | Render.ModuleName
} else {
    Import-Module $newestModulePath -Force -Passthru -DisableNameChecking
        | Join-String { $_.Name, $_.Version -join ' = ' }
        | write-host -back 'darkorange' -fg 'black'
}

# }


# Impo -pass -force -DisableName 'H:\data\2023\dotfiles.2023\pwsh\dots_psmodules\Dotils\Dotils.Fonts.psm1'
