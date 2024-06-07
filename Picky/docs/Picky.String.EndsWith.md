Picky.String.EndsWith
---------------------

### Synopsis

Picky.String.EndsWith -InputText <string> [-SubString <string>] [-ComparisonType <StringComparison>] [<CommonParameters>]

Picky.String.EndsWith -InputText <string> [-SubString <string>] [-UsingCaseSensitive] [<CommonParameters>]

Picky.String.EndsWith -InputText <string> [-SubString <string>] [-Culture <cultureinfo>] [<CommonParameters>]

---

### Description

---

### Parameters
#### **ComparisonType**

Valid Values:

* CurrentCulture
* CurrentCultureIgnoreCase
* InvariantCulture
* InvariantCultureIgnoreCase
* Ordinal
* OrdinalIgnoreCase

|Type                |Required|Position|PipelineInput|Aliases             |
|--------------------|--------|--------|-------------|--------------------|
|`[StringComparison]`|false   |Named   |false        |CompareType<br/>Type|

#### **Culture**

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[cultureinfo]`|false   |Named   |false        |

#### **InputText**

|Type      |Required|Position|PipelineInput |Aliases                           |
|----------|--------|--------|--------------|----------------------------------|
|`[string]`|true    |Named   |true (ByValue)|Str<br/>Text<br/>InStr<br/>Content|

#### **SubString**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[string]`|false   |Named   |false        |

#### **UsingCaseSensitive**

|Type      |Required|Position|PipelineInput|Aliases                                  |
|----------|--------|--------|-------------|-----------------------------------------|
|`[switch]`|false   |Named   |false        |AsCS<br/>CS<br/>CaseSensitive<br/>UsingCS|

---

### Inputs
System.String

---

### Outputs
* [Object](https://learn.microsoft.com/en-us/dotnet/api/System.Object)

---

### Syntax
```PowerShell
[32;1msyntaxItem[0m
[32;1m[0m```[0m
[32;1m[0m```PowerShell[0m
[32;1m[0m[32;1m----------[0m
[32;1m[0m[32;1m[0m```[0m
[32;1m[0m[32;1m[0m```PowerShell[0m
[32;1m[0m[32;1m[0m{@{name=Picky.String.EndsWith; CommonParameters=True; parameter=System.Object[]}, @{name=Picky.String.EndsWith; CommonParameters=True; parame…[0m
[32;1m[0m[32;1m[0m```[0m
