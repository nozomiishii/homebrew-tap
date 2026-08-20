# screen_saver を使わず宣言的ステップで cask を書く

Status: superseded
Date: 2026-08-19

2.0.0 で配布物が Brooklyn.app + ScreenSaver App Extension になり、cask は app アーティファクトへ移った。判断は Brooklyn 本体の [ADR](https://github.com/nozomiishii/Brooklyn/blob/main/docs/decisions/saver%20%E3%82%92%E3%82%84%E3%82%81%E3%82%A2%E3%83%97%E3%83%AA%20%2B%20ScreenSaver%20App%20Extension%20%E3%81%A7%E9%85%8D%E5%B8%83%E3%81%99%E3%82%8B.md)。`api/cask/<token>.json` の公開だけはこの repo の scripts/generate-cask-api.rb と Brooklyn の release workflow で続いている。

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

- mise ではまだ入らない。`unsupported preflight_steps paths base home` で止まる。パス base を解釈する箇所は 3 つあり、`copy` と `symlink` 用は `staged_path` / `appdir` / `homebrew_prefix` / `relative`、`run` 用はうち 3 つ、`remove` 用は `staged_path` だけ。`remove` の狭さは設計判断に見えるので、`home` を足すだけで済むとは限らない
- バンドルの実体は Homebrew prefix へ移り、`~/Library/Screen Savers` は symlink になる。ディスク使用量は変わらず、システム設定からの選択と再生も従来どおり動くことを実機で確認した
