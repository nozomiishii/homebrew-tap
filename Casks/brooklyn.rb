cask "brooklyn" do
  version "2.1.0"
  sha256 "9fe086637cb149f9fe5ad7829d540464573c315b1ff660cd1c271ac7f69cc4cb"

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
