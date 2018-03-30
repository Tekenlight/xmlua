local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestNodeSet = {}

function TestNodeSet.test_nth()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A">1</sub>
  <sub class="A">2</sub>
  <sub class="B">3</sub>
</root>
]])
  local node_set = document:search("/root/sub[@class='A']")
  luaunit.assertEquals(node_set[1]:to_xml(),
                       "<sub class=\"A\">1</sub>")
end

function TestNodeSet.test_search()
  local document = xmlua.XML.parse([[
<root>
  <subsub>1</subsub>
  <sub>
    <subsub>2</subsub>
    <subsub>3</subsub>
  </sub>
  <sub>
    <subsub>4</subsub>
    <subsub>5</subsub>
  </sub>
  <subsub>6</subsub>
</root>
]])
  local sub_node_set = document:search("/root/sub")
  luaunit.assertEquals(sub_node_set:search("subsub"):to_xml(),
                       "<subsub>2</subsub>" ..
                       "<subsub>3</subsub>" ..
                       "<subsub>4</subsub>" ..
                       "<subsub>5</subsub>")
end

function TestNodeSet.test_css_select()
  local document = xmlua.XML.parse([[
<root>
  <subsub>1</subsub>
  <sub>
    <subsub>2</subsub>
    <subsub>3</subsub>
  </sub>
  <sub>
    <subsub>4</subsub>
    <subsub>5</subsub>
  </sub>
  <subsub>6</subsub>
</root>
]])
  local sub_node_set = document:css_select("sub")
  luaunit.assertEquals(sub_node_set:css_select("subsub"):to_xml(),
                       "<subsub>2</subsub>" ..
                       "<subsub>3</subsub>" ..
                       "<subsub>4</subsub>" ..
                       "<subsub>5</subsub>")
end

function TestNodeSet.test_to_xml()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A">1</sub>
  <sub class="A">2</sub>
  <sub class="B">3</sub>
</root>
]])
  local node_set = document:search("/root/sub[@class='A']")
  luaunit.assertEquals(node_set:to_xml(),
                       "<sub class=\"A\">1</sub>" ..
                       "<sub class=\"A\">2</sub>")
end

function TestNodeSet.test_to_html()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <p>paragraph1</p>
    <p>paragraph2</p>
    <p>paragraph3</p>
  </body>
</html>
]])
  local node_set = document:search("//p")
  luaunit.assertEquals(node_set:to_html(),
                       "<p>paragraph1</p>" ..
                       "<p>paragraph2</p>" ..
                       "<p>paragraph3</p>")
end

function TestNodeSet.test_content()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <p>paragraph1</p>
    <p>paragraph2</p>
    <p>paragraph3</p>
  </body>
</html>
]])
  local node_set = document:search("//p")
  luaunit.assertEquals(node_set:content(),
                       "paragraph1" ..
                       "paragraph2" ..
                       "paragraph3")
end

function TestNodeSet.test_text()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <p>paragraph1</p>
    <p>paragraph2</p>
    <p>paragraph3</p>
  </body>
</html>
]])
  local node_set = document:search("//p")
  luaunit.assertEquals(node_set:text(),
                       node_set:content())
end

function TestNodeSet.test_paths()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])
  local node_set = document:search("//html/body/*")
  luaunit.assertEquals(node_set:paths(),
                       {"/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_insert_with_node()
  local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>This is test</title>
  </head>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local inserted_node_set = document:search("//title")
  local insert_node = document:search("//html/body/sub1")[1]
  inserted_node_set:insert(insert_node)
  luaunit.assertEquals(inserted_node_set:paths(),
                       {"/html/head/title",
                        "/html/body/sub1"})
end

function TestNodeSet.test_insert_with_position()
  local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>This is test</title>
  </head>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local inserted_node_set = document:search("//html/body/*")
  local insert_node = document:search("//title")[1]
  inserted_node_set:insert(1, insert_node)
  luaunit.assertEquals(inserted_node_set:paths(),
                       {"/html/head/title",
                        "/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_insert_same_node()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local node_set = document:search("//html/body/*")
  node_set:insert(node_set[1])
  luaunit.assertEquals(node_set:paths(),
                       {"/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_remove_with_node()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])
  local node_set = document:search("//html/body/*")
  local node = node_set:remove(node_set[1])
  luaunit.assertEquals({
                         node:path(),
                         node_set:paths(),
                       },
                       {
                         "/html/body/sub1",
                         {"/html/body/sub2",
                          "/html/body/sub3"},
                       })
end

function TestNodeSet.test_remove_with_position()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])
  local node_set = document:search("//html/body/*")
  local node = node_set:remove(1)
  luaunit.assertEquals({
                         node:path(),
                         node_set:paths(),
                       },
                       {
                         "/html/body/sub1",
                         {"/html/body/sub2",
                          "/html/body/sub3"},
                       })
end

function TestNodeSet.test_remove_node_with_specify_not_exist_position()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])
  local node_set = document:search("//html/body/*")
  local node = node_set:remove(4)
  luaunit.assertEquals(node, nil)
  luaunit.assertEquals(node_set:paths(),
                       {"/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_remove_node_with_specify_not_exist_node()
  local document1 = xmlua.HTML.parse([[
<html>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local document2 = xmlua.HTML.parse([[
<html>
  <body>
    <sub4>sub1</sub1>
  </body>
</html>
]])

  local node_set1 = document1:search("//html/body/*")
  local node_set2 = document2:search("//html/body/*")
  local node = node_set1:remove(node_set2[1])
  luaunit.assertEquals(node, nil)
  luaunit.assertEquals(node_set1:paths(),
                       {"/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_unlink()
  local document = xmlua.XML.parse([[
<root>
  <sub1>sub1</sub1>
  <sub2>sub2</sub2>
  <sub3>sub3</sub3>
</root>
]])
  local node_set = document:search("//root/*")
  node_set:unlink()
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  
  
  
</root>
]])
end

function TestNodeSet.test_merge()
  local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>This is test</title>
  </head>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local node_set1 = document:search("//title")
  local node_set2 = document:search("//html/body/*")
  local merged_node_set = node_set1:merge(node_set2)
  luaunit.assertEquals(merged_node_set:paths(),
                       {"/html/head/title",
                        "/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_merge_same_node()
  local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>This is test</title>
  </head>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local node_set1 = document:search("//html/body/*")
  local node_set2 = document:search("//html/body/sub1")
  local merged_node_set = node_set1:merge(node_set2)
  luaunit.assertEquals(merged_node_set:paths(),
                       {"/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end

function TestNodeSet.test_merge_alias()
  local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>This is test</title>
  </head>
  <body>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </body>
</html>
]])

  local node_set1 = document:search("//title")
  local node_set2 = document:search("//html/body/*")
  local merged_node_set = node_set1 + node_set2
  luaunit.assertEquals(merged_node_set:paths(),
                       {"/html/head/title",
                        "/html/body/sub1",
                        "/html/body/sub2",
                        "/html/body/sub3"})
end
