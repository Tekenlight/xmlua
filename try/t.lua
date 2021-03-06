#!/usr/bin/env lua

local xmlua = require("xmlua")

-- XML to be parsed
local xml = [=[
<?xml version="1.0" encoding="UTF-8"?>
<ns2:example_struct xmlns:ns2="http://example.com" xmlns:ns1="http://example1.com" ns1:one="1" ns2:two="2" three="3">
  <ns1:element_struct2>
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


local xml1 = '<?xml version="1.0" encoding="UTF-8"?><basic_string_nons>ABC</basic_string_nons>'

local tabs = function(i)
	local t = '';
	while ( i > 0) do
		t = t..'\t';
		i = i - 1;
	end
	return t;
end

local tx = require('pl.tablex');

local printa = function(n, element)
	local t = tabs(n);
	local s = tabs(n+1);
	attr = element:attributes()
	if (tx.has_elements(attr)) then
		print(t..'_attr = {');
		for n,v in pairs(attr) do
			print(s..n..' = '..v);
		end
		print(t..'}');
	end
end

local q_name = function(e)
	local ns = e:namespace();
	local name = nil;
	if (ns == nil) then
		name = '{}'..e:name();
	else
		name='{'..ns..'}'..e:name();
	end
	return name;
end

local ffi = require("ffi");

local function printe(n, e)
	local t = tabs(n);
	if (e:is_leaf_node()) then
		if (e.node.properties ~= ffi.NULL) then
			print(t..q_name(e)..' = {');
			printa((n+1), e) 
			local s = tabs(n+1)
			print(s..e:text());
			print(t..'}');
		else
			print(t..q_name(e)..' = '..e:text())
		end
	else
		print(t..q_name(e)..' = {');
		printa((n+1), e);
		for _, child in ipairs(e:children()) do
			printe((n+1), child);
		end
		print(t..'}');
	end
end

-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local message = document
  print("Failed to parse XML: " .. message)
  os.exit(1)
end

printe(0, document:root())

