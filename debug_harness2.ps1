# Import-Module -force -passthru Join-Path ($PSScriptRoot './Picky/Picky.psm1')
#     | Render.ModuleName

function String.GetCrumbs {
    <#
    .SYNOPSIS
        Split a string into items. Split into chunks. Not tokenizing, but word-ize, it'
    .EXAMPLE
        GetStringCrumbs -InputText 'bat man 3.14 cat, n!-choose-r' -SplitBy '[ ]'
    .EXAMPLE
        [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog', '\W+' )
    #>
    [Alias(
        'GetStringCrumbs'
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
Update-TypeData -TypeName WordCrumb -MemberType ScriptProperty -MemberName 'String' -Value $get_RawString -Force -SecondValue $set_RawString
$get_SplitBy = {
    return $this._SplitBy
}
$set_SplitBy = {
    param( [string]$SplitBy )
    $this._SplitBy = $SplitBy
    $this.Update()
}
Update-TypeData -TypeName WordCrumb -MemberType ScriptProperty -MemberName 'SplitBy' -Value $get_SplitBy -Force -SecondValue $set_SplitBy

[WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog', '\W+' )
[WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')

$w1 = [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')
$w1.CrumbCount
$w1.String = 'foo bar'
$w1.CrumbCount | Should -be 2








return

[regex]::new('\W+', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
$sample ??= @{}
[StringComparer]
[StringComparison]
