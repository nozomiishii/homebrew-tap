cask "brooklyn" do
  version "1.0.0"
  sha256 "23dadfe01532a6102a091dfb7dc81a9a652388054ec16bf27fe5ebf11d333aeb"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  depends_on :macos

  # `screen_saver` ではなく `artifact` + `postflight_steps` の `symlink` で配置する。
  # mise の brew-cask manager は `screen_saver` スタンザを解釈できず、`artifact` の
  # target も Homebrew prefix 配下に限定するため、prefix へ置いてから home へリンクする。
  # バンドルは 266 MB あるので、複製ではなくリンクにしてディスク使用量を据え置く。
  artifact "Brooklyn.saver", target: "#{HOMEBREW_PREFIX}/share/brooklyn/Brooklyn.saver"

  # install step はサンドボックス子プロセスで走り、その HOME は一時ディレクトリに
  # 差し替えられる (Library/Homebrew/cask/artifact/abstract_artifact.rb)。実 home を
  # 指すには `~` や `$HOME` ではなく `base: :home` を使う必要がある。
  preflight_steps do
    terminate_process "legacyScreenSaver"
    terminate_process "WallpaperAgent"
    terminate_process "System Settings"
    # 旧版のバンドルがキャッシュに残っていると System Settings が古いプレビューを出す
    remove "Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Caches",
           base: :home, recursive: true
  end

  postflight_steps do
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
