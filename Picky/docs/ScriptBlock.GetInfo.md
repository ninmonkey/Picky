Picky.ScriptBlock.GetInfo
-------------------------

### Synopsis
Quickly and easily grab properties and metadata for [ScriptBlock] types

---

### Description

---

### Related Links
* [Picky\Function.GetInfo](Picky\Function.GetInfo.md)

* [Picky\ScriptBlock.GetInfo](Picky\ScriptBlock.GetInfo.md)

---

### Examples
use auto completion

```PowerShell
Pwsh> gcm 'DoWork'
    | Function.GetInfo ScriptBlock
    | ScriptBlock.GetInfo File
```
> EXAMPLE 2

```PowerShell
gcm Prompt | Function.GetInfo ScriptBlock | SCriptBlock.getInfo PathWithLine
    H:\data\2023\dotfiles.2023\pwsh\src\Invoke-MinimalInit.ps1:161:1
gcm ScriptBlock.GetInfo | Function.GetInfo ScriptBlock | SCriptBlock.getInfo PathWithLine
    H:\data\2023\pwsh\PsModules\Picky\Picky\Picky.psm1:65:1
```

---

### Parameters
#### **InputObject**

|Type      |Required|Position|PipelineInput                 |Aliases                                                                                       |
|----------|--------|--------|------------------------------|----------------------------------------------------------------------------------------------|
|`[Object]`|true    |named   |true (ByValue, ByPropertyName)|Name<br/>Func<br/>Fn<br/>Command<br/>InObj<br/>Obj<br/>ScriptBlock<br/>SB<br/>E<br/>Expression|

#### **OutputKind**

Valid Values:

* Attributes
* File
* Module
* Content
* StartPosition
* Id
* PathWithLine
* Ast

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |named   |false        |

---

### Outputs
* [Management.Automation.PSModuleInfo](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSModuleInfo)

---

### Notes
future info
- [ ] other scriptblock/function types

- [ ] DefaultParameterSet
- [ ] (Jsonify) => Id, Ast, Module, Etc...

---

### Syntax
```PowerShell
Picky.ScriptBlock.GetInfo -InputObject <Object> [[-OutputKind] <String>] [<CommonParameters>]
```
```PowerShell
Picky.ScriptBlock.GetInfo [-InputObject] <Object> [[-OutputKind] <String>] [<CommonParameters>]
```
