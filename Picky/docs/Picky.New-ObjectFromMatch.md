Picky.New-ObjectFromMatch
-------------------------

### Synopsis
Converts text to a new PSCustomObject from a regex with named capture groups

---

### Description

---

### Examples
> EXAMPLE 1

$regex = @'
(?x)
# sample: https://regex101.com/r/A7tyKn/1
# ex: " top         Display the running processes of a container"
^
\s+
(?<SubCommand>.*?)
\s+
(?<Description>.*)
$
'@
Pwsh> docker --help | Pk.New-ObjectFromMatch $regex
# output: not perfect, but nice for such a simple pattern

SubCommand  Description
----------  -----------
run         Create and run a new container from an image
exec        Execute a command in a running container
ps          List containers
build       Build an image from a Dockerfile
pull        Download an image from a registry
push        Upload an image to a registry
images      List images

---

### Parameters
#### **Pattern**
regex that has named capture groups. group names control property names

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|true    |1       |false        |Regex  |

#### **InputObject**
what object/string to match

|Type        |Required|Position|PipelineInput |Aliases                                        |
|------------|--------|--------|--------------|-----------------------------------------------|
|`[String[]]`|true    |named   |true (ByValue)|String<br/>Text<br/>Content<br/>InStr<br/>InObj|

#### **EscapePattern**
auto [Regex]::Escape()

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Picky.New-ObjectFromMatch [-Pattern] <String> -InputObject <String[]> [-EscapePattern] [<CommonParameters>]
```
