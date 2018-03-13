---
title: xmlua.Element
---

# `xmlua.Element`クラス

## 概要

要素ノードのためのクラスです。[`xmlua.Document:root`][document-root]と[`xmlua.NodeSet`][node-set]の`[]`を使って、要素オブジェクトを取得することができます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

document:root() -- -> xmlua.Element
document:search("/root")[1] -- -> xmlua.Element
```

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## インスタンスメソッド

### `name() -> string` {#name}

要素の名前を`string`で返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root/>")
local root = document:root()

-- <root>要素の名前は"root"
print(root:name()) -- -> root
```

### `content() -> string` {#content}

この要素の内容を`string`で返します。

内容とはこの要素以下のすべてのテキストです。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  text1
  <child1>child1 text</child1>
  text2
  <child2>child2 text</child2>
  text3
</root>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()

-- <root>要素の内容。空白も含めて<root>要素の内容。
print(root:content())
--
--  text1
--  child1 text
--  text2
--  child2 text
--  text3
--
```

### `text() -> string` {#text}

[`content`](#content)のエイリアス。

### `path() -> string` {#path}

要素のXPathを`string`で返します。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <child1>child1 text</child1>
  <child2>child2 text</child2>
</root>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
-- <root>の全ての子要素を取得します。 (<child1> と <child2>)
local children = root:children()

-- <root>の全ての子要素のXPathを取得します。
for i = 1, #children do
  print(children[i]:path())
  --/root/child1
  --/root/child2
end
```

### `get_attribute(name) -> string` {#get-attribute}

与えられた属性の属性値を取得します。属性が存在しない場合は`nil`を返します。

通常、`element.attribute_name`または`element["attribute-name"]`の形式で使います。`element:get_attribute("attribute-name")`の形式より短く簡単に使えるためです。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- ドットを使った属性値の取得
print(root.class)
-- -> A

-- []を使った属性値の取得
print(root["class"])
-- -> A

-- get_attributeメソッドを使った属性値の取得
print(root:get_attribute("class"))
-- -> A
```

名前空間プレフィックスと一緒に属性名を指定することで名前空間を使うことができます。存在しない名前空間プレフィックスを指定した場合は、属性名として処理されます。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value-example"
      attribute="value"
      nonexistent-namespace:attribute="value-nonexistent-namespace"/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- 名前空間プレフィックスつき
print(root["example:attribute"])
-- -> value-example

-- 名前空間プレフィックスなし
print(root["attribute"])
-- -> value

-- 存在しない名前空間プレフィックスつき
print(root["nonexistent-namespace:attribute"])
-- -> value-nonexistent-namespace
```

### `previous() -> xmlua.Element` {#previous}

前の兄弟要素を`xmlua.Element`として返します。前の兄弟要素が存在しない場合は、`nil`を返します。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- <sub2>の1つ前の兄弟要素を取得
print(sub2:previous():to_xml())
-- <sub1/>

local sub1 = sub2:previous()

-- <sub1>の前の兄弟要素を取得
print(sub1:previous())
-- nil
```

### `next() -> xmlua.Element` {#next}

次の兄弟要素を`xmlua.Element`として返します。次の兄弟要素が無い場合は、`nil`を返します。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- <sub2>の次の兄弟要素を取得
print(sub2:next():to_xml())
-- <sub3/>

local sub3 = sub2:next()

-- <sub3>の次の兄弟要素を取得
print(sub3:next())
-- nil
```

### `parent() -> xmlua.Element` {#parent}

親要素を`xmlua.Element`として返します。要素がルート要素の場合は、[`xmlua.Document`][document]を返します。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- <sub2>の親要素を取得
print(sub2:parent():to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local root = sub2:parent()

-- <root>要素の親要素を取得: xmlua.Document
print(root:parent():to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local document = root:parent()

-- ドキュメントの親を取得
print(document:parent())
-- nil
```

### `children() -> [xmlua.Element]` {#children}

子要素を`xmlua.Element`の配列として返す。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- <root>の全ての子要素を取得(<sub1>, <sub2> and <sub3>)
local subs = root:children()

print(#subs)
-- 3
print(subs[1]:to_xml())
-- <sub1/>
print(subs[2]:to_xml())
-- <sub2/>
print(subs[3]:to_xml())
-- <sub3/>
```

## 参照

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document-root]:document.html#root

[node-set]:node-set.html

[html]:html.html

[xml]:xml.html

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
