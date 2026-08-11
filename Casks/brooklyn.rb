cask "brooklyn" do
  version "1.0.0"
  sha256 "23dadfe01532a6102a091dfb7dc81a9a652388054ec16bf27fe5ebf11d333aeb"

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
