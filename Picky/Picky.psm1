using namespace System.Collections.Generic
using namespace System.Collections
using namespace System.Management.Automation.Language
using namespace System.Management.Automation
using namespace System.Management

$script:ModuleConfig = @{
    # ExportAggressiveNames = $false
    Verbose = @{
        # OnEventA = $true
    }
    TemplateFromCacheMe = $false
    ExportPrefix = @{
        Picky  = $True
        Pick   = $True
        Pk     = $true
        String = $True
        Function = $true
        ScriptBlock = $True
    }

}
[hashtable]$script:Cache = @{}
# if($Script:ModuleConfig.VerboseJson_ArgCompletions) {
#     (Join-Path (gi 'temp:\') 'CacheMeIfYouCan.ArgCompletions.log')
#     | Join-String -op 'CacheMeIfYouCan: VerboseLogging for ArgCompletions is enabled at: '
#     | write-warning
# }
$script:Color = @{
    MedBlue   = '#a4dcff'
    DimBlue   = '#7aa1b9'
    DimFg     = '#cbc199'
    DarkFg    = '#555759'
    DimGreen  = '#95d1b0'
    DimOrange = '#ce8d70'
    DimPurple = '#c586c0'
    Dim2Purple = '#c1a6c1'
    DimYellow = '#dcdcaa'
    MedGreen  = '#4cd189'
}
if($ModuleConfig.TemplateFromCacheMe) {
    function WriteFg {
        # Internal Ansi color wrapper
        param( [object]$Color )
        if( [string]::IsNullOrEmpty( $Color ) ) { return }
        $PSStyle.Foreground.FromRgb( $Color )
    }
    function WriteBg {
        # Internal Ansi color wrapper
        param( [object]$Color )
        if( [string]::IsNullOrEmpty( $Color ) ) { return }
        $PSStyle.Background.FromRgb( $Color )
    }
    function WriteColor {
        # Internal Ansi color wrapper
        param(
            [object]$ColorFg,
            [object]$ColorBg
        )
        if( [string]::IsNullOrEmpty( $ColorFg ) -and [string]::IsNullOrEmpty( $ColorBg ) ) { return }
        @(  WriteFg $ColorFg
            WriteBg $ColorBg ) -join ''
    }
}
function ScriptBlock.GetInfo {
    <#
    .SYNOPSIS
        Quickly and easily grab properties and metadata for [ScriptBlock] types
    .EXAMPLE
        # use auto completion
        Pwsh> gcm 'DoWork'
            | Function.GetInfo ScriptBlock
            | ScriptBlock.GetInfo File
    .LINK
        Picky\Function.GetInfo
    .LINK
        Picky\ScriptBlock.GetInfo
    .notes
        future info
        - [ ] other scriptblock/function types

        - [ ] DefaultParameterSet
        - [ ] (Jsonify) => Id, Ast, Module, Etc...
    #>
    [OutputType(
        'PSModuleInfo'

    )]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [Alias('Name', 'Func', 'Fn', 'Command', 'InObj', 'Obj', 'ScriptBlock', 'SB', 'E', 'Expression')]
        [object]$InputObject,

        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [Parameter(Mandatory)]
        [ValidateSet(
            'Attributes',
            'File',
            'Module',
            'StartPosition',
            'Id',
            'Ast'
        )]
        [string]$OutputKind
    )
    # future: assert properties exist
    process {
        if( $InputObject -isnot [ScriptBlock] ) {
            'Expected A <ScriptBlock | ... >. Actual: {0}' -f @(
                $InputObject.GetType().Name
            )
            | Dotils.Write-DimText | Infa
                # | write-warning
        }
        'InputType: {0}, Expected <ScriptBlock>' -f @(
            $InputObject.GetType().Name
        ) | write-verbose

        # if( -not $InputObject -isnot 'F')
        if($Null -eq $InputObject) { return }
        switch( $OutputKind ) {
            'Attributes' {
                # -is [List[Attribute]]
                $result  = $Input.Attributes
                break
            }
            'File' {
                # -is [string]
                $result  = $Input.File
                break
            }
            'Module' {
                # is [PSModuleInfo]
                $result  = $input.Module
                break
            }
            'StartPosition' {
                # -is [PSToken]
                $result  = $InputObject.StartPosition
                break
            }
            'Id' {
                # -is [Guid]
                $result  = $InputObject.Id
                break
            }
            'Ast' {
                # -is [Ast>]
                $result  = $InputObject.Ast
                break
            }
            default { throw "Unhandled OutputKind: $OutputKind" }
        }


        $isBlank = [string]::IsNullOrWhiteSpace( $result )
        if($isBlank -and $InputObject) {
            'Object exists but the attribute is blank'
                | Dotils.Write-DimText | Infa
        }
        return $result

    }
}
function Function.GetInfo {
    <#
    .SYNOPSIS
        Quickly and easily grab properties and metadata for [CommandInfo], [FunctionInfo] etc
    .EXAMPLE
        # use auto completion
        Pwsh> gcm 'DoWork' | Function.GetInfo Parameters
    .LINK
        Picky\Function.GetInfo
    .LINK
        Picky\ScriptBlock.GetInfo
    .notes
        future info
        - [ ] ParameterMetadata ResolveParameter(string name);
        - [ ] DefaultParameterSet
        - [ ] ScriptBlock
        - [ ] CommandType

        - [ ] (Jsonify) => Options, Description, Noun, Verb, Name, ModuleName, Source, Version
    #>
    [OutputType(
        'ScriptBlock',
        'PSModuleInfo',
        '[IDictionary[string, [Management.Automation.ParameterMetadata]]]',
        '[Collections.ObjectModel.ReadOnlyCollection[Management.Automation.CommandParameterSetInfo]]',
        'Management.Automation.ParameterMetadata'
    )]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [Alias('Name', 'Func', 'Fn', 'Command', 'InObj', 'Obj', 'ScriptBlock', 'SB')]
        [object]$InputObject,

        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [Parameter(Mandatory)]
        [ValidateSet(
            'Attributes',
            'ScriptBlock',
            'Module',
            'Parameters',
            'ResolveParameter',
            'ParameterSets'
        )]
        [string]$OutputKind,

        [Parameter()]
        [String]$ResolveParameter
    )
    process {
        if($PSBoundParameters.ContainsKey('ResolveParameter')) {
            if($OutputKind -ne 'ResolveParameter') { throw "Invalid OutputKind, must be ResolveParameter using ResolveParameter"}
        }

        # future: assert properties exist
        if( $InputObject -isnot [CommandInfo] -and $InputObject -isnot [FunctionInfo]) {
            'Expected A <CommandInfo | FunctionInfo>. Actual: {0}' -f @(
                $InputObject.GetType().Name
            )
            | Dotils.Write-DimText | Infa
                # | write-warning
        }
        'InputType: {0}, Expected <CommandInfo|FunctionInfo>' -f @(
            $InputObject.GetType().Name
        ) | write-verbose

        # if( -not $InputObject -isnot 'F')
        if($Null -eq $InputObject) { return }
        switch( $OutputKind ) {

            'Attributes' {
                $result  = $Input.ScriptBlock.Attributes
                break
            }
            'ScriptBlock' {
                # -is [ScriptBlock]
                $result  = $Input.ScriptBlock
                break
            }
            'Module' {
                # is [PSModuleInfo]
                $result  = $input.Module
                break
            }
            'Parameters' {
                # -is [Dictionary<string, ParameterMetadata>]]
                $result  = $InputObject.Parameters
                break
            }
            'ParameterSets' {
                # -is [ReadOnlyCollection<CommandParameterSetInfo>]
                $result  = $InputObject.ParameterSets
                break
            }
            'ResolveParameter' {
                # -is [ParameterMetadata]
                $result  = $InputObject.ResolveParameter( $ResolveParameter )
                break
            }
            default { throw "Unhandled OutputKind: $OutputKind" }
        }


        $isBlank = [string]::IsNullOrWhiteSpace( $result )
        if($isBlank -and $InputObject) {
            'Object exists but the attribute is blank'
                | Dotils.Write-DimText | Infa
        }
        return $result

    }
}
function String.GetCrumbs {
    <#
    .SYNOPSIS
        Split a string into chunks.'
    .EXAMPLE
        GetStringCrumbs -InputText 'bat man 3.14 cat, n!-choose-r' -SplitBy '[ ]'
    .EXAMPLE
        [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog', '\W+' )
    .EXAMPLE
        $w1 = [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')
        $w1.CrumbCount | Should -be 9
        $w1.String = 'foo bar! cat'
        $w1.CrumbCount | Should -be 3
        $w1.String = 'foo bar'
        $w1.CrumbCount | Should -be 2
    #>
    [Alias(
        # 'String.GetCrumbs',
        'Pk.StrCrumbs',
        'Pick-WordCrumbs'
        # 'GetStringCrumbs'
    )]
    param(
        [string]$InputText,

        [ArgumentCompletions(
            '\W+',
            '\b',
            '\s+',
            '\s',
            "'[ ]'",
            "'[ ]+'"

        )]
        [string]$SplitBy
    )
    [WordCrumb]::new( $InputText, $SplitBy )
}
class WordCrumb {
    <#
    .DESCRIPTION
        Example of a pwsh class with getters/setters that mutate the state
        modify properties 'c.String' or 'c.SplitBy'
    #>
    [string[]]
    $Crumbs = @()

    [int]
    $CrumbCount = 0

    hidden [string]
    $RawString

    [string]
    $_SplitBy = '\W+'

    WordCrumb ( [string]$Text ) {
        $This.RawString  = $Text
        $This.Crumbs     = $Text -split $this._SplitBy
        $this.CrumbCount = $This.Crumbs.Count
    }
    WordCrumb ( [string]$Text, [string]$SplitBy ) {
        $This.RawString  = $Text
        $this.Crumbs     = $Text -split $SplitBy
        $this._SplitBy    = $SplitBy
        $this.CrumbCount = $This.Crumbs.Count
    }
    # rebuild
    [void] Update () { # aka Recalculate()
        # $this = [WordCrumb]::Parse( $This.RawString, $this._SplitBy )

        $new = [WordCrumb]::Parse( $This.RawString, $this._SplitBy )
        $this.Crumbs     = $New.Crumbs
        $this.CrumbCount = $new.CrumbCount
        $this.RawString  = $new.RawString
        $this._SplitBy   = $new.SplitBy
    }
    static [WordCrumb] Parse( [string]$Text, [string]$SplitBy ) {
        return [WordCrumb]::New( $Text, $SplitBy )
    }
}
$get_RawString = {
    return $this.RawString
}
$set_RawString = {
    param( [string]$NewText )
    $this.RawString = $NewText
    $this.Update()
}

$get_SplitBy = {
    return $this._SplitBy
}
$set_SplitBy = {
    param( [string]$SplitBy )
    $this._SplitBy = $SplitBy
    $this.Update()
}

$add_ScriptProperty = @{
      MemberType    = 'ScriptProperty'
      Force         = $true
      TypeName      = 'WordCrumb'
    # TypeConverter = '.'
    # TypeAdapter   = '.'
    # TypeData      = ''
}

$updateTypeDataSplat = @{
    MemberName  = 'String'
    Value       = $get_RawString
    SecondValue = $set_RawString
}
Update-TypeData @updateTypeDataSplat @add_ScriptProperty

$updateTypeDataSplat = @{
    MemberName  = 'SplitBy'
    Value       = $get_SplitBy
    SecondValue = $set_SplitBy
}
Update-TypeData @updateTypeDataSplat @add_ScriptProperty

<#
[WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog', '\W+' )
[WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')

$w1 = [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')
$w1.CrumbCount | Should -be 9
$w1.String = 'foo bar! cat'
$w1.CrumbCount | Should -be 3
$w1.String = 'foo bar'
$w1.CrumbCount | Should -be 2

$w1.SplitBy = 'oo'
$w1.Crumbs | Should -BeExactly @('f', ' bar')

#>

[List[object]]$ExportMemberPatterns = @(
    if( $ModuleConfig.ExportPrefix.String ) {
        'String.*'
        '*-String*'
        'Str.*'
        '*-Str*'
    }
    if( $ModuleConfig.ExportPrefix.Picky ) {
        'Picky.*'
        '*-Picky*'
    }
    if( $ModuleConfig.ExportPrefix.Function ) {
        'Function.*'
        '*-Function*'
    }
    if( $ModuleConfig.ExportPrefix.ScriptBlock ) {
        'ScriptBlock.*'
        '*-ScriptBlock*'
    }
    if( $ModuleConfig.ExportPrefix.Pick ) {
        'Pick.*'
        '*-Pick*'
    }
    if( $ModuleConfig.ExportPrefix.Pk ) {
        'Pk.*'
        '*-Pk*'
    }
)

$ExportMemberPatterns
    | Join-String -op 'Picky::ExportMemberPatterns := ' -sep ', ' | Write-Verbose

Export-ModuleMember -Function @(
    $ExportMemberPatterns
) -Alias @(
    $ExportMemberPatterns
) -Variable @(
    $ExportMemberPatterns
    'Picky_*'
    'PK_*'
)
