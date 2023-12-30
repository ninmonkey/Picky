### properties

Filter members by enum
```ps1
[Reflection.ParameterModifier]
[Reflection.BindingFlags] | fime

[Reflection.BindingFlags]|fime                

    ReflectedType: System.Reflection.BindingFlags

        Name                  MemberType   Definition
        ----                  ----------   ----------
        value__               Field        public int value__;
        Default               Field        public const BindingFlags Default = 0;
        IgnoreCase            Field        public const BindingFlags IgnoreCase = 1;       
        DeclaredOnly          Field        public const BindingFlags DeclaredOnly = 2;     
        Instance              Field        public const BindingFlags Instance = 4;
        Static                Field        public const BindingFlags Static = 8;
        Public                Field        public const BindingFlags Public = 16;
        NonPublic             Field        public const BindingFlags NonPublic = 32;       
        FlattenHierarchy      Field        public const BindingFlags FlattenHierarchy = 64;
        InvokeMethod          Field        public const BindingFlags InvokeMethod = 256;   
        CreateInstance        Field        public const BindingFlags CreateInstance = 512; 
        GetField              Field        public const BindingFlags GetField = 1024;      
        SetField              Field        public const BindingFlags SetField = 2048;      
        GetProperty           Field        public const BindingFlags GetProperty = 4096;   
        SetProperty           Field        public const BindingFlags SetProperty = 8192;
        PutDispProperty       Field        public const BindingFlags PutDispProperty = 16384;
        PutRefDispProperty    Field        public const BindingFlags PutRefDispProperty = 32768;
        ExactBinding          Field        public const BindingFlags ExactBinding = 65536;
        SuppressChangeType    Field        public const BindingFlags SuppressChangeType = 131072;
        OptionalParamBinding  Field        public const BindingFlags OptionalParamBinding = 262144;
        IgnoreReturn          Field        public const BindingFlags IgnoreReturn = 16777216;
        DoNotWrapExceptions   Field        public const BindingFlags DoNotWrapExceptions = 33554432;

```

### strings/types

```ps1
Pwsh> $pbi = Add-type -LiteralPath 'E:\Program Files (x86)\Power BI Desktop\bin\Microsoft.Extensions.Primitives.dll' -PassThru
Pwsh> using namespace Microsoft.Extensions.Primitives
Pwsh> [StringTokenizer]::new('let x = 10 in x', '=') | ft

Buffer          Offset Length Value    HasValue
------          ------ ------ -----    --------
let x = 10 in x      0      6 let x        True
let x = 10 in x      7      8  10 in x     True

[StringTokenizer]::new('let x = 10 in x', ('=', 'x'))|ft

Buffer          Offset Length Value   HasValue
------          ------ ------ -----   --------
let x = 10 in x      0      4 let         True
let x = 10 in x      5      1             True
let x = 10 in x      7      7  10 in      True
let x = 10 in x     15      0             True

find-type *string* -Namespace  Microsoft.Extensions.Primitives | Ft DisplayString

DisplayString
-------------
public struct StringSegment : IEquatable<StringSegment>, IEquatable<string>;
public class StringSegmentComparer : IComparer<StringSegment>, IEqualityComparer<StringSegment>;
public struct StringTokenizer : IEnumerable<StringSegment>, IEnumerable;
public struct StringValues : IList<string>, ICollection<string>, IEnumerable<string>, IEnumerable, 

find-type -FullName *Comparer*
    | sort { $_.Namespace, $_.Name }
    | Ft Name, Namespace, FullName

Name                                Namespace                                          
----                                ---------                                          
AssemblyIdentityComparer            Microsoft.CodeAnalysis                             
ComparisonResult                    Microsoft.CodeAnalysis                             
DesktopAssemblyIdentityComparer     Microsoft.CodeAnalysis                             
SymbolEqualityComparer              Microsoft.CodeAnalysis                             
ConfigurationKeyComparer            Microsoft.Extensions.Configuration                 
StringSegmentComparer               Microsoft.Extensions.Primitives                    
CultureAwareComparer                System                                             
OrdinalComparer                     System                                             
StringComparer                      System                                             
CaseInsensitiveComparer             System.Collections                                 
Comparer                            System.Collections                                 
IComparer                           System.Collections                                 
IEqualityComparer                   System.Collections                                 
ByteEqualityComparer                System.Collections.Generic                         
Comparer`1                          System.Collections.Generic                         
EnumEqualityComparer`1              System.Collections.Generic                         
EqualityComparer`1                  System.Collections.Generic                         
GenericComparer`1                   System.Collections.Generic                         
GenericEqualityComparer`1           System.Collections.Generic                         
IComparer`1                         System.Collections.Generic                         
IEqualityComparer`1                 System.Collections.Generic                         
KeyValuePairComparer                System.Collections.Generic                         
NonRandomizedStringEqualityComparer System.Collections.Generic                         
NullableComparer`1                  System.Collections.Generic                         
NullableEqualityComparer`1          System.Collections.Generic                         
ObjectComparer`1                    System.Collections.Generic                         
ObjectEqualityComparer`1            System.Collections.Generic                         
ReferenceEqualityComparer           System.Collections.Generic                         
DataRowComparer                     System.Data                                        
DataRowComparer`1                   System.Data                                        
TotalOrderIeee754Comparer`1         System.Numerics                                    
HandleComparer                      System.Reflection.Metadata                         
MetadataStringComparer              System.Reflection.Metadata                         
XNodeDocumentOrderComparer          System.Xml.Linq                                    
XNodeEqualityComparer               System.Xml.Linq                                    
```