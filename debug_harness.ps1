$modPath = (Join-Path $PSScriptRoot 'Picky.psm1')
$hasDotils = gcm 'Render.ModuleName' -m 'Dotils' -ea 'ignore'

function RebuildModule.Picky {
    pushd 'H:\data\2023\pwsh\PsModules\Picky' -StackName 'builder'
    Build-Module
    popd -StackName 'builder'
}

rebuildModule.Picky

if($false) {
    Import-Module -Force -PassThru $ModPath -DisableNameChecking
} else {
    if($HasDotils) {
        Import-Module 'Picky' -Force -Passthru -DisableNameChecking
            | Render.ModuleName
    } else {
        Import-Module 'Picky' -Force -Passthru -DisableNameChecking
            | Join-String { $_.Name, $_.Version -join ' = ' }
            | write-host -back 'darkorange' -fg 'black'

    }

}


# Impo -pass -force -DisableName 'H:\data\2023\dotfiles.2023\pwsh\dots_psmodules\Dotils\Dotils.Fonts.psm1'
