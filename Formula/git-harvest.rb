class GitHarvest < Formula
  desc "Clean up merged branches and worktrees (supports squash merges)"
  homepage "https://github.com/nozomiishii/git-harvest"
  url "https://github.com/nozomiishii/git-harvest/archive/refs/tags/v0.1.28.tar.gz"
  sha256 "00983ff0da4dbbe1efe43aaaba65e5877ce69c860f0b1c706426e8e1ba987382"
  license "MIT"

  def install
    bin.install "lib/git-harvest"
  end

  test do
    assert_match "git-harvest v#{version}", shell_output("#{bin}/git-harvest --version")
  end
end
