Picky.ConvertFrom.RegexCollection
---------------------------------

### Synopsis
Collects and transforms results from [Regex]::matches, making interactive use easier.. converts resutls of [Regex]::Matches

---

### Description

expected input input from [Regex]::Matches() which returns
    type: [Match] > [Text.RegularExpressions.Match]
    pstypenames: [Match], [Group], [Capture] > Text.RegularExpressions.*

---

### Examples
> EXAMPLE 1

$found.q | Dotils.Convert.Regex.FromMatchGroup -PreserveNumberedGroups -ReturnKeyNamesOnly | Join-String -sep
', '
0, FieldName, FieldValue, OuterTextFromNoQuoteRecord, ValueWithQuotesOrNot

---

### Parameters
#### **FoundRecords**
regex match collection/group collection

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[Object[]]`|false   |1       |true (ByValue)|

#### **IncludeFailed**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **PreserveNumberedGroups**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **ReturnKeyNamesOnly**
returns every possible named capture group, that found
something in at least one or more collections

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Picky.ConvertFrom.RegexCollection [[-FoundRecords] <Object[]>] [-IncludeFailed] [-PreserveNumberedGroups] [-ReturnKeyNamesOnly] [<CommonParameters>]
```
