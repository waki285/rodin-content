//: title: ブログを Rust + Leptos + Typst で書き直した話
//: subtitle: 徒然なるままに
//: genre: バックエンド
//: tags: rust, typst, leptos, backend
//: date: 2025-11-27
//: updated: 2025-12-01
//: breadcrumbs: home, blog, tech, backend
//: meta>description: Rust と Leptos、Typst を使ってブログを書き直しました。自分以外には扱えなくなってしまった気がします
//: meta>keywords: Rust, Leptos, Typst, ブログ, ウェブ開発

#import "_preamble.typ": *

サイトを書き直しました

#toc()
= これは何？

友人に Next.js のアンチがいたのと、高速化にハマっていたので、ブログを Rust + Leptos + Typst で書き直しました。

Typst はドキュメント作成ツールですが、HTML 出力もできるので、ブログ記事の本文を Typst で書いて HTML に変換し、Leptos 側で組み合わせて表示する形にしました#footnote[2025/11/27 時点ではまだ Unstable ではあるのであまり推奨されない]。

Lighthouse スコア満点を目指します

== なぜ Rust + Leptos + Typst なのか

Rust は好きだからです。高速で安全で、最近はウェブ開発のエコシステムも充実してきました。Leptos はコンポーネントベースのフレームワークで、React に似た感覚で書けるので選びました。Typst は友人が妙に推していたので選びました。

== 隠し機能

`/blog/[slug].typ` の記事ページにアクセスすると、記事本文の生 Typst ファイルを得ることができます。また、`/blog/[slug].md` にアクセスすると pandoc で変換された Markdown 版の記事も得られます。

= マークアップテスト
以下はテスト用です

This is a sample `.typ` #highlight("source") file.\
This is line break test.

- Bullet one
- Bullet two
- Bullet three

== Numbered List

+ Numbered first
5. Numbered five?
+ Numbered six!

#hr()

And a *bold* and _italic_ #underline("markers") (left as #strike("plain") text for now#sub("2")#super("citation needed")).

=== Lorem Ipsum
#lorem(10)

#figure(
  img("/assets/images/sample.png", alt: "Make it a Quote Image", width: "393", height: "206", lazy: true),
  caption: [テスト画像]
) <ddd>

```js
const greet = () => {
  console.log("Hello, world!");
};
greet();
```

#link("https://www.youtube.com/watch?v=dQw4w9WgXcQ")[リンクのテスト]

#table(
  columns: 3,
  [
    名前
  ], [
    年齢
  ], [
    職業
  ],
  [
    山田
  ], [
    28
  ], [
    エンジニア
  ],
  [
    佐藤
  ], [
    34
  ], [
    デザイナー
  ],
)

$ limits(sum)_(k = 0)^n a r^k
  = a frac(1 - r^(n + 1), 1 - r) $

ここに数式のテストがあります: $E = m c^2$.

#quote(
  attribution: "芥川龍之介",
)[
  人生は一箱のマッチに似ている。
  重んずるのは馬鹿馬鹿しく、軽んずるのは危険である。
]

これは本文です#footnote[ここに脚注を書く]。

== Callouts

#callout(kind: "info")[
  情報メッセージです。
  aaaaaaaaaa
]

#callout(kind: "warn")[
  注意メッセージです。\
  aaaaaaaaaaa
]

#twitterembed(
  url: "https://twitter.com/catnose99/status/1996798476789874895",
  author: "catnose (@catnose99)",
  date: "2025年12月5日",
  lang: "ja"
)[
  これ#linebreak()
  作者不明のブラウザ拡張機能は入れない方がいい#linebreak()#linebreak()
  フル権限を許可した場合、フォームに入力されたパスワード / クレカ番号までこっそり外部に送信される可能性がある #link("https://t.co/f8ogXxNmOw")[https://t.co/f8ogXxNmOw]
]
