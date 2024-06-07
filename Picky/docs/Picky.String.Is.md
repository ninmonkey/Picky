Picky.String.Test
-----------------

### Synopsis
Tests a string's attributes or states. a different function is used to filter strings conditionally Picky.String.Select

---

### Description

---

### Related Links
* [Picky.String.SelectBy](Picky.String.SelectBy.md)

* [https://www.unicode.org/reports/tr44/#General_Category_Values](https://www.unicode.org/reports/tr44/#General_Category_Values)

* [https://unicode.org/reports/tr18/](https://unicode.org/reports/tr18/)

* [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Regular_expressions/Unicode_character_class_escape](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Regular_expressions/Unicode_character_class_escape)

* [https://learn.microsoft.com/en-us/dotnet/standard/base-types/character-classes-in-regular-expressions#word-character-w](https://learn.microsoft.com/en-us/dotnet/standard/base-types/character-classes-in-regular-expressions#word-character-w)

---

### Parameters
#### **InputText**

|Type      |Required|Position|PipelineInput                 |Aliases                                                             |
|----------|--------|--------|------------------------------|--------------------------------------------------------------------|
|`[Object]`|true    |named   |true (ByValue, ByPropertyName)|InputObject<br/>Text<br/>In<br/>InObj<br/>InStr<br/>Content<br/>Line|

#### **TestKind**
Potentially use $InputText as an object so that I can test object before coercion
[string] $InputText,
'Nullable',
Valid Values:

* Blank
* Empty
* TrueNull
* TrueEmptyStr
* ControlChars
* Whitespace
* Not.Whitespace
* Len
* CodepointLen
* Invisible
* Letter
* NotLetter
* Word
* Not.Word
* Surrogate
* Not.Surrogate
* Separator

|Type        |Required|Position|PipelineInput|Aliases                                        |
|------------|--------|--------|-------------|-----------------------------------------------|
|`[String[]]`|false   |1       |false        |Test<br/>IsA?<br/>Is?<br/>If<br/>Where<br/>When|

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Picky.String.Test -InputText <Object> [[-TestKind] <String[]>] [<CommonParameters>]
```
```PowerShell
Picky.String.Test [-InputText] <Object> [[-TestKind] <String[]>] [<CommonParameters>]
```
