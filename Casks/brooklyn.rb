cask "brooklyn" do
  version "0.1.25"
  sha256 "1114c96331d4633a023d414d98904f4d69b79b733200e43407a41e2c67a44c9e"

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
    system_command "/usr/bin/xattr",
                   args: ["-d", "-r", "com.apple.quarantine",
                          "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"]
    system_command "/usr/bin/codesign",
                   args: ["--force", "--sign", "-",
                          "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"]
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
