Picky.Text.SkipAfterMatch
-------------------------

### Synopsis
collects text until a pattern is matched, ignores remaining lines

---

### Description

---

### Parameters
#### **AfterPattern**
filtering regex

|Type      |Required|Position|PipelineInput|Aliases                                                    |
|----------|--------|--------|-------------|-----------------------------------------------------------|
|`[String]`|true    |1       |false        |Regex<br/>Re<br/>Pattern<br/>Condition<br/>Filter<br/>After|

#### **TextContent**

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[Object[]]`|false   |named   |true (ByValue)|

#### **IncludeMatch**
default setting ignores the line that matched. this includes it.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Notes
- future: Pass StringBuilder around?
- future: Offset so you say say -2, or +3 index relative the match

---

### Syntax
```PowerShell
Picky.Text.SkipAfterMatch [-AfterPattern] <String> [-TextContent <Object[]>] [-IncludeMatch] [<CommonParameters>]
```
