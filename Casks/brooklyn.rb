cask "brooklyn" do
  version "0.1.11"
  sha256 "1e1a4f6d45222fd51d5537f0ddc227e024307e12b6ca85d2cdacf3604bf0de49"

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
