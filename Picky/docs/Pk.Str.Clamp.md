Picky.String.Clamp
------------------

### Synopsis
Truncate strings within limits, and without out-of-bounds errors

---

### Description

---

### Parameters
#### **InputText**
text to split

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

#### **RelativePos**
which position to end at. negative values are relative
the end of the string
used by SubString(0, RelPos) after safely clamping it

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |2       |false        |

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Picky.String.Clamp [[-InputText] <String>] [[-RelativePos] <Int32>] [<CommonParameters>]
```
