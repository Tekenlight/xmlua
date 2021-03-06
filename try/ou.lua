#!/usr/bin/env luajit

local xmlua = require("xmlua")
local libxml2 = require("xmlua.libxml2")

local tree
local document

-- Root with namespaces
tree = {
  "root",
  {
    ["xmlns"] = "http://example.com/",
    ["example:attribute"] = "with-namespace",
    ["attribute"] = "without-namespace",
  },
  { "one", {}, "123" },
  { "two", {}, "456" },
}

document = xmlua.XML.build(tree)
libxml2.xmlReconciliateNs(document.document);
print(document:to_xml())
