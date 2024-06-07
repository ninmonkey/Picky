Picky.String.GetCrumbs
----------------------

### Synopsis
Split a string into chunks.'

---

### Description

---

### Examples
> EXAMPLE 1

```PowerShell
GetStringCrumbs -InputText 'bat man 3.14 cat, n!-choose-r' -SplitBy '[ ]'
```
> EXAMPLE 2

```PowerShell
[WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog', '\W+' )
```
> EXAMPLE 3

```PowerShell
$w1 = [WordCrumb]::new( 'foo bar 3.14 cat!bat; bat cat-dog')
$w1.CrumbCount | Should -be 9
$w1.String = 'foo bar! cat'
$w1.CrumbCount | Should -be 3
$w1.String = 'foo bar'
$w1.CrumbCount | Should -be 2
```

---

### Parameters
#### **InputText**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

#### **SplitBy**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

---

### Syntax
```PowerShell
Picky.String.GetCrumbs [[-InputText] <String>] [[-SplitBy] <String>] [<CommonParameters>]
```
