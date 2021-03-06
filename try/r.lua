local xmlua = require("xmlua")

local xml = [=[<?xml version="1.0" encoding="UTF-8"?><ns2:example_struct xmlns:ns2="http://example.com" xmlns:ns1="http://example1.com" ns1:one="1" ns2:two="2" three="3"><ns1:element_struct2><author><![CDATA[They're saying "x < y" & that "z > y" so I guess that means that z > x ]]></author><title>234 &gt; 123</title><genre>345</genre></ns1:element_struct2><author>asdf</author><title>adfas</title><genre>as</genre><s2><author>A43</author><title>A44</title><genre>A45</genre></s2><s2><author>B43</author><title>B44</title><genre>B45</genre></s2><ns2:basic_string_simple_content attr1="123" attr2="CHA">GOWRI</ns2:basic_string_simple_content></ns2:example_struct>]=]

local parser = xmlua.XMLSAXParser.new()

parser.start_document = function()
  print("Start document")
end

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

parser.eelement_declaration = function(name,
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

parser.aattribute_declaration = function(name,
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

parser.enotation_declaration = function(name,
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

parser.uunparsed_entity_declaration = function(name,
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

parser.eentity_declaration = function(name,
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

parser.eeinternal_subset = function(name,
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

parser.eexternal_subset = function(name,
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

parser.ccomment = function(comment)
  print("Comment: " .. comment)
end

parser.pprocessing_instruction = function(target, data)
  print("Processing instruction target: " .. target)
  print("Processing instruction data: " .. data)
end

parser.ttext = function(text)
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
  error("Parsing failed");
end

parser.end_document = function()
  print("End document")
end

local status, retval =  pcall(parser.parse, parser, xml);
if (status ~= true) then
	print("Some errror occured");
end
status, retval = pcall(parser.finish, parser);
if (status ~= true) then
	print("Some errror occured before finising");
end
