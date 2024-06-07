Picky.Type.GetInfo
------------------

### Synopsis
Quickly and easily grab properties and metadata from types

---

### Description

---

### Examples
> EXAMPLE 1

---

### Parameters
#### **InputObject**

|Type      |Required|Position|PipelineInput                 |Aliases                                     |
|----------|--------|--------|------------------------------|--------------------------------------------|
|`[Object]`|true    |named   |true (ByValue, ByPropertyName)|Name<br/>Type<br/>TypeInfo<br/>InObj<br/>Obj|

#### **OutputKind**

Valid Values:

* Name
* Namespace
* ShortName
* ShortNamespace

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

#### **MinCrumbCount**

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |

#### **PassThru**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

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
Picky.Type.GetInfo -InputObject <Object> [[-OutputKind] <String>] [-MinCrumbCount <Int32>] [-PassThru] [<CommonParameters>]
```
```PowerShell
Picky.Type.GetInfo [-InputObject] <Object> [[-OutputKind] <String>] [-MinCrumbCount <Int32>] [-PassThru] [<CommonParameters>]
```
