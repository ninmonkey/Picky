Picky.Object.FirstN
-------------------

### Synopsis
select the first N objects, or lines of text

---

### Description

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ChildItem -recurse . | Pk.FirstN 2
```
> EXAMPLE 2

```PowerShell
docker help | Pk.FirstN 10
## outputs:
Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Common Commands:
run         Create and run a new container from an image
exec        Execute a command in a running container
ps          List containers
build       Build an image from a Dockerfile
```

---

### Parameters
#### **TakeCount**
filtering regex

|Type     |Required|Position|PipelineInput|Aliases             |
|---------|--------|--------|-------------|--------------------|
|`[Int32]`|true    |1       |false        |FirstN<br/>N<br/>Len|

#### **TextContent**

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[Object[]]`|false   |named   |true (ByValue)|

---

### Notes
- some of the Text.*, like this, aren't hardcoded to string
- future: Pass StringBuilder around?
- future: Offset so you say say -2, or +3 index relative the match

---

### Syntax
```PowerShell
Picky.Object.FirstN [-TakeCount] <Int32> [-TextContent <Object[]>] [<CommonParameters>]
```
