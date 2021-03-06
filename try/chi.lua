local xmlua = require("xmlua")



local xml = [=[
<?xml version="1.0" encoding="UTF-8"?>
<ns2:example_struct xmlns:ns2="http://example.com" xmlns:ns1="http://example1.com" ns1:one="1" ns2:two="2" three="3">
  <ns1:element_struct2>
    <!--author>123</author-->
	<author><![CDATA[They're saying "x < y" & that "z > y" so I guess that means that z > x ]]></author>
    <title>234 &gt; 123</title>
    <genre>345</genre>
  </ns1:element_struct2>
  <author>asdf</author>
  <title>adfas</title>
  <genre>as</genre>
  <s2>
    <author>A43</author>
    <title>A44</title>
    <genre>A45</genre>
  </s2>
  <s2>
    <author>B43</author>
    <title>B44</title>
    <genre>B45</genre>
  </s2>
  <ns2:basic_string_simple_content attr1="123" attr2="CHA">GOWRI</ns2:basic_string_simple_content>
</ns2:example_struct>
]=]

-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local message = document
  print("Failed to parse XML: " .. message)
  os.exit(1)
end

local root = document:root() -- --> <root> element as xmlua.Element
print(root:name());
if ('example_struct' ~= root:name()) then
	print("Not the right XML");
	os.exit(1);
end

local function parse_es2(cur)
	local children = cur:children();
	for _, child in ipairs(children) do
		if ((child:name() == 'author') or
			(child:name() == 'title')) then
			local value = child:node_text(child.document);
			print("Keyword: ", value);
		end
	end
end

local children = root:children();
for _, cur in ipairs(children) do
	if (cur:name() == 'element_struct2') then
		parse_es2(cur);
	end
end

