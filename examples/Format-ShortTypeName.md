## Top
- [Top](#top)
- [`Picky.Type.GetInfo`](#pickytypegetinfo)
  - [`Type.GetInfo` `-minCrumbCount`](#typegetinfo--mincrumbcount)
  - [`Type.GetInfo` `-PassThru`](#typegetinfo--passthru)

Examples using `Picky.Type.GetInfo`.
Here's optional aliases for the command:

- `pk.tInfo`
- `pk.Type.GetInfo`
- `pk.Type`

## `Picky.Type.GetInfo`
[Top](#top)

### `Type.GetInfo` `-minCrumbCount` 
[Top](#top)

```ps1
# Sample types to inspect
[Collections.Generic.List[System.IO.FileSystemInfo]]$list1 = @()
$dict1 = [Dictionary[string, int]]
$dict2 = [Dictionary[
  [string], 
  [Dictionary[string, string]]
]] 
```

```ps1
Pwsh🐒> $dict1 | Picky.Type.GetInfo
    
[Dictionary`2<String, Int32>]

Pwsh🐒> $dict1 | Picky.Type.GetInfo -MinCrumbCount 2

[Collections.Generic.Dictionary`2<String, Int32>]

Pwsh🐒> $dict2 | pk.Tinfo

[Dictionary`2<String, Dictionary`2<String, String>>]

Pwsh🐒> $dict2 | pk.Tinfo -MinCrumbCount 2

[Collections.Generic.Dictionary`2<String, Collections.Generic.Dictionary`2<String, String>>]
```
### `Type.GetInfo` `-PassThru`
[Top](#top)

```ps1
Pwsh🐒> $dict2 | pk.Tinfo -PassThru

ShortName      : [Generic.Dictionary`2<String, Generic.Dictionary`2<String, String>>]
ShortNamespace : 
Name           : Dictionary`2
Namespace      : System.Collections.Generic
SourceObj      : System.Collections.Generic.Dictionary`2[System.String,System.Collections.Generic.Dictionary`2[System.String,System.String]]
Tinfo          : System.Collections.Generic.Dictionary`2[System.String,System.Collections.Generic.Dictionary`2[System.String,System.String]]
```