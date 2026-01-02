//: title: ChatGPT は Content-Type が変だと 400 エラーになったと言うらしい
//: subtitle: OpenAI さんドキュメントとかに明記してくださいよ
//: genre: AI
//: tags: chatgpt
//: date: 2026-01-02
//: updated: 2026-01-02
//: breadcrumbs: home, blog, ai, chatgpt
//: meta>description: ChatGPT がウェブ検索を行うとき、Content-Type ヘッダが普通じゃないものだと「400 エラーになった」と言ってくる現象を確認しました。
//: meta>keywords: ChatGPT, AI, Content-Type, 400エラー, ウェブ検索

#import "../static/preamble.typ": *

何この挙動？

#toc()
= どういう意味？

このブログには、ブログ slug (URL の /blog/ 以下の部分) に `.typ` や `.md` をつけると、そのフォーマットで記事を取得できるという機能があります。\
これは ChatGPT などのウェブ検索ができる AI に記事を読ませるときに使えるかなと思って実装したものなのですが、ChatGPT に記事を読ませようとしたところ、以下のような返答が返ってきました。

```
現時点では、そのURLの中身をこちら側で取得して読むことができません。

こちらからアクセスすると取得処理が失敗し、ツール側で「Failed to fetch … (400)」というエラーになります。
```

= なぜこうなったのか

もともと `.typ` や `.md` でアクセスしたときの Content-Type ヘッダは #link("https://www.iana.org/assignments/media-types/media-types.xhtml")[IANA Media Types]に基づき、、#ghlink("/src/app.rs#L254", branch = "911bc977a8a5cd00c2543ab55cc0b85823d83196")[`text/vnd.typst; charset=utf-8` や `text/markdown; charset=utf-8`] となっていました。

しかしどうやら ChatGPT のウェブ検索は、Content-Type ヘッダが `text/html` や `text/plain` などの一般的なものでないと 400 エラーになるようです。\
IANA Media Types に登録されている正しい Content-Type ヘッダを返しているのに 400 エラーになるのは納得がいかないのですが、とりあえず ChatGPT に記事を読ませるためには仕方がないので、AI クローラーかどうかを User-Agent で判定して、AI が `.typ` や `.md` でアクセスしたときの Content-Type ヘッダを `text/plain; charset=utf-8` に#link("https://github.com/waki285/rodin/commit/318fde17e9c9e90b3131800413afb1348bf7b964")[変更しました]。

= おわりに

ChatGPT のウェブ検索を使うときに Content-Type ヘッダが普通じゃないと 400 エラーになるというのはドキュメントにも明記されていないし、結構厄介な問題だと思うので、OpenAI さんドキュメントに明記してほしいです。

せめて理由を Failed to fetch にするのはやめてくれ。