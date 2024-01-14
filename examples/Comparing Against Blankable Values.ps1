# First, simple versions

function IsNull {
    # test for true null only. everything else is false
    [OutputType('System.Boolean')]
    param( $Object  )
    $null -eq $Object
}
function IsEmptyStr {
    # test for empty string only. everything else is false
    [OutputType('System.Boolean')]
    param( $Object  )
    ($Object -is [string]) -and $Object.length -eq ''
}
function IsBlank {
    [OutputType('System.Boolean')]
    param( $Object )
    [string]::IsNullOrWhiteSpace( $Object )
}


## fancy

function Test-IsBlank {
    <#
    .synopis
        Checks if an object is a true null.
    .link
        https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/rules/possibleincorrectcomparisonwithnull?view=ps-modules
    #>
     param( $Obj, [switch]$AsBool )
    $filtered = $Obj -replace "`a", '' # otherwise ascii bell is not "whitespace"
    if($AsBool) {
       return [string]::IsNullOrWhiteSpace( $filtered )
    }

    $isTrueNull     = $Null -eq $Obj
    $isStr          = $Obj -is [String]
    $isTrueEmptyStr = $isStr -and ($Obj.Length -eq 0)

    $finalLength = if(-not $IsTrueNull) { $Obj.ToString().Length }
    if($isTrueEmptyStr) { $finalLength = '<EmptyStr>' }
    if($IsTrueNull)     { $finalLength = '<null>'     }

    [pscustomobject]@{
        IsTrueNull     = $isTrueNull
        IsEmpty        = [string]::IsNullOrEmpty( $Obj )
        IsTrueEmptyStr = $isTrueEmptyStr
        IsBlank        = [string]::IsNullOrWhiteSpace( $filtered )
        Length         = $finalLength
        RawValue       = $Obj
        Count          = $Obj.Count
        AsBool         = [string]::IsNullOrWhiteSpace( $filtered )
    }
}
