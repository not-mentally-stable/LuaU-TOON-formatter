# TOON ⇄ JSON Formatter (Luau)
A lightweight Luau module for converting between **JSON** and **TOON**, a human-readable, indentation-based text format designed for configuration files and structured data in Roblox projects.

This module supports:
- JSON ➞ TOON conversion for readability and version control
- TOON ➞ JSON conversion for runtime usage
- Nested tables
- Arrays
- Primitive types (string, number, boolean)

---

## What is TOON?

TOON is a simple text format that represents tables using:
- Indentation (2 spaces per level)
- Comma-separated key/value pairs
- Inline array declarations

you can learn more about TOON [here](https://toonformat.dev/)

### Example TOON

```toon
Player,
  Name,John
  Level,12
  Inventory[3],Sword,Shield,Potion
  Stats,
    Health,100
    Mana,50
```

Equivalent JSON:

```json
{
  "Player": {
    "Name": "John",
    "Level": 12,
    "Inventory": ["Sword", "Shield", "Potion"],
    "Stats": {
      "Health": 100,
      "Mana": 50
    }
  }
}
```

---

## Installation

1. Copy the module into your project (e.g. `ReplicatedStorage/Formatter.luau`)
2. Require it from your scripts

```luau
local Formatter = require(ReplicatedStorage.Formatter)
```

---

## API Reference

```luau
Formatter:JsonToToon(rawjson: string | table): string
```
Converts JSON data into TOON format.

**Parameters**
- `rawjson`  
  - A JSON string  
  - or a Lua table (already decoded)

**Returns**
- A TOON-formatted string

**Example**

```luau
local json = [[
{
  "Settings": {
    "Music": true,
    "Volume": 0.8,
    "Resolutions": [720, 1080, 1440]
  }
}
]]

local toon = Formatter:JsonToToon(json)
print(toon)
```

Output:
```text
Settings,
  Music,true
  Volume,0.8
  Resolutions[3],720,1080,1440
```


```luau
Formatter:ToonToJson(toondata: string | {string}): string
```
Converts TOON data back into JSON.

**Parameters**
- `toondata`  
  - A TOON string  
  - or an array of TOON lines (`{string}`)

**Returns**
- A JSON-encoded string

**Example**

```luau
local toon = [[
Player,
  Name,Alice
  Score,250
  Premium,true
]]

local json = Formatter:ToonToJson(toon)
print(json)
```

Output:
```json
{"Player":{"Name":"Alice","Score":250,"Premium":true}}
```

---

## Supported Data Types

| Type     | Supported |
|----------|-----------|
| string   | Yes |
| number   | Yes |
| boolean  | Yes |
| table    | Yes |
| array    | Yes (numeric keys only) |
| nil      | No |
| userdata | No |
| function | No |

(userdata includes Roblox-DataTypes like Color3 - Vector3 and so on)

---

## Format Rules

- Indentation is **2 spaces per depth level**
- Objects are declared with a trailing comma  
  ```text
  Config,
  ```
- Arrays are declared inline using `[length]`  
  ```text
  Items[2],A,B
  ```
- Order of keys is not guaranteed (Lua table iteration rules apply)

---

## Limitations

- Array values must be primitive types
- Strings are not escaped (`,` and newlines should be avoided in values)
- Mixed tables (array + dictionary) are treated as dictionaries
- Nil values are ignored

---

## Use Cases

- Human-editable configuration files
- Lightweight data serialization for Roblox projects
- Debug-friendly alternatives to raw JSON
- Version control-friendly structured data

---

# Misc...
[![License: ](https://img.shields.io/badge/License%3A-MIT-green?style=plastic)](https://github.com/not-mentally-stable/LuaU-TOON-formatter/blob/main/LICENSE)

[![Scripting Language: LUAU](https://img.shields.io/badge/Scripting%20Language%3A-LUAU-blue?style=plastic)](https://github.com/luau-lang/luau)

[![Object Notation Formats: JSON](https://img.shields.io/badge/Object_Notation_Formats-JSON-yellow?style=plastic&label=Object%20Notation%20Format:&labelColor=black)](https://en.wikipedia.org/wiki/JSON)

[![Object Notation Formats: TOON](https://img.shields.io/badge/Object_Notation_Formats-TOON-fef3c0?style=plastic&label=Object%20Notation%20Format:&labelColor=1b1b1f)](https://github.com/toon-format/toon)
