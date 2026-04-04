cask "brooklyn" do
  version "0.1.9"
  sha256 "14d13e16623bab283b111c439cf1a93584503f39bd3791a4dac3540a4e408e54"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"
end
