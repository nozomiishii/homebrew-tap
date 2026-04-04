cask "brooklyn" do
  version "0.1.12"
  sha256 "82a33d012485c3ec907ce05beec297136b94bea2d9bb8c0637760a01633ff08a"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-d", "-r", "com.apple.quarantine",
                          "#{Dir.home}/Library/Screen Savers/Brooklyn.saver"]
  end
end
