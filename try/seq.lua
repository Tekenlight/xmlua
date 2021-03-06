local xmlua = require("xmlua")


local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<ns1:seq_struct xmlns:ns1="http://example.com">
  <one>1</one>
  <two>2</two>
  <three>3</three>
  <four>4</four>
  <three>3</three>
  <four>4</four>
  <three>3</three>
  <four>4</four>
  <one>11</one>
  <two>22</two>
  <three>33</three>
  <four>44</four>
  <three>33</three>
  <four>44</four>
  <three>33</three>
  <four>44</four>
</ns1:seq_struct>
]]


-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local message = document
  print("Failed to parse XML: " .. message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <root> element as xmlua.Element


print(root:name());
local ch = root:children();
print(ch);
for n,v in pairs(ch) do
	print(n,v);
	--[[for nn,vv in pairs(v) do
		print(nn, vv);
	end]]
end
