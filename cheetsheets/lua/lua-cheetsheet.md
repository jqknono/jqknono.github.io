# lua document

- [Lua 5.3 参考手册](https://cloudwu.github.io/lua53doc/manual.html)
- [极简的 lua 语法 5.1](https://www.lua.org/manual/5.1/manual.html#8)
- [极简的 lua 语法 5.4](https://www.lua.org/manual/5.4/manual.html#9)

Here is the complete syntax of Lua in extended BNF. As usual in extended BNF, {A} means 0 or more As, and [A] means an optional A. (For operator precedences, see §3.4.8; for a description of the terminals Name, Numeral, and LiteralString, see §3.1.)

```
    chunk ::= block

    block ::= {stat} [retstat]

    stat ::=  ‘;’ |
         varlist ‘=’ explist |
         functioncall |
         label |
         **break** |
         **goto** Name |
         **do** block **end** |
         **while** exp **do** block **end** |
         **repeat** block **until** exp |
         **if** exp **then** block {**elseif** exp **then** block} [**else** block] **end** |
         **for** Name ‘=’ exp ‘,’ exp [‘*,*’ exp] **do** block **end** |
         **for** namelist **in** explist **do** block **end** |
         **function** funcname funcbody |
         **local** **function** Name funcbody |
         **local** attnamelist [‘=’ explist]

    attnamelist ::=  Name attrib {‘,’ Name attrib}

    attrib ::= [‘<’ Name ‘>’]

    retstat ::= **return** [explist] [‘;’]

    label ::= ‘::’ Name ‘::’

    funcname ::= Name {‘.’ Name} [‘:’ Name]

    varlist ::= var {‘,’ var}

    var ::=  Name | prefixexp ‘[’ exp ‘]’ | prefixexp ‘.’ Name

    namelist ::= Name {‘,’ Name}

    explist ::= exp {‘,’ exp}

    exp ::=  **nil** | **false** | **true** | Numeral | LiteralString | ‘...’ | functiondef |
         prefixexp | tableconstructor | exp binop exp | unop exp

    prefixexp ::= var | functioncall | ‘(’ exp ‘)’

    functioncall ::=  prefixexp args | prefixexp ‘:’ Name args

    args ::=  ‘(’ [explist] ‘)’ | tableconstructor | LiteralString

    functiondef ::= **function** funcbody

    funcbody ::= ‘(’ [parlist] ‘)’ block end

    parlist ::= namelist [‘,’ ‘...’] | ‘...’

    tableconstructor ::= ‘{’ [fieldlist] ‘}’

    fieldlist ::= field {fieldsep field} [fieldsep]

    field ::= ‘[’ exp ‘]’ ‘=’ exp | Name ‘=’ exp | exp

    fieldsep ::= ‘,’ | ‘;’

    binop ::=  ‘+’ | ‘-’ | ‘*’ | ‘/’ | ‘//’ | ‘^’ | ‘%’ |
         ‘&’ | ‘~’ | ‘|’ | ‘>>’ | ‘<<’ | ‘..’ |
         ‘<’ | ‘<=’ | ‘>’ | ‘>=’ | ‘==’ | ‘~=’ |
         and | or

    unop ::= ‘-’ | not | ‘#’ | ‘~’
```
