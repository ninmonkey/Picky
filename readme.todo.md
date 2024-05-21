### naming note

-- first:
- remove all `Dotils.*`

```sh
To Filter or test, try
    pk.obj? -has Prop1, Prop2
To Assert, use
    pk.Obj! -has Prop1, Prop2
```

### left off

- this test is not hitting blank parameter
```ps1
Picky.Test-Object $o -PropertyName 'Blank', 'Stuff' -NotBlank 'Blank', 'df' -MissingPropery 'cat', 'dog'
|ft
```


### next queue

- [ ] GroupChunks By ShortDateTime, like <file:///H:\data\2024\pwsh\stash-for-logs-for-picky-demos.📁\Github.Action\logs_23978678129%20-%204bitcss\Build4BitCss\8_GitLogger.txt▸manual%20sketch%20shared%20time%20⁞%20iter0.log>


- [ ] `[Globalization.CharUnicodeInfo]` | fime
- [ ] [UnicodeCategory](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.unicodecategory?view=net-8.0)
- String.IsBlank
- String.IsNullable
- Object.Property.IsBlank, IsBasic, isNull, Exists
- Object.GetInfo
- Object.GetPropertyNames
- Dictionary.GetKeyNames
- Dictionary::FromObject
- Object::FromHash
- Dictionary::NewSortedKeys
- [TextInfo](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.textinfo?view=net-8.0)
- [ ] [StringInfo](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo?view=net-8.0)
  - [ ] [ParseCombiningCharacters](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo.parsecombiningcharacters?view=net-8.0)
  - [ ] [LengthInTextElements](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo.lengthintextelements?view=net-8.0)
  - [ ] [Print which position a rune starts on, and what index range the `nth` rune starts on](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo?view=net-8.0#examples)

SelectProperty-ByRegex
SelectProperty-ByBlankValue
SelectStrings-ByMatch

- dotils
- Dotils.Text.Matches, StartsWith, Etc.


### todo

@'
filter presets to drop keys
- [ ]   [System.Management.Automation.PSCmdlet]::CommonParameters
- [ ] [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
- [ ] drop blank keys/props
- [ ] drop whitespace keys/props
- [ ] refactor a stable copy of `Dotils.Format-ShortType`

- [ ] filterMemberNames:
  - [ ] isLong / IsMultiLineProperty 
- [ ] FilterMemberNames:
```ps1
$doc | Nin.Ast.FindIt FunctionDefinitionAst | Picky.ExcludeType ([ScriptBlock], [Ast])

```    

'@

- `System.Management.Automation.ParameterMetadata` from `(gcm 'DoWork').ResolveParameter('Text')`