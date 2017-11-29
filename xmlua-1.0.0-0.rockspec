# -*- lua -*-

package = "xmlua"
version = "1.0.0-0"
source = {
  url = "https://github.com/clear-code/xmlua/archive/1.0.0.zip"
}
description = {
  summary = "XMLua is a Lua library for processing XML and HTML",
  detailed = [[
    It's based on libxml2. It uses LuaJIT's FFI module.
    XMLua provides user-friendly API instead of low-level libxml2 API.
    The user-friendly API is implemented top of low-level libxml2 API.
  ]],
  license = "MIT"
  homepage = "https://clear-code.github.io/xmlua/",
  issues_url = "https://github.com/clear-code/xmlua/issues",
  maintainer = "Horimoto Yasuhiro <horimoto@clear-code.com> and Kouhei Sutou <kou@clear-code.com>",
  labels = ["xml"],
}
external_dependencies = {
  libxml2 = {
    library = "xml2"
  }
}
build = {
  type = "builtin",
  modules = {
    xmlua = "xmlua.lua",
    ["xmlua.document"] = "xmlua/document.lua",
    ["xmlua.element"] = "xmlua/element.lua",
    ["xmlua.html"] = "xmlua/html.lua",
    ["xmlua.libxml2"] = "xmlua/libxml2.lua",
    ["xmlua.libxml2.dict"] = "xmlua/libxml2/dict.lua",
    ["xmlua.libxml2.global"] = "xmlua/libxml2/global.lua",
    ["xmlua.libxml2.hash"] = "xmlua/libxml2/hash.lua",
    ["xmlua.libxml2.htmlparser"] = "xmlua/libxml2/htmlparser.lua",
    ["xmlua.libxml2.memory"] = "xmlua/libxml2/memory.lua",
    ["xmlua.libxml2.parser"] = "xmlua/libxml2/parser.lua",
    ["xmlua.libxml2.parser-internals"] = "xmlua/libxml2/parser-internals.lua",
    ["xmlua.libxml2.tree"] = "xmlua/libxml2/tree.lua",
    ["xmlua.libxml2.valid"] = "xmlua/libxml2/valid.lua",
    ["xmlua.libxml2.xmlerror"] = "xmlua/libxml2/xmlerror.lua",
    ["xmlua.libxml2.xmlsave"] = "xmlua/libxml2/xmlsave.lua",
    ["xmlua.libxml2.xmlstring"] = "xmlua/libxml2/xmlstring.lua",
    ["xmlua.libxml2.xpath"] = "xmlua/libxml2/xpath.lua",
    ["xmlua.node-set"] = "xmlua/node-set.lua",
    ["xmlua.searchable"] = "xmlua/searchable.lua",
    ["xmlua.serializable"] = "xmlua/serializable.lua",
    ["xmlua.xml"] = "xmlua/xml.lua"
  },
  copy_directories = {
    "docs"
  }
}
