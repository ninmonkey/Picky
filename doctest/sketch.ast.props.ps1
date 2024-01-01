function  __Render.ParamAstNames  {
    param(
        [ParameterAst[]]$ParameterAst,
        [ArgumentCompletions('"`n"', ', ')]
        [string]$Separator = "`n"
    )

    $joinStringSplat = @{
        Separator = $Separator
        Property = {@(
            $_.StaticType | Fmt.ShortType
            ': '
            $_.Name
        ) -join ''}
    }
    $ParameterAst | Join-String @joinStringSplat
}

$ast = Dotils.AstFromFile (gi .\tryPublish.ps1) |  % Ast
$query = $ast.FindAll({
    param( [Ast]$Ast )
    end {
        $t = $Ast -is [FunctionDefinitionAst]
        return $t } }, $false)


# $o = $query[1]
$query[1] | iot2 -PassThru|ft
[FunctionDefinitionAst]$one_fnAst = $query[-1]
[ScriptBlockAst]$one_body = $one_fnAst.Body
[ParamBlockAst]$one_paramBlock = $one_body.ParamBlock
[List[AttributeAst]]$one_paramB_Attrs = $one_paramBlock.Attributes # readonly member
[List[ParameterAst]]$one_paramB_Params = $one_paramBlock.Parameters # read only member

h1 'paramBlockAttrs, params'
$one_paramB_Attrs|ft
$one_paramB_Params|ft
 __Render.ParamAstNames  $one_paramB_Params
 __Render.ParamAstNames  $query[1].Body.ParamBlock.Parameters


hr


return


# $one.
# .body #  .Body.ParamBlock.Parameters
# | % gettype # [FunctionDefintionAst]


function Ast.ParameterAst.GetInfo {
    [Alias(
        'Describe.ParameterAst'
    )]
    param(
        [Alias('InputObject', 'Ast', 'Param', 'Parameters')]
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ParameterAst]$ParameterAst,
        [switch]$AsHash
    )
    process {
        $info = [ordered]@{
            StaticType   = $ParameterAst.StaticType
            ShortType    = $ParameterAst.StaticType.Name
            Name         = $ParameterAst.Name
            Attributes   = $ParameterAst.Attributes
            DefaultValue = $ParameterAst.DefaultValue
            ExtentString = $ParameterAst.ExtentString
            File = $ParameterAst

        }
        if( $AsHash ) { return $Info }
        return [pscustomobject]$Info
    }
}


function ScriptExtent.GetInfo {
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
        'Picky.ScriptExtent.GetInfo',
        'Picky.InternalScriptExtent.GetInfo'
        # 'ScriptBlock.GetInfo',
        # 'pk.ScriptBlock',
        # 'pk.Sb'
    )]
    [OutputType(
        'PSModuleInfo'

    )]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        # <ScriptExtent | InternalScriptExtent>
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [Alias(
            'ScriptExtent', 'Extent', 'InternalScriptExtent', 'IScriptExtent', 'ScriptBlock',
            'SB', 'InObj', 'Obj'
        )]
        [object]$InputObject,

        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [Parameter(Mandatory)]
        [ValidateSet(
            'File',
            'Content',
            'StartPosition',
            'PathWithLine'
        )]
        [string]$OutputKind
    )
    # future: assert properties exist
    process {
        if($Null -eq $InputObject) { return }


        if( $InputObject -isnot [ScriptExtent] ) {
            'Expected A <ScriptExtent | ... >. Actual: {0}' -f @(
                $InputObject.GetType().Name
            )
            | Dotils.Write-DimText | Infa
                # | write-warning
        }
        'InputType: {0}, Expected <ScriptExtent>' -f @(
            $InputObject.GetType().Name
        ) | write-verbose

        <#
        'todo: solve later: trouble converting InternalScripTExtent to a explicit type for completions.
        *might* need to instantiate like: [ScriptExtent]::new( $InputObject.StartScriptPosition, $InputObject.EndScriptPosition )'

            [ScriptExtent]$SE = $InputObject

        #>

        # if( -not $InputObject -isnot 'F')
        switch( $OutputKind ) {
            'File' {
                # -is [string]
                $result  = $InputObject.File
                break
            }
            'Content' {
                # is [PSModuleInfo]
                $result  = $InputObject.Text
                break
            }
            'StartPosition' {
                # -is [PSToken]
                $result  = $InputObject.StartLineNumber
                break
            }
            'PathWithLine' {
                [int]$StartLine    = $InputObject.StartLineNumber
                [int]$StartCol     = $InputObject.StartColumnNumber
                [int]$EndLine      = $InputObject.EndLineNumber # prop: NotYetUsed
                [int]$EndCol       = $InputObject.EndColumnNumber # prop: NotYetUsed
                [int]$LengthOffset = $InputObject.EndOffset - $InputObject.StartOffset  # prop: NotYetUsed
                [int]$Length       = $InputObject.Text.Length
                [string]$FullName  = $InputObject.File

                $result = '{0}:{1}:{2}' -f @(
                    $FullName
                    $StartLine
                    $StartCOl
                )
                break
            }
            'Content' {
                $result = $InputObject.Text
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
return
# $o.Parameters[1]
# $o.Parameters|Ft
# $op = $o.Parameters[1]

$o.Parameters.name|ft

hr
hr
return


Describe.Parameter $O.parameters[0]
hr
$O.parameters | Describe.Parameter
