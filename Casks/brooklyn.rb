cask "brooklyn" do
  version "0.1.16"
  sha256 "23be26e63abc72ca40806f175ea1ccef352ba0ae8bf78000dcc690a39be091b7"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"

  preflight do
    system_command "/usr/bin/killall",
                   args: ["legacyScreenSaver"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args: ["WallpaperAgent"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args: ["System Settings"],
                   must_succeed: false
    cache_dir = "#{Dir.home}/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Caches"
    system_command "/bin/rm",
                   args: ["-rf", cache_dir],
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
                   args: ["-f", "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args: ["legacyScreenSaver"],
                   must_succeed: false
  end

  uninstall_preflight do
    system_command "/usr/bin/killall",
                   args: ["legacyScreenSaver"],
                   must_succeed: false
    system_command "/usr/bin/killall",
                   args: ["WallpaperAgent"],
                   must_succeed: false
  end
end
