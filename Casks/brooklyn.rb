cask "brooklyn" do
  version "1.1.0"
  sha256 "62c2561106471fa5e7baa3b2ce2fce35696145900f97b115f717ae95c43f5c4f"

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

  postflight_steps do
    # install step の HOME はサンドボックスの一時ディレクトリ。実 home は base: :home で指す。
    # `symlink` の `overwrite` は rm_f 止まりで実ディレクトリを消せず EEXIST になるため、
    # 手で展開した旧版が残っている環境のために先に消しておく
    remove "Library/Screen Savers/Brooklyn.saver", base: :home, recursive: true
    symlink "share/brooklyn/Brooklyn.saver", "Library/Screen Savers/Brooklyn.saver",
            source_base: :homebrew_prefix, target_base: :home,
            overwrite: true, remove_on_uninstall: true
    terminate_process "legacyScreenSaver"
  end

  uninstall_preflight_steps do
    terminate_process "legacyScreenSaver"
    terminate_process "WallpaperAgent"
  end
end
