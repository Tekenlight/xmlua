#!/usr/bin/env lua

local xmlua = require("xmlua")
local ffi = require("ffi")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.XMLSAXParser.new()

local function print_element_content(content, indent)
  if content.type == "PCDATA" then
    print(indent .. "type: " .. content.type)
    print(indent .. "occur: " .. content.occur)
  elseif content.type == "ELEMENT" then
    print(indent .. "type: " .. content.type)
    print(indent .. "occur: " .. content.occur)
    print(indent .. "prefix: " .. (content.prefix or ""))
    print(indent .. "name: " .. content.name)
  else
    print(indent .. "type: " .. content.type)
    print(indent .. "occur: " .. content.occur)
    for i, child in pairs(content.children) do
      print(indent .. "child[" .. i .. "]:")
      print_element_content(child, indent .. "  ")
    end
  end
end

parser.element_declaration = function(name,
                                      element_type,
                                      content)
  print("Element name: " .. name)
  print("Element type: " .. element_type)
  if element_type == "EMPTY" then
    return
  end
  print("Content:")
  print_element_content(content, "  ")
end

parser.attribute_declaration = function(name,
                                        attribute_name,
                                        attribute_type,
                                        default_value_type,
                                        default_value,
                                        enumerated_values)
  print("Element name: " .. name)
  print("Attribute name: " .. attribute_name)
  print("Attribute type: " .. attribute_type)
  if default_value then
    print("Default value type: " .. default_value_type)
    print("Default value: " .. default_value)
  end
  for _, v in pairs(enumerated_values) do
    print("Enumrated value: " .. v)
  end
end

parser.notation_declaration = function(name,
                                       public_id,
                                       system_id)
  print("Notation name: " .. name)
  if public_id ~= nil then
    print("Notation public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Notation system id: " .. system_id)
  end
end

parser.unparsed_entity_declaration = function(name,
                                              public_id,
                                              system_id,
                                              notation_name)
  print("Unparserd entity name: " .. name)
  if public_id ~= nil then
    print("Unparserd entity public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Unparserd entity system id: " .. system_id)
  end
  print("Unparserd entity notation_name: " .. notation_name)
end

parser.entity_declaration = function(name,
                                     entity_type,
                                     public_id,
                                     system_id,
                                     content)
  print("Entity name: " .. name)
  print("Entity type: " .. entity_type)
  if public_id ~= nil then
    print("Entity public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Entity system id: " .. system_id)
  end
  print("Entity content: " .. content)
end

parser.internal_subset = function(name,
                                  external_id,
                                  system_id)
  print("Internal subset name: " .. name)
  if external_id ~= nil then
    print("Internal subset external id: " .. external_id)
  end
  if system_id ~= nil then
    print("Internal subset system id: " .. system_id)
  end
end

parser.external_subset = function(name,
                                  external_id,
                                  system_id)
  print("External subset name: " .. name)
  if external_id ~= nil then
    print("External subset external id: " .. external_id)
  end
  if system_id ~= nil then
    print("External subset system id: " .. system_id)
  end
end

parser.cdata_block = function(cdata_block)
  print("CDATA block: " .. cdata_block)
end

parser.comment = function(comment)
  print("Comment: " .. comment)
end

parser.processing_instruction = function(target, data)
  print("Processing instruction target: " .. target)
  print("Processing instruction data: " .. data)
end

parser.text = function(text)
  print("Text: <" .. text .. ">")
end

parser.reference = function(entity_name)
  print("Reference entity name: " .. entity_name)
end

parser.start_element = function(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
  print("Start element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
  for namespace_prefix, namespace_uri in pairs(namespaces) do
    if namespace_prefix  == "" then
      print("  Default namespace: " .. namespace_uri)
    else
      print("  Namespace: " .. namespace_prefix .. ": " .. namespace_uri)
    end
  end
  if attributes then
    if #attributes > 0 then
      print("  Attributes:")
      for i, attribute in pairs(attributes) do
        local name
        if attribute.prefix then
          name = attribute.prefix .. ":" .. attribute.local_name
        else
          name = attribute.local_name
        end
        if attribute.uri then
          name = name .. "{" .. attribute.uri .. "}"
        end
        print("    " .. name .. ": " .. attribute.value)
      end
    end
  end
end

parser.end_element = function(local_name,
                              prefix,
                              uri)
  print("End element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
end

parser.error = function(xml_error)
  print("Error domain:", xml_error["domain"])
  print("Error code:", xml_error["code"])
  print("Error message:", xml_error["message"])
  print("Error level:", xml_error["level"])
  print("Error line:", xml_error["line"])
end

parser.end_document = function()
  print("End document")
end

parser.start_document = function()
  print("Start document")
end

parser.ignorable_whitespace = function(iws)
  print("Ignorable whitespaces: " .. "\"" .. iws .. "\"")
  print("Ignorable whitespaces length: " .. #iws)
end

while true do
  local line = file:read()
  if not line then
    parser:finish()
    break
  end
  parser:parse(line)
end
file:close()
