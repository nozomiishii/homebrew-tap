cask "brooklyn" do
  version "1.1.1"
  sha256 "9efd49cf4c6d06d022a861979f30760c64ab2f79521fb42f04eecf08aa9bc850"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  depends_on arch: :arm64
  depends_on :macos

  # 配置の設計は docs/decisions/screen_saver を使わず宣言的ステップで cask を書く.md
  artifact "Brooklyn.saver", target: "#{HOMEBREW_PREFIX}/share/brooklyn/Brooklyn.saver"

  preflight_steps do
    terminate_process "legacyScreenSaver"
    terminate_process "WallpaperAgent"
    terminate_process "System Settings"
    # 古いバンドルがキャッシュに残ると System Settings が旧版のプレビューを出す
    remove "Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Caches",
           base: :home, recursive: true
  end

  # `symlink` の overwrite と remove_on_uninstall は Homebrew 6.0.15 で入った新しい
  # キーワードで、それより古い環境では cask ごと読めなくなる。置き換えと後始末は
  # `remove` で明示して、どのバージョンでも読める形にしておく
  postflight_steps do
    # install step の HOME はサンドボックスの一時ディレクトリ。実 home は base: :home で指す
    remove "Library/Screen Savers/Brooklyn.saver", base: :home, recursive: true
    symlink "share/brooklyn/Brooklyn.saver", "Library/Screen Savers/Brooklyn.saver",
            source_base: :homebrew_prefix, target_base: :home
    terminate_process "legacyScreenSaver"
  end

  uninstall_preflight_steps do
    terminate_process "legacyScreenSaver"
    terminate_process "WallpaperAgent"
  end

  uninstall_postflight_steps do
    remove "Library/Screen Savers/Brooklyn.saver", base: :home, recursive: true
  end
end
