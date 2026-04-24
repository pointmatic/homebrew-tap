class Pyve < Formula
  desc "A single, easy entry point for Python virtual environments"
  homepage "https://pointmatic.github.io/pyve"
  url "https://github.com/pointmatic/pyve/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "2aa7c5d57445df6fcbeda70b092a1010656500ee1cd4fd160fe3864f3b290cb4"
  license "Apache-2.0"

  def install
    # Install pyve.sh and lib/ into libexec so SCRIPT_DIR resolution
    # finds lib/ relative to the actual script location.
    libexec.install "pyve.sh"
    libexec.install "lib"
    chmod 0755, libexec/"pyve.sh"

    # Create a wrapper script in bin/ that execs the real pyve.sh
    (bin/"pyve").write <<~SH
      #!/bin/bash
      exec "#{libexec}/pyve.sh" "$@"
    SH
    chmod 0755, bin/"pyve"
  end

  test do
    assert_match "pyve version #{version}", shell_output("#{bin}/pyve --version")
  end
end
