cask "brooklyn" do
  version "0.1.26"
  sha256 "7b9232aa6857921ea2f2c455364f266a4c7d57fba6957738604f667f293355b6"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  depends_on :macos

  screen_saver "Brooklyn.saver"

  preflight do
    system_command "/usr/bin/killall",
                   args:         ["legacyScreenSaver"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args:         ["WallpaperAgent"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args:         ["System Settings"],
                   must_succeed: false
    cache_dir = "#{Dir.home}/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Caches"
    system_command "/bin/rm",
                   args:         ["-rf", cache_dir],
                   must_succeed: false
  end

  postflight do
    lsregister = "/System/Library/Frameworks/CoreServices.framework/" \
                 "Frameworks/LaunchServices.framework/Support/lsregister"
    system_command lsregister,
                   args:         ["-f", "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args:         ["legacyScreenSaver"],
                   must_succeed: false
  end

  uninstall_preflight do
    system_command "/usr/bin/killall",
                   args:         ["legacyScreenSaver"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args:         ["WallpaperAgent"],
                   must_succeed: false
  end
end
