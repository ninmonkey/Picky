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
        ShortTypeNames = $True
    }

function Picky.GetCommands {
    # quick summary of commands
    # @{
    #     External =
    Get-Command -m Picky
        # WithInternal =
        #     Get-Command Pk*
    # }
}
function pk.Assert.Truthy {
    [Alias(
        'ScriptBlock.GetInfo',
        'pk.ScriptBlock',
        'pk.Sb'
    )]
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool,

        [switch]$IsNot
    )
    # if($MyInvocation.MyCommand.Name -match '\btest\b|\bis\b'){
    if(
        ( $MyInvocation.MyCommand.Name -match '\btest\b|\bis\b' ) -and
        ( $MyInvocation.MyCommand.Name -notmatch 'assert' )
    ){
        $AsBool = $True
    }


    $isTruthy = [bool]$InputObject
    $IsNotTruthy = -not [bool]$InputObject

    if($AsBool) {
        if( $IsNot ) { return -not $IsTruthy }
        else { return $isTruthy}
    }
    if( -not $isTruthy ) {
        [ArgumentException]::new(
        <# paramName: #> 'InputObject',
        <# message: #> 'Was not truthy')
    }
}

            # Error ambigous. Possible matches include: -EnumsAsStrings -EscapeHandling -ErrorAction -ErrorVariable."

    .notes
        future info
        - [ ] ParameterMetadata ResolveParameter(string name);
        - [ ] DefaultParameterSet
        - [ ] ScriptBlock
        - [ ] CommandType

        - [ ] (Jsonify) => Options, Description, Noun, Verb, Name, ModuleName, Source, Version
    #>
    [Alias(
        'Function.GetInfo',
        'pk.Function',
        'pk.Func',
        'pk.Fn',
    )]
    [OutputType(
        'System.Bool'
        # , 'System.Void' # may throw
    )]
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    $test = $InputObject -is 'type'
    if($AsBool) { return $test }
    if(-not $test) {
        throw [ArgumentException]::new(
            <# message: #> 'Was not a typeInfo',
            <# paramName: #> 'InputObject' )
    }
}
function pk.Assert.IsArray {
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    $tinfo = ( $InputObject )?.GetType()
    $test = [System.Management.Automation.LanguagePrimitives]::GetEnumerable(
        $InputObject) -is [object]

    if( $AsBool ) { return $test }
    if( -not $Test ) {
        throw [ArgumentException]::new(
            <# message: #> 'Was not an array. -not LangPrimitive::GetEnumerable',
            <# paramName: #> 'InputObject')
    }
}
function pk.Assert.NotEmpty.List {
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    if( $MyInvocation.InvocationName -in @('pk.Test.NotTrueNull')) {
        $Asbool = $true
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
function Picky.ScriptBlock.GetInfo {
    <#
    .SYNOPSIS
        Quickly and easily grab properties and metadata for [ScriptBlock] types
    .EXAMPLE
        # use auto completion
        Pwsh> gcm 'DoWork'
            | Function.GetInfo ScriptBlock
            | ScriptBlock.GetInfo File
    .EXAMPLE
        gcm Prompt | Function.GetInfo ScriptBlock | SCriptBlock.getInfo PathWithLine
            H:\data\2023\dotfiles.2023\pwsh\src\Invoke-MinimalInit.ps1:161:1

        gcm ScriptBlock.GetInfo | Function.GetInfo ScriptBlock | SCriptBlock.getInfo PathWithLine
            H:\data\2023\pwsh\PsModules\Picky\Picky\Picky.psm1:65:1

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
    [Alias(
        'ScriptBlock.GetInfo',
        'pk.ScriptBlock'
    )]
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
            'Content',
            'StartPosition',
            'Id',
            'PathWithLine',
            'Ast'
        )]
        [string]$OutputKind
    )
    # future: assert properties exist
    process {
        if($Null -eq $InputObject) { return }
        [ScriptBlock]$ObjAsSB = $InputObject

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
        switch( $OutputKind ) {
            'Attributes' {
                # -is [List[Attribute]]
                $result  = $InputObject.Attributes
                break
            }
            'File' {
                # -is [string]
                $result  = $InputObject.File
                break
            }
            'Module' {
                # is [PSModuleInfo]
                $result  = $inputObject.Module
                break
            }
            'StartPosition' {
                # -is [PSToken]
                $result  = $InputObject.StartPosition
                break
            }
            'PathWithLine' {
                # -is [string]
                [PSToken]$Pos     = $InputObject.StartPosition
                [int]$StartLine   = $Pos.StartLine
                [int]$StartCol    = $Pos.StartColumn
                [int]$EndLine     = $Pos.EndLine # prop: NotYetUsed
                [int]$EndCol      = $Pos.EndColumn # prop: NotYetUsed
                [int]$Start       = $Pos.Start # prop: NotYetUsed
                [int]$Length      = $Pos.Length # prop: NotYetUsed
                [string]$FullName = $InputObject.File

                $result = '{0}:{1}:{2}' -f @(
                    $FullName
                    $StartLine
                    $StartCOl
                )
                break
            }
            'Content' {
                $result = $InputObject.StartPosition.Content
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
function Picky.Function.GetInfo {
    <#
    .SYNOPSIS
        Quickly and easily grab properties and metadata for [CommandInfo], [FunctionInfo] etc
    .EXAMPLE
        # use auto completion
        Pwsh> gcm 'DoWork'
            | Function.GetInfo Parameters
    .LINK
        Picky\Function.GetInfo
    .LINK
        Picky\ScriptBlock.GetInfo
    .LINK
        Gcm ConvertTo-Json
            | Function.GetInfo ResolveParameter -ResolveParameter 'e'

            # Error ambigous. Possible matches include: -EnumsAsStrings -EscapeHandling -ErrorAction -ErrorVariable."

    .notes
        future info
        - [ ] ParameterMetadata ResolveParameter(string name);
        - [ ] DefaultParameterSet
        - [ ] ScriptBlock
        - [ ] CommandType

        - [ ] (Jsonify) => Options, Description, Noun, Verb, Name, ModuleName, Source, Version
    #>
    [Alias(
        'Function.GetInfo',
        'pk.Function'
    )]
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

        # Appears to resolve what parameters will resolve using a partial match
        # essentially: Name -like 'query*'
        # case-insensitive. Blank strings throw errors
        # also throws when value is ambigious
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
function Picky.String.GetCrumbs {
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
        'Picky.String.Crumbs',
        'String.GetCrumbs',
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
    if( $ModuleConfig.ExportPrefix.Function ) {
        'Function.*'
        '*-Function*'
    }
    if( $ModuleConfig.ExportPrefix.ScriptBlock ) {
        'ScriptBlock.*'
        '*-ScriptBlock*'
    }
    if( $ModuleConfig.ExportPrefix.Picky ) {
        'Picky.*'
        '*-Picky*'
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
