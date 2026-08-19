# screen_saver を使わず宣言的ステップで cask を書く

Status: accepted
Date: 2026-08-19

## Context — 判断を迫られた状況

dotfiles の Brewfile を mise の `brew-cask:` へ移す調査で、brooklyn だけが入らないと分かった。経緯は [#63](https://github.com/nozomiishii/homebrew-tap/issues/63)。

mise は `screen_saver` アーティファクトを解釈できず、generic artifact の target も Homebrew prefix 配下に限定する。lifecycle hook を Ruby ブロックで書くと mise は `.rb` を自前の shim で実行するが、その shim も `screen_saver` と `artifact` を知らない。tap の `api/cask/<token>.json` も無かった。Homebrew 6 の宣言的 `postflight_steps` には prefix 制約が無い。

## Decision — 決めたこと

- `screen_saver` をやめ、`artifact` で prefix へ置いてから `postflight_steps` の `symlink` で home へリンクする。バンドルが 266 MB あるため複製はしない
- Ruby ブロックの `preflight` / `postflight` を宣言的ステップへ移す
- home を指すパスは `base: :home` で書く
- home 側の置き換えは `symlink` の `overwrite` に任せず、先に `remove` で消す。`overwrite` は `rm_f` 止まりで、手で展開した実ディレクトリが残っていると `EEXIST` で install ごと落ちる
- `api/cask/<token>.json` を tap にコミットし、Brooklyn の release workflow で cask の bump と同じコミットに載せる
- `lsregister` での登録はやめる。prefix 配下のバンドルは Spotlight の索引外で `-10811` になる
- `/Library/Screen Savers` へ置けば mise でも動くが、sudo が要るため採らない

## Consequences — 決定がもたらすもの

- mise ではまだ入らない。残るのは `base: "home"` の未対応だけで、jdx/mise のパーサに足せば済む
- Homebrew 側の配置先とディスク使用量は変わらない
