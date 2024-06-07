Picky.Text.IsEmpty
------------------

### Synopsis
Super simple, is it an empty string or null, optionally allow whitespace

---

### Description

---

### Parameters
#### **TextContent**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|true    |1       |false        |

#### **OrWhitespace**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Outputs
* [Boolean](https://learn.microsoft.com/en-us/dotnet/api/System.Boolean)

---

### Syntax
```PowerShell
Picky.Text.IsEmpty [-TextContent] <Object> [-OrWhitespace] [<CommonParameters>]
```
