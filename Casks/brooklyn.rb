cask "brooklyn" do
  version "2.2.0"
  sha256 "6e7014ecb21874103b8758ac42c45276db2fffcc2b70408291bd8e4c5d385f50"

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

  uninstall quit: "dev.nozomiishii.brooklyn"

  zap trash: [
    "~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/dev.nozomiishii.brooklyn.*.plist",
    "~/Library/Containers/dev.nozomiishii.brooklyn.extension",
    "~/Library/Screen Savers/Brooklyn.saver",
  ]
end
