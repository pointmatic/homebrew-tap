class Gitbetter < Formula
  desc "Streamline repetitive git workflows (push, tag) into single interactive commands"
  homepage "https://github.com/pointmatic/gitbetter"
  url "https://github.com/pointmatic/gitbetter/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "861ea0a4445c2eca78a2f91f61e4e74358fa18648ea5af1fe7200aee4c4e8d51"
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
