class Gitbetter < Formula
  desc "Streamline repetitive git workflows (push, commit, tag) into small set of interactive commands"
  homepage "https://github.com/pointmatic/gitbetter"
  url "https://github.com/pointmatic/gitbetter/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "f4c421e722ce4de3e1be3010f88b253ae90df7aac2a4c794799e65517dbcf7c2"
  license "Apache-2.0"

  def install
    libexec.install "lib", "gitbetter.sh", "git-push.sh", "git-commit.sh", "git-tag.sh"
    (bin/"gitbetter").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/gitbetter.sh" "$@"
    SH
    (bin/"git-push").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/git-push.sh" "$@"
    SH
    (bin/"git-commit").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/git-commit.sh" "$@"
    SH
    (bin/"git-tag").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/git-tag.sh" "$@"
    SH
    chmod 0555, [bin/"gitbetter", bin/"git-push", bin/"git-commit", bin/"git-tag"]
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gitbetter --version")
    assert_match "v#{version}", shell_output("#{bin}/git-push --version")
    assert_match "v#{version}", shell_output("#{bin}/git-commit --version")
    assert_match "v#{version}", shell_output("#{bin}/git-tag --version")
  end
end
