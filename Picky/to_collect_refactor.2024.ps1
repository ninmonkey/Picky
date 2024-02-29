function GL.FlattenList {
    <#
    .SYNOPSIS
        flatten nested arrays, to a depth of 1
    #>
    [OutputType( [List[Object]], [object[]] )]
    param()
    $Input | %{ $_ }
}
function GL.DistinctList {
    <#
    .SYNOPSIS
        Return a sorted, distinct list. Optionally flatten it first.
    #>
    [OutputType( [List[Object]], [object[]] )]
    param(
        # list of items
        [Parameter(ValueFromPipeline, Mandatory)]
        [object[]]$InputObject,
        # Flatten depth 1
        [switch]$FlattenList,
        # Property to determine unique
        [string]$PropertyName
    )
    begin { [List[Object]]$Items = @() }
    process { $Items.AddRange(@( $InputObject )) }
    end {
        if($FlattenList) { $final = $Items | GL.FlattenList }
        else {  $Final = $Items }
        $sortObjectSplat = @{
            Unique = $true
        }
        if( $PropertyName ) { $sortObjectSplat.Property = $PropertyName }
        $Final | Sort-Object @sortObjectSplat
    }
}
function GL.Test-IsOfType {
    <#
    .SYNOPSIS
        strictly Validate if a type is within a type-group, else throw if group is not handled
    .DESCRIPTION
        this looks excessive but type identification is used a lot and only needs to be correct, once
    .EXAMPLE
        # see ./GitLogger.AzureFunc.Common.tests.ps1
    .LINK
        https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/floating-point-numeric-types
    #>
    [OutputType( [bool] )]
    [Alias('Test-IsOfType', 'GL.IsOfType')]
    param(
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [Parameter(Mandatory)]
        $InputObject,

        [ArgumentCompletions(
            'Int', 'Numeric', 'Float', 'Text',
            'Sql_Int',
            'Dictionary'
        )]
        [string]$GroupName,
        [string]$ByKeyName
    )
    $Config = @{ ThrowOnNull = $false }

    # nyi: Enum, sets, ValueType, ListType, [Ilist], [ICollection], [Ienumerable], [equatable], [icomparible], [icollection/keys]
    $Groups = [ordered]@{}
    # $Groups.Array_Any = [List[Object]]@(  ... )
    $Groups.Int_Signed   = [List[Object]]@( [Int16],  [Int32],  [Int64] ) # server is missing type: [Int128] )
    $Groups.Int_Unsigned = [List[Object]]@( [UInt16], [UInt32], [UInt64] ) # server is missing type: [UInt128] )
    $Groups.Int_SqlInt   = [List[Object]]@( [Data.SqlTypes.SqlInt16], [Data.SqlTypes.SqlInt32], [Data.SqlTypes.SqlInt64] )
    $Groups.Bool         = [List[Object]]@( [bool], [switch] )
    $Groups.Int_Any      = [list[Object]]@(
        $Groups.Int_Signed, $Groups.Int_Unsigned, $Groups.Int_SqlInt | GL.DistinctList -FlattenList) #  Sort-Object -unique )
    $Groups.Float_Any    = [list[Object]]@(
        [Single],[Double], [Decimal]
    )
    $Groups.Bytes_Any = [List[Object]]@(
        [byte]
        # no? [Microsoft.PowerShell.Commands.ByteCollection]
    )
    $Groups.Is_Value = '...'
    $Groups.Is_IDictionary = '...'
    $Groups.Is_ICollection = '...'
    $Groups.Is_IEnumerable = '...'
    $Groups.Numeric_Any = [List[Object]]@(
        $Groups.Int_Any,
        $Groups.Float_Any,
        $Groups.Bytes_Any
        | GL.DistinctList -FlattenList
    )
    $Groups.Text_Any = [List[Object]]@( [string], [char], [Text.Rune] )
    $Groups.Dictionary_Any = [List[Object]]@(
        [hashtable],
        [Collections.IDictionary],
        [Collections.Specialized.OrderedDictionary],
        # server is missing type: [Management.Automation.OrderedHashtable]
    )
    if( $Null -eq $InputObject ) {
        if( $Config.ThrowOnNull ) { throw "InputObject was null " }
        else { return $false }
    }

    if(-not $ByKeyName) {
        $toTest = @( switch($GroupName) {
            'Sql_Int' { $Groups.Int_SqlInt }
            'Int' { $Groups.Int_Any  }
            'Numeric' { $Groups.Numeric_Any }
            'Float' { $Groups.Float_Any }
            'Dictionary' { $Groups.Dictionary_Any }
            'Text' { $Groups.Text_Any }
            default { throw "UnhandledGroupName: $GroupName"}
        } )
    } else {
        if( -not $Groups.Contains('ByKeyName') ) { throw "MissingKey: $ByKeyName "}
        $toTest = $Groups[ $ByKeyName ]
    }

    $toTest = $toTest | GL.DistinctList -FlattenList
    $anyTrue = $toTest.
        ForEach({ $InputObject -is $_ }).
          where({ $_ }, 'first')

    if($AnyTrue.count -gt 0) { return $true }
    else { return $false }
    throw ("ShouldNeverReachException: Unhandled group for: GroupName: {0}, InputType: {1}" -f @(
        ($GroupName ?? $KeyName ?? 'Missing')
        ($Obj)?.GetType()
    ))
}
function GL.ConvertTo-Bool {
    <#
    .SYNOPSIS
        strictly converts strings (from web requests) to bools
    .NOTES
        inclusive type list, where type will fail if they are note explicitly handled
        because you don't want this to silently convert what would be an error without warnings
    .example
        # see ./GitLogger.AzureFunc.Common.tests.ps1
    #>
    [OutputType( [bool] )]
    [CmdletBinding()]
    [Alias('GL.ConvertTo.Bool')]
    param(
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Alias('Text', 'InObj', 'Input', 'In', 'Inp')]
        [Parameter(Mandatory)]
        [object]$InputObject
    )
    $Obj = $InputObject
    if ( $null -eq $Obj ) { return $false }
    if ( $Obj -is [bool] ) { return $Obj }
    if ( GL.Test-IsOfType -In $Obj -GroupName Numeric) {
        return [bool]$Obj
    }
    if ( $Obj -is [string] ) {
        if( [string]::IsNullOrWhiteSpace($Obj) ) { return $false }
        switch -regex ($Obj) {
            '(false|no|n|none|null)' { return $false }
            '(true|yes|y)' { return $true }
            default { }
            # default {
            #     return -not [string]::IsNullOrWhiteSpace( $Obj )
            #     # $msg = 'ConvertTo.Bool variable type not handled in switch: {0} !' -f @(
            #     #     ($Obj)?.GetType() )
            #     # throw $msg
            # }
        }
        return ( -not [string]::IsNullOrWhiteSpace( $Obj ))
    }
    throw 'ShouldNeverReach: Exception'

}
