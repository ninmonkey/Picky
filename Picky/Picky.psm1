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
function pk.Assert.NotTrueNull {
    <#
    .EXAMPLE
    #>
    [Alias('pk.Test.NotTrueNull')]
    param(
        # anything
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
    $isNull = $Null -eq $InputObject
    if( $AsBool ) {
        return $IsNull
    }

    if( $IsNull ) {

        throw [System.ArgumentNullException]::new(
        <# paramName: #> 'InputObject',
        <# message: #> 'Was Null')
    }
}

# this function will create a new object with specific keys from the input object
function Picky.SelectBy-Keys {
    <#
    .SYNOPSIS
        Select properties of objects, or keys for dictionaries, based on key names, dropping other properties
    .NOTES
        - [ ] select by regex
        - [ ] select by condition: blank/whitespace/truenull/trueemptystr

    #>
    [Alias(
        'Picky.Select.Keys',
        'Picky.SelectBy.Keys',
        'pk.SelectBy.Keys'
    )]
    param(
        [Parameter(Mandatory)]
        [object]$InputObject,

        [Parameter(Mandatory)]
        [Alias('Keys', 'Include')]
        [string[]]$KeyName,

        # mandatory else errors
        [Parameter()]
        [Alias('Keys', 'Include')]
        [string[]]$RequiredKeys
    )
    write-warning 'wip: validate /w tests'

    # create a new ordered dictionary object
    $selected = [ordered]@{}

    # iterate over each key name
    foreach($key in $KeyName) {

        # if the key name exists in the input object
        if($InputObject.psobject.properties.name -contains $key) {

            # add the key and associated value to the new object
            $selected.Add($key, $InputObject.$key)
        }
    }

    # if there are required keys
    if($RequiredKeys) {

        # iterate over each required key
        foreach($key in $RequiredKeys) {

            # if the key name exists in the input object
            if($InputObject.psobject.properties.name -contains $key) {

                # add the key and associated value to the new object
                $selected.Add($key, $InputObject.$key)
            }

            # if the key name does not exist in the input object
            else {

                # throw an error message
                $msg = "Required key '$key' not found in input object."
                throw $msg
            }
        }
    }

    # return the new object
    return $selected
}

function Picky.Add.IndexProp {
    <#
    .SYNOPSIS
        add an index property to each object in the chain, starting at 0
    .NOTES
        not performant, modify psobject directly
    .example
        gci ~
            | Sort-Object LastWriteTime -Descending | .Add.IndexProp
            | Sort-Object Name | ft Name, Index, LastWriteTime
    #>
    [Alias(
        'pk.Str.Crumbs',
        'Picky.String.Crumbs',
        'String.GetCrumbs',
        'Pk.StrCrumbs',
        'Pick-WordCrumbs'
        # 'GetStringCrumbs'
    )]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject
    )
    begin {
        [List[Object]]$items = @()
        $Index = 0
    }
    process {
        $items.AddRange(@( $InputObject ))
    }
    end {
        $Items | %{
            $addMemberSplat = @{
                InputObject = $_
                NotePropertyName = 'Index'
                NotePropertyValue = $Index++
                Force = $true
                PassThru = $true
                ErrorAction = 'ignore'
            }
            Add-Member @addMemberSplat
        }
    }
}

function TryDropParams {
    # drop the standard default CmdletBinding parameter names
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Text
    )
    throw 'nyi'

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
    if( $ModuleConfig.ExportPrefix.ShortTypeNames ) {
        'pk.Str*'
        'pk.Func*'
        'pk.fn*'
        'pk.Sb*'
    }
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
