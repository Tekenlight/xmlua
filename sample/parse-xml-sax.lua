#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.XMLSAXParser.new()

parser.start_document = function()
  print("Start document")
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

parser.ignorable_whitespace = function(ignorable_whitespaces)
  print("Ignorable whitespaces: " .. "\"" .. ignorable_whitespaces .. "\"")
  print("Ignorable whitespaces length: " .. #ignorable_whitespaces)
end

parser.text = function(text)
  print("Text: <" .. text .. ">")
end

parser.reference = function(entity_name)
  print("Reference entity name: " .. entity_name)
end

parser.end_document = function()
  print("End document")
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
