cask "brooklyn" do
  version "0.1.8"
  sha256 "2eefd1cd823b2d2418cc9f7e28f4b658c9c59c93cb858bbcfb7c0ce3202f7ee3"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"
end
