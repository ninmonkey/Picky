Picky.TestBools
---------------

### Synopsis
Check if a bunch of bools are all true, or any true, or none true, or all null, or all blank, etc...

---

### Description

There are 4 main conditions
    All, None, Any, First

And a few operands
    True,  False,
    Null,  NotNull
    Blank, NotBlank

---

### Parameters
#### **InputObject**

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[Object[]]`|true    |1       |true (ByValue)|

#### **PassThru**
output the $filter_* variables as a hashtable

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Assert**
write errors, or throw, rather than returning bools

|Type      |Required|Position|PipelineInput|Aliases               |
|----------|--------|--------|-------------|----------------------|
|`[Switch]`|false   |named   |false        |Strict<br/>ErrorOnFail|

---

### Outputs
* [Boolean](https://learn.microsoft.com/en-us/dotnet/api/System.Boolean)

---

### Notes
Naming wise, SomeTrue vs AnyTrue ?

---

### Syntax
```PowerShell
Picky.TestBools [-InputObject] <Object[]> [-PassThru] [-Assert] [<CommonParameters>]
```
