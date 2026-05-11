class GitHarvest < Formula
  desc "Clean up merged branches and worktrees (supports squash merges)"
  homepage "https://github.com/nozomiishii/git-harvest"
  url "https://github.com/nozomiishii/git-harvest/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "14fed8a439f3e703a08f65d39fd857d7d4bd59ed4b6d92afceb8acd99624707e"
  license "MIT"

  def install
    bin.install "lib/git-harvest"
  end

  test do
    assert_match "git-harvest v#{version}", shell_output("#{bin}/git-harvest --version")
  end
end
