cask "brooklyn" do
  version "0.1.7"
  sha256 "15c740302ac53f6ebebed9371ef311540974f9ba93ef53bdba6e7bf10ab0d627"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"
end
