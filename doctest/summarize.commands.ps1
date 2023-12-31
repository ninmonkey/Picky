﻿err -Clear
$modPath = Join-Path $PSScriptRoot '../Picky/Picky.psm1'
impo $modPath -force -PassThru | Join-String { $_.Name, $_.Version, $_.Path}

impo nin.Ast -force -PassThru -ea 'stop'



$astDoc = Dotils.Ast.GetAstFromFile -FileName $modPath
$root = $astDoc.Ast
$root.EndBlock.Statements.Left | ft -AutoSize

@'
VariablePath        Splatted StaticType                                       Extent                              Parent
------------        -------- ----------                                       ------                              ------
script:ModuleConfig    False System.Object                                    $script:ModuleConfig                $script:ModuleConfig = @{…
script:Color           False System.Object                                    $script:Color                       $script:Color = @{…
get_RawString          False System.Object                                    $get_RawString                      $get_RawString = {…
set_RawString          False System.Object                                    $set_RawString                      $set_RawString = {…
get_SplitBy            False System.Object                                    $get_SplitBy                        $get_SplitBy = {…
set_SplitBy            False System.Object                                    $set_SplitBy                        $set_SplitBy = {…
add_ScriptProperty     False System.Object                                    $add_ScriptProperty                 $add_ScriptProperty = @{…
updateTypeDataSplat    False System.Object                                    $updateTypeDataSplat                $updateTypeDataSplat = @{…
updateTypeDataSplat    False System.Object                                    $updateTypeDataSplat                $updateTypeDataSplat = @{…
                             System.Collections.Generic.List`1[System.Object] [List[object]]$ExportMemberPatterns [List[object]]$ExportMemberPatterns = @(…
'@


'sketch at
    <file:///H:\data\2023\pwsh\sketches\2023-01-01-Ast-of-mymodule\AST-types-from-AST-Parsing.ps1>  # older one
    <file:///H:\data\2023\pwsh\sketches\2023-01-01-Ast-of-mymodule\Ast-GeneratingDocs.ps1>
    ' | write-warning


$root | Nin.Ast.FindIt AttributeAst | Select -first 10
|ft


# function Dotils.Accum.Hashtable {
#     # iteratively appending, multiple invokes verses a normal hash merge
#     param(

#     )
# }
