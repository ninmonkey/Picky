
$App = Get-Content (Join-Path $PSScriptRoot './app.json') | ConvertFrom-Json

$newestBuild =
    Get-ChildItem 'H:\data\2023\pwsh\PsModules\Picky\Picky\..\..\..\PsModules.Import\Picky' | Sort-Object LastWriteTime -Descending -Top 1

$newestBuild
    | Join-String -op 'newestBuild =: {0}' | Write-Host -back 'darkgreen'

# Publish-Module -Name "Picky" -NuGetApiKey $App.NugetApiKey -WhatIf
$publishPSResourceSplat = @{
    ApiKey          = $App.NuGetApiKey
    # WhatIf          = $true
    Repository      = 'PSGallery'
    Confirm         = $true
    Path            = $newestBuild
    DestinationPath = 'g:\temp\lastPwshNuget'
    Verbose = $true

}

Publish-PSResource @publishPSResourceSplat

Get-Item $publishPSResourceSplat.DestinationPath
    | Join-String -op 'Output Nuget: ' | Write-Host -back 'darkgreen'
