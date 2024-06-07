Picky.Text.SkipBeforeMatch
--------------------------

### Synopsis
ignores all text until you reach the first match, output remaining rows
wait until a flag, ignoring output before ti

---

### Description

---

### Examples
> EXAMPLE 1

docker --help
    | Picky.Text.SkipBeforeMatch -BeforePattern '^Commands' -IncludeMatch
    | Picky.Text.SkipAfterMatch  -AfterPattern  '^Global Options'
## outputs

Commands:
    attach      Attach local standard input, output, and error streams to a running container
    commit      Create a new image from a container's changes
    cp          Copy files/folders between a container and the local filesystem
    create      Create a new container
    diff        Inspect changes to files or directories on a container's filesystem
    events      Get real time events from the server
    export      Export a container's filesystem as a tar archive

---

### Parameters
#### **BeforePattern**
filtering regex

|Type      |Required|Position|PipelineInput|Aliases                                                    |
|----------|--------|--------|-------------|-----------------------------------------------------------|
|`[String]`|true    |1       |false        |Regex<br/>Re<br/>Pattern<br/>Condition<br/>Filter<br/>Until|

#### **EscapePattern**
future: Use a parameter set and BeforeLiteral instead of using this switch

|Type      |Required|Position|PipelineInput|Aliases  |
|----------|--------|--------|-------------|---------|
|`[Switch]`|false   |named   |false        |AsLiteral|

#### **TextContent**

|Type        |Required|Position|PipelineInput |Aliases              |
|------------|--------|--------|--------------|---------------------|
|`[Object[]]`|false   |named   |true (ByValue)|Lines<br/>InputObject|

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
Picky.Text.SkipBeforeMatch [-BeforePattern] <String> [-EscapePattern] [-TextContent <Object[]>] [-IncludeMatch] [<CommonParameters>]
```
