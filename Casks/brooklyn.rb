cask "brooklyn" do
  version "0.1.4"
  sha256 "b681da09159f9d59818337fa276a4c29aefca49375bc7485980a22b21443b6db"

  url "https://github.com/nozomiishii/Brooklyn/releases/download/v#{version}/Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Apple Brooklyn event inspired screen saver for Apple Silicon"
  homepage "https://github.com/nozomiishii/Brooklyn"

  screen_saver "Brooklyn.saver"
end
