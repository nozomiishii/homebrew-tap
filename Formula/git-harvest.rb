class GitHarvest < Formula
  desc "Clean up merged branches and worktrees (supports squash merges)"
  homepage "https://github.com/nozomiishii/git-harvest"
  url "https://github.com/nozomiishii/git-harvest/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "a3c5dd36709e92c4fd71ae4dc00e5abc70f18b6d9bc2d73fa683e8058422bcc9"
  license "MIT"

  def install
    bin.install "lib/git-harvest"
  end

  test do
    assert_match "git-harvest v#{version}", shell_output("#{bin}/git-harvest --version")
  end
end
