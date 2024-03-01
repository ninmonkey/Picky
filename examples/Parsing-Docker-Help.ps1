Import-Module Picky -PassThru -Force
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
function KeysOf {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )
    process {
        $InObj = $InputObject
        if( $InObj -is [IDictionary] ) {
            [IDictionary]$curDict = $InObj
            return $curDict.Keys #| Sort-Object
        }
        if( $InObj -is [IEnumerable] ) { # mainly for HashSet }
            return $InObj.GetEnumerator()  # Sort-Object1
        }
        return $InObj.PSObject.Properties.Name #| Sort-Object
    }
}
function New-ObjectFromMatch {
    <#
    .SYNOPSIS
        Converts text to a new PSCustomObject from a regex with named capture groups
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('Regex')]
        [string]$Pattern,

        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('String', 'Text', 'Content', 'InStr', 'InObj')]
        [string[]]$InputObject,

        [switch]$EscapePattern
    )
    begin {
        if($EscapePattern) { $Pattern = [Regex]::Escape($Pattern) }
    }
    process {
        foreach($Obj in $InputObject) {
            if($Obj -match $Pattern) {
                $matches.Remove(0)
                [pscustomobject]$Matches
            } else {
                Write-Verbose "New-ObjectFromMatch: Zero matches using the Regex: '$Pattern' and Input: '$Obj'"
            }
        }
    }
    end {}
}

$docs = [ordered]@{}
foreach($HeaderPattern in $command_headers) {
    $key = $HeaderPattern -replace '\s+Commands:', '' -replace ':$', ''
    $docs[$key] =
        $stdout
        | Pk.SkipBeforeMatch $headerPattern
        | Pk.SkipAfterMatch '^$' <# empty line #>
        | Pk.New-ObjectFromMatch $Regex.DocSubCommand
        # | %{
        #     if($_ -match $Regex.DocSubCommand) {
        #         $Matches.remove(0)
        #         [pscustomobject]$Matches
        #     }
        # }
}
$docs | KeysOf |  %{
   $docs[ $_ ] | Add-Member -NotePropertyName 'Group' -NotePropertyValue $_ -PassThru -Force -ea 'ignore'
}
$docs.values | Ft -AutoSize SubCommand, Description -GroupBy Group
# $docs | KeysOf |  %{
#    "`n## $_ ## "
#    $docs[ $_ ] | Ft SubCommand, Description -AutoSize
# }

# $Docs = [pscustomobject]$Docs
# $Docs
hr
return
docker --help
    | Pk.SkipBeforeMatch 'Common Commands:' -IncludeMatch -EscapePattern
    | Pk.FirstN 30

return
docker --help
    | Pk.SkipBeforeMatch 'Common Commands:' -IncludeMatch
    | Pk.SkipAfterMatch '^$' <# empty line #>
