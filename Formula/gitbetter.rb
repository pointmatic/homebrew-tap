class Gitbetter < Formula
  desc "Streamline repetitive git workflows (push, tag) into single interactive commands"
  homepage "https://github.com/pointmatic/gitbetter"
  url "https://github.com/pointmatic/gitbetter/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "fdb2b54e31c8ca490f1dc1ac9cc7c098e7c6eb6ca84d402d9aa5549f80a1fa26"
  license "Apache-2.0"

  def install
    libexec.install "lib", "gitbetter.sh", "git-push.sh", "git-tag.sh"
    (bin/"gitbetter").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/gitbetter.sh" "$@"
    SH
    (bin/"git-push").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/git-push.sh" "$@"
    SH
    (bin/"git-tag").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/git-tag.sh" "$@"
    SH
    chmod 0555, [bin/"gitbetter", bin/"git-push", bin/"git-tag"]
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gitbetter --version")
    assert_match "v#{version}", shell_output("#{bin}/git-push --version")
    assert_match "v#{version}", shell_output("#{bin}/git-tag --version")
  end
end
