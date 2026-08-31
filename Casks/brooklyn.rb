cask "brooklyn" do
  version "2.2.3"
  sha256 "b7413116e52a8774346f4576c6a062ca17cca980945edf60a97cc023e06cc85d"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.app.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  # 2.0.0 から Brooklyn.app + ScreenSaver App Extension。extension の登録は
  # アプリの初回起動が行う。背景は Brooklyn 本体の
  # docs/decisions/saver をやめアプリ + ScreenSaver App Extension で配布する.md
  app "Brooklyn.app"

  # 同じパスへの入れ替えでは WallpaperAgent が古い解決済みキャッシュのまま
  # extension を起動し、スクリーンセーバーが黒画面になる。再起動で捨てさせる。
  # 実測の記録は Brooklyn 本体の docs/architecture.md
  postflight_steps do
    terminate_process "WallpaperAgent"
  end

  uninstall quit: "dev.nozomiishii.brooklyn"

  zap trash: [
    "~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/dev.nozomiishii.brooklyn.*.plist",
    "~/Library/Containers/dev.nozomiishii.brooklyn.extension",
    "~/Library/Screen Savers/Brooklyn.saver",
  ]
end
