class Gitbetter < Formula
  desc "Streamline repetitive git workflows (push, tag) into single interactive commands"
  homepage "https://github.com/pointmatic/gitbetter"
  url "https://github.com/pointmatic/gitbetter/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "a9163c7b799aaa16d2ba2fa222f1183f299dfbceeaf30e0ec530935f5dd9c292"
  license "Apache-2.0"

  def install
#    libexec.install "lib", "gitbetter.sh", "git-push.sh", "git-tag.sh"
#    (bin/"gitbetter").write <<~SH
#      #!/usr/bin/env bash
#      exec "#{libexec}/gitbetter.sh" "$@"
#    SH
#    (bin/"git-push").write <<~SH
#      #!/usr/bin/env bash
#      exec "#{libexec}/git-push.sh" "$@"
#    SH
#    (bin/"git-tag").write <<~SH
#      #!/usr/bin/env bash
#      exec "#{libexec}/git-tag.sh" "$@"
#    SH
#    chmod 0555, bin/"gitbetter", bin/"git-push", bin/"git-tag"

    # v1.0.0 only
    bin.install "git-push.sh" => "git-push"
    bin.install "git-tag.sh"  => "git-tag"
 
  end

  test do
#    assert_match "v#{version}", shell_output("#{bin}/gitbetter --version")
#    assert_match "v#{version}", shell_output("#{bin}/git-push --version")
#    assert_match "v#{version}", shell_output("#{bin}/git-tag --version")

    # v1.0.0 only
    assert_predicate bin/"git-push", :exist?
    assert_predicate bin/"git-tag",  :exist?
    
  end
end
