local luaunit = require("luaunit")
local xmlua = require("xmlua")

local ffi = require("ffi")

TestXMLSAXParser = {}

function TestXMLSAXParser.test_start_document()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
]]
  local parser = xmlua.XMLSAXParser.new()
  local called = false
  parser.start_document = function()
    called = true
  end

  local succeeded = parser:parse(xml)
  luaunit.assertEquals({succeeded, called}, {true, true})
end


local function collect_texts(chunk)
  local parser = xmlua.XMLSAXParser.new()
  local texts = {}
  parser.text = function(text)
    table.insert(texts, text)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return texts
end

function TestXMLSAXParser.test_text()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<book>
  <title>Hello World</title>
</book>
]]
  local expected = {
    "Hello World",
    "\n",
  }
  luaunit.assertEquals(collect_texts(xml), expected)
end


function TestXMLSAXParser.test_reference()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE test [
  <!ENTITY ref "Reference">
]>
<test>&ref;</test>
]]
  local parser = xmlua.XMLSAXParser.new()
  local entity_names = {}
  parser.reference = function(entity_name)
    table.insert(entity_names, entity_name)
  end

  local succeeded = parser:parse(xml)
  luaunit.assertEquals({succeeded, entity_names}, {true, {"ref"}})
end


local function collect_start_elements(chunk)
  local parser = xmlua.XMLSAXParser.new()
  local elements = {}
  parser.start_element = function(local_name,
                                  prefix,
                                  uri,
                                  namespaces,
                                  attributes)
    local element = {
      local_name = local_name,
      prefix = prefix,
      uri = uri,
      namespaces = namespaces,
      name = name,
      attributes = attributes,
    }
    table.insert(elements, element)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return elements
end


function TestXMLSAXParser.test_start_element_no_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml>
]]
  local expected = {
    {
      local_name = "xml",
      namespaces = {},
      attributes = {},
    },
  }
  luaunit.assertEquals(collect_start_elements(xml), expected)
end

function TestXMLSAXParser.test_start_element_attributes_no_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<product id="20180101" name="xmlua">
]]
  local expected = {
    {
      local_name = "product",
      namespaces = {},
      attributes = {
        {
          local_name = "id",
          value = "20180101",
          is_default = false,
        },
        {
          local_name = "name",
          value = "xmlua",
          is_default = false,
        },
      },
    },
  }
  luaunit.assertEquals(collect_start_elements(xml),
                       expected)
end

function TestXMLSAXParser.test_start_element_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"
  id="top"
  xhtml:class="top-level">
]]
  local expected = {
    {
      local_name = "html",
      prefix = "xhtml",
      uri = "http://www.w3.org/1999/xhtml",
      namespaces = {
        xhtml = "http://www.w3.org/1999/xhtml",
      },
      attributes = {
        {
          local_name = "id",
          value = "top",
          is_default = false,
        },
        {
          local_name = "class",
          prefix = "xhtml",
          uri = "http://www.w3.org/1999/xhtml",
          value = "top-level",
          is_default = false,
        },
      },
    },
  }
  luaunit.assertEquals(collect_start_elements(xml),
                       expected)
end

function TestXMLSAXParser.test_start_element_with_default_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<html xmlns="http://www.w3.org/1999/xhtml"
  id="top"
  class="top-level">
]]
  local expected = {
    {
      local_name = "html",
      uri = "http://www.w3.org/1999/xhtml",
      namespaces = {},
      attributes = {
        {
          local_name = "id",
          value = "top",
          is_default = false,
        },
        {
          local_name = "class",
          value = "top-level",
          is_default = false,
        },
      },
    },
  }
  expected[1].namespaces[""] = "http://www.w3.org/1999/xhtml"
  luaunit.assertEquals(collect_start_elements(xml),
                       expected)
end


local function collect_end_elements(chunk)
  local parser = xmlua.XMLSAXParser.new()
  local elements = {}
  parser.end_element = function(local_name,
                                prefix,
                                uri)
    local element = {
      local_name = local_name,
      prefix = prefix,
      uri = uri,
    }
    table.insert(elements, element)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return elements
end

function TestXMLSAXParser.test_end_element_no_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml></xml>
]]

  local expected = {
    {
      local_name = "xml",
    },
  }
  luaunit.assertEquals(collect_end_elements(xml), expected)
end

function TestXMLSAXParser.test_end_element_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
</xhtml:html>
]]

  local expected = {
    {
      local_name = "html",
      prefix = "xhtml",
      uri = "http://www.w3.org/1999/xhtml",
    },
  }
  luaunit.assertEquals(collect_end_elements(xml),
                       expected)
end

function TestXMLSAXParser.test_end_element_with_default_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<html xmlns="http://www.w3.org/1999/xhtml">
</html>
]]
  local expected = {
    {
      local_name = "html",
      uri = "http://www.w3.org/1999/xhtml",
    },
  }
  luaunit.assertEquals(collect_end_elements(xml),
                       expected)
end


function TestXMLSAXParser.test_end_document()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml></xml>
]]
  local parser = xmlua.XMLSAXParser.new()
  local called = false
  parser.end_document = function()
    called = true
  end

  local succeeded = parser:parse(xml)
  luaunit.assertEquals({succeeded, called}, {true, false})
  succeeded = parser:finish()
  luaunit.assertEquals({succeeded, called}, {true, true})
end
