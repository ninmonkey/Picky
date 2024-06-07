Picky.Function.GetInfo
----------------------

### Synopsis
Quickly and easily grab properties and metadata for [CommandInfo], [FunctionInfo] etc

---

### Description

---

### Related Links
* [Picky\Function.GetInfo](Picky\Function.GetInfo.md)

* [Picky\ScriptBlock.GetInfo](Picky\ScriptBlock.GetInfo.md)

* [Gcm ConvertTo-Json
    | Function.GetInfo ResolveParameter -ResolveParameter 'e'

    # Error ambigous. Possible matches include: -EnumsAsStrings -EscapeHandling -ErrorAction -ErrorVariable."](Gcm ConvertTo-Json
    | Function.GetInfo ResolveParameter -ResolveParameter 'e'

    # Error ambigous. Possible matches include: -EnumsAsStrings -EscapeHandling -ErrorAction -ErrorVariable.".md)

---

### Examples
use auto completion

```PowerShell
Pwsh> gcm 'DoWork'
    | Function.GetInfo Parameters
```

---

### Parameters
#### **InputObject**

|Type      |Required|Position|PipelineInput                 |Aliases                                                                  |
|----------|--------|--------|------------------------------|-------------------------------------------------------------------------|
|`[Object]`|true    |named   |true (ByValue, ByPropertyName)|Name<br/>Func<br/>Fn<br/>Command<br/>InObj<br/>Obj<br/>ScriptBlock<br/>SB|

#### **OutputKind**

Valid Values:

* Attributes
* ScriptBlock
* Module
* Parameters
* ResolveParameter
* ParameterSets

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |named   |false        |

#### **ResolveParameter**
Appears to resolve what parameters will resolve using a partial match
essentially: Name -like 'query*'
case-insensitive. Blank strings throw errors
also throws when value is ambigious

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

---

### Outputs
* [Management.Automation.ScriptBlock](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.ScriptBlock)

* [Management.Automation.PSModuleInfo](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSModuleInfo)

* [IDictionary[string, [Management.Automation.ParameterMetadata]]]

* [Collections.ObjectModel.ReadOnlyCollection[Management.Automation.CommandParameterSetInfo]]

* [Management.Automation.ParameterMetadata](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.ParameterMetadata)

---

### Notes
future info
- [ ] ParameterMetadata ResolveParameter(string name);
- [ ] DefaultParameterSet
- [ ] ScriptBlock
- [ ] CommandType

- [ ] (Jsonify) => Options, Description, Noun, Verb, Name, ModuleName, Source, Version

---

### Syntax
```PowerShell
Picky.Function.GetInfo -InputObject <Object> [[-OutputKind] <String>] [-ResolveParameter <String>] [<CommonParameters>]
```
```PowerShell
Picky.Function.GetInfo [-InputObject] <Object> [[-OutputKind] <String>] [-ResolveParameter <String>] [<CommonParameters>]
```
