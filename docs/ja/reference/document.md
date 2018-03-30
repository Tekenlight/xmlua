---
title: xmlua.Document
---

# `xmlua.Document`クラス

## 概要

ドキュメント用のクラスです。ドキュメントはHTMLドキュメントかXMLドキュメントのどちらかです。

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## プロパティー

### `errors -> {ERROR1, ERROR2, ...}` {#errors}

ドキュメントをパースしているときに発生したエラーをすべて記録しています。

各エラーは以下の構造になっています。

```lua
{
  domain = ERROR_DOMAIN_AS_NUMBER,
  code = ERROR_CODE_AS_NUMBER,
  message = "ERROR_MESSAGE",
  level = ERROR_LEVEL_AS_NUMBER,
  file = nil,
  line = ERROR_LINE_AS_NUMBER,
}
```

今のところ、`domain`と`code`は内部で使用しているlibxml2のエラードメイン（`xmlErrorDomain`）とエラーコード（`xmlParserError`）を直接使用しています。そのためこれらを活用することはできません。

`message`はエラーメッセージです。これがもっとも重要な情報です。

`level`も内部で使用しているlibxml2のエラーレベル（`xmlErrorLevel`）をそのまま使っています。しかし、エラーレベルは少ししかないのでこの値を活用できます。以下がすべてのエラーレベルです。

  * `1` (`XML_ERR_WARNING`)：警告。

  * `2` (`XML_ERR_ERROR`)：復旧可能なエラー。

  * `3` (`XML_ERR_FATAL`)：復旧不可能なエラー。

今のところ、`file`は常に`nil`です。なぜなら、XMLuaはメモリー上のHTML・XMLのパースしかサポートしていないからです。

`line`はこのエラーが発生した行番号です。

## メソッド

### `root() -> xmlua.Element` {#root}

ルート要素を返します。

例：

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> xmlua.Elementオブジェクトな"<root>"要素
```

### `parent() -> nil` {#parent}

常に`nil`を返します。[`xmlua.Element:parent`][element-parent]との一貫性のためにあります。

例：

```lua
require xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")
document:parent() -- -> nil
```

## 参照

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[element-parent]:element.html#parent

[html]:html.html

[xml]:xml.html

[element]:element.html

[serializable]:serializable.html

[searchable]:searchable.html
