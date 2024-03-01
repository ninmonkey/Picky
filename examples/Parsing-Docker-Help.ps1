Import-Module Picky -PassThru -Force
function H1 {
    # Sugar for console headers
    param( [string]$Text)
    $joinStringSplat = @{
        InputObject  = $Text
        FormatString = "`n## {0} ##`n"
        OutputSuffix = $PSStyle.Reset
        OutputPrefix = $PSStyle.Foreground.FromRgb('#ebcb8b')
    }
    Join-String @joinStringSplat
}
$stdout = docker --help
$command_headers = $stdout -match 'commands:'
$Regex = [ordered]@{}
$Regex.DocSubCommand = @'
(?x)
    # sample: https://regex101.com/r/A7tyKn/1
    # ex: " top         Display the running processes of a container"
    # ex: "  rename      Rename a container"
    ^
    \s+
    (?<SubCommand>.*?)
    \s+
    (?<Description>.*)
    $
'@

$docs = [ordered]@{}
foreach($HeaderPattern in $command_headers) {
    $key = $HeaderPattern -replace '\s+Commands:', '' -replace ':$', ''
    $docs[$key] =
        $stdout
        | Pk.SkipBeforeMatch $headerPattern
        | Pk.SkipAfterMatch '^$' <# empty line #>
        | Pk.New-ObjectFromMatch $Regex.DocSubCommand
}
$docs | Picky.KeysOf |  %{
   $docs[ $_ ] | Add-Member -NotePropertyName 'Group' -NotePropertyValue $_ -PassThru -Force -ea 'ignore'
}

h1 'Subcommand Groupings'
$docs.values | Ft -AutoSize SubCommand, Description -GroupBy Group

h1 'docs header'
docker --help
    | Pk.SkipAfterMatch 'Common Commands:'

h1 'docs tail'
docker --help
    | Pk.SkipBeforeMatch 'Global Options:' -IncludeMatch

# h1 'or final args, that don''t quite capture flag pairs with the same regex'
# docker --help
#     | Pk.SkipBeforeMatch 'Global Options:' -IncludeMatch
#     | Pk.SkipAfterMatch '^$' <# empty line #>
#     | Pk.New-ObjectFromMatch $Regex.DocSubCommand
