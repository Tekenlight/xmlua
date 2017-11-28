---
title: xmlua.HTML
---

# `xmlua.HTML` class

## Summary

It's a class for parsing a HTML.

The parsed document is returned as [`xmlua.Document`][document] object.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<html><body></body></html>")

-- Call xmlua.Document:root method
document:root() -- -> Root element
```

## Class methods

### `xmlua.HTML.parse(html) -> xmlua.Document` {#parse}

`html`: HTML string to be parsed.

It parses the given HTML and returns `xmlua.Document` object.

The encoding of HTML is guessed.

If HTML parsing is failed, it raises an error.

Here is the error structure:

```lua
{
  message = "Error details",
}
```

Here is an example to parse HTML:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses HTML
local success, document = pcall(xmlua.HTML.parse, html)
if not success then
  local err = document
  print("Failed to parse HTML: " .. err.message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <html> element as xmlua.Element

-- Prints the root element name
print(root:name()) -- -> html
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
