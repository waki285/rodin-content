//: title: Tailwind 使うのやめた
//: subtitle: いまだに CSS の高速化の最適解がわからない
//: genre: フロントエンド
//: tags: css, tailwind, frontend
//: date: 2025-11-27
//: updated: 2025-11-27
//: breadcrumbs: home, blog, tech, frontend
//: meta>description: ブログで Tailwind CSS を使うのをやめました。分割することに効果は (多分) あります
//: meta>keywords: Tailwind, Tailwind CSS, CSS, FCP, ブログ, ウェブ開発

#import "../static/preamble.typ": *

ブログで Tailwind CSS を使うのをやめました

#toc()
= なぜ？

== FCP, LCP を改善したかった
従来のブログでは `/assets/build/tailwind.css` から minify された Tailwind CSS 全体を読み込んでいましたが、これが #link("https://web.dev/articles/fcp?hl=ja")[FCP (First Contentful Paint)] や #link("https://web.dev/articles/lcp?hl=ja")[LCP (Largest Contentful Paint)] のスコアを悪化させている可能性がありました。

ファーストビューに必要な CSS だけをブロッキングで読み込んで、それ以外の CSS は遅延読み込みすることで、FCP や LCP のスコアを改善できると考えたために、どうにかして Tailwind CSS を分割できないかと考えました。

それよりかは、Tailwind CSS を使わずに、必要なスタイルだけを手書きで書く方が効果的だと判断しました。

== ビルドプロセスに npm が入ってくる問題

Tailwind CSS に現状 Rust 製の代替がないため、Tailwind CSS を使う場合はビルドプロセスに npm や Node.js が入ってきてしまいます。\
ブログの他の部分は Rust と Typst で完結しているため、ビルドプロセスに npm や Node.js が入ってくるのは避けたかったです。

今も結局 #link("https://esbuild.github.io")[esbuild] を JavaScript の minify に使ってしまっているのでビルドプロセスに npm が入ってくるのは避けられていないけど。

= やったこと

#ghlink("/static/css/critical.css")[`/assets/css/critical.css`] にファーストビューに必要なスタイルだけを書き、その他のスタイルは #ghlink("/static/css/lazy.css")[`/assets/css/lazy.css`] に置きました。

`/static/css/critical.css` は HTML の `<head>` 内でブロッキングで読み込み、`/static/css/lazy.css` は `media="print"` と `data-unblock-css=1` を指定し最初は適用されないようにし、

```js
const links=[...document.querySelectorAll('link[data-unblock-css="1"]')];
links.forEach(l => {
  const enable= () => { l.media='all'; };
  l.addEventListener('load', enable, { once:true });
  requestAnimationFrame(() => { if (l.sheet) enable(); });
});
```

を実行して遅延読み込みするようにしました。

= 効果

Lighthouse で FCP と LCP のスコアが改善しました...はず。実行前のスコアを忘れたのでわからない。