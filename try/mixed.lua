local xmlua = require("xmlua")

local xml = [=[<?xml version="1.0" encoding="UTF-8"?>
<ns2:example_struct xmlns:ns2="http://example.com" xmlns:ns1="http://example1.com" ns1:one="1" ns2:two="2" three="3">alskdfjlkasjf asldfjlkasjf adslkfj adslkfj<s2>
		<author>A43</author>
		<title>A44</title>
		<genre>A45</genre>
	</s2> lkasjdfka sfaslkjf aslk asldflk asfkjhasfslkj  jkahsfiuashkashpiggafuslugfio kjyslkjhsd <s2>
		<author>B43</author>
		<title>B44</title>
		<genre>B45</genre>
	</s2>lkasjdfka sfaslkjf aslk asldflk asfkjhasfslkj  jkahsfiuashkashpiggafuslugfio kjyslkjhsd <ns2:basic_string_simple_content attr1="123" attr2="CHA">GOWRI</ns2:basic_string_simple_content>
</ns2:example_struct>
]=]

local doc = {};

local st = (require('stack')).new();

st:push(doc);

local reader = xmlua.XMLReader.new(xml);

local function process_node(reader)
	local name = reader:const_local_name()
	local uri = reader:const_namespace_uri();
	local value = reader:const_value();
	local depth = reader:node_depth();
	local typ = reader:node_type();
	local is_empty = reader:node_is_empty_element();
	local has_value = reader:node_reader_has_value();

	--print(depth, typ, name, is_empty, has_value, value);
	if (typ == reader.node_types.XML_READER_TYPE_ELEMENT) then
		local node = {};

		--node.depth = depth;
		if uri == nil then
			uri = ''
		end
		local node_name = '{'..uri..'}'..name;
		node[1] = node_name;

		local attr = {}
		local n = reader:get_attr_count();
		if (n >0) then
			for i=0,n-1 do
				reader:move_to_attr_no(i);
				local attr_name = reader:const_local_name()
				local attr_value = reader:const_value();
				local attr_uri = reader:const_namespace_uri();
				if attr_uri == nil then
					attr_uri = ''
				end
				local attr_name = '{'..attr_uri..'}'..attr_name;
				attr[attr_name] = attr_value;
			end
		end

		node[2] = attr; -- Attributes
		st:push(node);
	elseif (typ == reader.node_types.XML_READER_TYPE_TEXT) then
		local va = st:top();
		va[#va+1] = value;
	elseif (typ == reader.node_types.XML_READER_TYPE_CDATA) then
		local va = st:top();
		va[#va+1] = value;
	elseif (typ == reader.node_types.XML_READER_TYPE_END_ELEMENT) then
		local node = st:pop();
		local va = st:top();
		va[#va+1] = node;
	end
end

local ret = reader:read();
while (ret == 1) do
	process_node(reader);
	ret = reader:read(reader);
end

require 'pl.pretty'.dump(doc);

--print("Reached here");
