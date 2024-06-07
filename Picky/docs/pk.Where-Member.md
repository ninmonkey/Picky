Picky.Where-Object
------------------

### Synopsis
This filters objects based on their members. it does not filter properies. filtering properties is Picky.Find-Member/Picky.Find-Object

---

### Description

---

### Parameters
#### **InputObject**

|Type        |Required|Position|PipelineInput                 |
|------------|--------|--------|------------------------------|
|`[Object[]]`|true    |named   |true (ByValue, ByPropertyName)|

#### **PropertyName**
Do these properties exist on an object. testing existence, even if they are null
[Parameter( ParameterSetName='FromPipe',  Position = 0 )]
[Parameter( ParameterSetName='FromParam', Position = 1 )]

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
* [Object](https://learn.microsoft.com/en-us/dotnet/api/System.Object)

---

### Syntax
```PowerShell
Picky.Where-Object -InputObject <Object[]> [-PropertyName <String[]>] [-MissingProperty <String[]>] [-NotBlank <String[]>] [-BlankProp <String[]>] [<CommonParameters>]
```
```PowerShell
Picky.Where-Object [-InputObject] <Object[]> [-PropertyName <String[]>] [-MissingProperty <String[]>] [-NotBlank <String[]>] [-BlankProp <String[]>] [<CommonParameters>]
```
