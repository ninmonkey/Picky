Picky.Test-Object
-----------------

### Synopsis

---

### Description

---

### Parameters
#### **InputObject**

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[Object[]]`|false   |1       |false        |

#### **PropertyName**
Do these properties exist on an object. testing existence, even if they are null

|Type        |Required|Position|PipelineInput|Aliases                   |
|------------|--------|--------|-------------|--------------------------|
|`[String[]]`|false   |named   |false        |HasProp<br/>Exists<br/>Has|

#### **MissingProperty**
propety does not even exist on the type/object

|Type        |Required|Position|PipelineInput|Aliases                                                                                    |
|------------|--------|--------|-------------|-------------------------------------------------------------------------------------------|
|`[String[]]`|false   |named   |false        |NotHasProp<br/>NoProp<br/>DoesNotExist<br/>MissingProp<br/>Missing<br/>HasNone<br/>NotExist|

#### **NotBlank**

|Type        |Required|Position|PipelineInput|Aliases                                              |
|------------|--------|--------|-------------|-----------------------------------------------------|
|`[String[]]`|false   |named   |false        |NotEmpty<br/>IsNotEmpty<br/>IsNotBlank<br/>NotIsBlank|

#### **BlankProp**
does exist, but it's blankable # does this property exist, and it's blankable?
future: distinguish empty vs blank

|Type        |Required|Position|PipelineInput|Aliases                                                          |
|------------|--------|--------|-------------|-----------------------------------------------------------------|
|`[String[]]`|false   |named   |false        |HasBlank<br/>HasEmpty<br/>Empty<br/>IsEmpty<br/>IsBlank<br/>Blank|

---

### Outputs
* PropertyCompareRecord

* [Boolean](https://learn.microsoft.com/en-us/dotnet/api/System.Boolean)

---

### Notes
naming note:
    To Filter or test, try
        pk.obj? -has Prop1, Prop2
    To Assert, use
        pk.Obj! -has Prop1, Prop2

---

### Syntax
```PowerShell
Picky.Test-Object [[-InputObject] <Object[]>] [-PropertyName <String[]>] [-MissingProperty <String[]>] [-NotBlank <String[]>] [-BlankProp <String[]>] [<CommonParameters>]
```
