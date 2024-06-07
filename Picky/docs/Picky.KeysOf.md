Picky.Object.KeysOf
-------------------

### Synopsis
Get Keys of any type: dict, object, hashSet, Json, Text, etc

---

### Description

---

### Examples
> EXAMPLE 1

```PowerShell
@{ a = 'stuff' } | Pk.KeysOf
[psobject]@{ a = 'stuff' } | Pk.KeysOf
```
Example: Treat object as Json, and get the keys

$text = Get-Date | select * | ConvertTo-Json
$text | Pk.KeysOf -AsJson | Join-String -sep ', '
# output:
    DisplayHint, DateTime, Date, Day, DayOfWeek, DayOfYear, Hour, Kind,
    Millisecond, Microsecond, Nanosecond, Minute, Month, Second, Ticks, TimeOfDay, Year

Pwsh> # Example: default behavior for strings is to enumerate [Rune]s
$text | Pk.KeysOf

# output:

    Render Hex Dec Utf16 Utf8 Numeric                Cat  Ctrl Enc8 Enc16 Enc16Be Upper Lower
    ------ --- --- ----- ---- -------                ---  ---- ---- ----- ------- ----- -----
    {       7b 123     1    1      -1    OpenPunctuation False   7b 7b 00   00 7b     {     {
    ␍        d  13     1    1      -1            Control  True   0d 0d 00   00 0d     …     …
    ␊        a  10     1    1      -1            Control  True   0a 0a 00   00 0a     …     …

---

### Parameters
#### **InputObject**
An object, [IDictionary], [HashSet], maybe json using 'jq | Keys'

|Type      |Required|Position|PipelineInput |
|----------|--------|--------|--------------|
|`[Object]`|true    |1       |true (ByValue)|

#### **AsJson**
treat strings as json

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Picky.Object.KeysOf [-InputObject] <Object> [-AsJson] [<CommonParameters>]
```
