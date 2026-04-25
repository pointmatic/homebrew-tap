class Gitbetter < Formula
  desc "Streamline repetitive git workflows (push, tag) into single interactive commands"
  homepage "https://github.com/pointmatic/gitbetter"
  url "https://github.com/pointmatic/gitbetter/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "36242c36f73d99c89fee5b0679a92ba84353d7164a76b74c3bbe43225085a528"
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
