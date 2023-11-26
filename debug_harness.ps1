$HarnessConfig = @{
    Path = @{
        PSModulesRoot = 'C:/Users/cppmo_000/SkyDrive/Documents/PowerShell/Modules' # find: what's the standard path?
    }
}

Import-Module pansies -DisableNameChecking -PassThru
[ValidateSet('FromLocal', 'FromModuleBuilder', 'FromInstall', 'Implicit', 'Picky')]
$importMode =
    'FromLocal'
    # 'FromModuleBuilder'
    # 'FromInstall'




$newestModulePath = switch($ImportMode){
    { $_ -in @('Implicit', 'Picky' ) } { 'Picky' }
    'FromLocal' {
        (Join-Path $PSScriptRoot 'Picky.psm1')
        break }

    'FromModuleBuilder' {
            $newestBuild =
                $getChildItemSplat = @{
                    Recurse = $true
                    Path = 'H:\data\2023\pwsh\PsModules\Picky\Picky\..\..\..\PsModules.Import\Picky'
                    Filter = 'Picky.psm1'
                }

                Get-ChildItem @getChildItemSplat
                | Sort-Object LastWriteTime -Descending -Top 1

            $newestBuild
                | Join-String -op 'newestBuild =: ' | Write-Host -back 'darkgreen'

         break }
    'FromInstall' {
        gci $HarnessConfig.Path.PSModulesRoot Picky.psm1 -Depth 3
             Sort-Object LastWriteTime -Descending -Top 1
        break }
    default  { throw "ShouldNeverReach: Unhandled mode: $ImportMode" }
}

# $modPath = (Join-Path $PSScriptRoot 'Picky.psm1')
$hasDotils = gcm 'Render.ModuleName' -m 'Dotils' -ea 'ignore'

function RebuildModule.Picky {
    'building Picky ...' | write-host -back 'darkgreen'
    pushd 'H:\data\2023\pwsh\PsModules\Picky' -StackName 'builder'
    Build-Module
    popd -StackName 'builder'
}

rebuildModule.Picky

if($false) {
    Import-Module -Force -PassThru $newestModulePath -DisableNameChecking
} else {
    if($HasDotils) {
        Import-Module $newestModulePath -Force -Passthru -DisableNameChecking
            | Render.ModuleName
    } else {
        Import-Module $newestModulePath -Force -Passthru -DisableNameChecking
            | Join-String { $_.Name, $_.Version -join ' = ' }
            | write-host -back 'darkorange' -fg 'black'

    }

}


# Impo -pass -force -DisableName 'H:\data\2023\dotfiles.2023\pwsh\dots_psmodules\Dotils\Dotils.Fonts.psm1'
