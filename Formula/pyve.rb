class Pyve < Formula
  desc "A single, easy entry point for Python virtual environments"
  homepage "https://pointmatic.github.io/pyve"
  url "https://github.com/pointmatic/pyve/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "afdadfbace10ccce95c8c0bdd5c47beccb932f982898dcbf007568f0ed464c48"
  license "Apache-2.0"

  # tomllib (used by pyve) requires Python >= 3.11. This brew Python only
  # needs to be a viable bootstrap interpreter; the toolchain venv itself is
  # still version-keyed to DEFAULT_PYTHON_VERSION via _self_install_toolchain_python.
  depends_on "python@3.12"

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
