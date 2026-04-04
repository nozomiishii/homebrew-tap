cask "brooklyn" do
  version "0.1.10"
  sha256 "e1c1bb5fefe7206129c19e85ab571f9fd8755e29cb2394d5bc3c457acadd6760"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"
end
