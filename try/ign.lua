#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.XMLSAXParser.new()

parser.sstart_element = function(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
end

parser.ignorable_whitespace = function(ignorable_whitespaces)
  print("Ignorable whitespaces: " .. "\"" .. ignorable_whitespaces .. "\"")
  print("Ignorable whitespaces length: " .. #ignorable_whitespaces)
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
