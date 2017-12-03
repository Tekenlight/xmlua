local NodeSet = {}

local methods = {}

local metatable = {}
function metatable.__index(node_set, key)
  return methods[key]
end

local function map(values, func)
  local converted_values = {}
  for i, value in ipairs(values) do
    local converted_value = func(value)
    table.insert(converted_values, converted_value)
  end
  return converted_values
end

function methods.to_xml(self, options)
  return table.concat(map(self,
                          function(node)
                            return node:to_xml(options)
                          end),
                      "")
end

function methods.to_html(self, options)
  return table.concat(map(self,
                          function(node)
                            return node:to_html(options)
                          end),
                      "")
end

function methods.search(self, xpath)
  local nodes = {}
  for i, node in ipairs(self) do
    local sub_nodes = node:search(xpath)
    for j, sub_node in ipairs(sub_nodes) do
      table.insert(nodes, sub_node)
    end
  end
  return NodeSet.new(nodes)
end

function methods.content(self, xpath)
  return table.concat(map(self,
                          function(node)
                            return node:content() or ""
                          end),
                      "")
end

methods.text = methods.content

function NodeSet.new(nodes)
  setmetatable(nodes, metatable)
  return nodes
end

return NodeSet
