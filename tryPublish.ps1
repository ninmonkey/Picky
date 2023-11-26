
$App = gc (Join-Path $PSScriptRoot './app.json') | ConvertFrom-Json

$newestBuild =
    gci 'H:\data\2023\pwsh\PsModules\Picky\Picky\..\..\..\PsModules.Import\Picky' | sort LastWriteTime -Descending -Top 1

$newestBuild

# Publish-Module -Name "Picky" -NuGetApiKey $App.NugetApiKey -WhatIf
$publishPSResourceSplat = @{
    ApiKey = $App.NuGetApiKey
    WhatIf = $true
    Repository = 'PSGallery'
    Confirm = $true
    Path = $newestBuild

}

Publish-PSResource @publishPSResourceSplat
