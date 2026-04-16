class Pyve < Formula
  desc "A single, easy entry point for Python virtual environments"
  homepage "https://pointmatic.github.io/pyve"
  url "https://github.com/pointmatic/pyve/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "87a3df95befd47eee56ce83f433659e21ef4939c3da49b1e215cd78027731799"
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
