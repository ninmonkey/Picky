
### next queue


- String.IsBlank
- String.IsNullable
- Object.Property.IsBlank, IsBasic, isNull, Exists
- Object.GetInfo
- Object.GetPropertyNames
- Dictionary.GetKeyNames
- Dictionary::FromObject
- Object::FromHash
- Dictionary::NewSortedKeys


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