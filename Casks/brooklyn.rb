cask "brooklyn" do
  version "0.1.15"
  sha256 "4840ba981790b41fde2655b64a6290468014503d1cfebab4ceb8671a7f2119d0"

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
    system_command "/bin/rm",
                   args: ["-rf",
                          "#{Dir.home}/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Caches"],
                   must_succeed: false
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-d", "-r", "com.apple.quarantine",
                          "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"]
    system_command "/usr/bin/codesign",
                   args: ["--force", "--sign", "-",
                          "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"]
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
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
