class Gitbetter < Formula
  desc "Streamline repetitive git workflows (push, commit, tag) into small set of interactive commands"
  homepage "https://github.com/pointmatic/gitbetter"
  url "https://github.com/pointmatic/gitbetter/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "338b0ee87eb214f3335ad22bb74264a660f4d476d0a0f9d2fd8f4f7852688a43"
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
