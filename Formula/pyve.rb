class Pyve < Formula
  desc "Single, easy entry point for all your virtual environments"
  homepage "https://pointmatic.github.io/pyve"
  url "https://github.com/pointmatic/pyve/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "24b2aef76766baf9cc16cc38f42455e8bd095c81ce1577351175163512bf73a5"
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

  # `pyve self install` (the source-install path) refuses to run for
  # Homebrew-managed installs, so it never provisions Pyve's toolchain venv
  # or the hosted project-guide. `pyve self provision` does exactly that
  # provisioning and is brew-safe — it makes no PATH or binary changes (no
  # second pyve in ~/.local/bin). Run it here so Homebrew users get hosted
  # project-guide at install/upgrade time instead of hitting the bare/asdf
  # trap on their first `pyve init`.
  def post_install
    # Best-effort: a provisioning hiccup (e.g. no network in the
    # post-install sandbox) must not fail `brew install`. `self provision`
    # itself already exits 0, but guard against any unexpected non-zero.
    system bin/"pyve", "self", "provision"
  rescue BuildError
    opoo "pyve: toolchain/project-guide provisioning was skipped; run 'pyve self provision' later."
  end

  # `pyve self provision` (run at install/upgrade time, above) creates files
  # OUTSIDE Homebrew's prefix that `brew uninstall pyve` cannot clean up:
  #   - the toolchain Python venv at ~/.local/share/pyve/toolchain/
  #   - the project-guide shim at ~/.local/bin/project-guide
  # Homebrew has no supported post_uninstall hook for paths outside its
  # prefix, so these are orphaned on `brew uninstall`. Point users at the
  # brew-safe teardown so they can remove them deliberately.
  def caveats
    <<~EOS
      pyve hosts a toolchain Python venv and the Project-Guide CLI outside
      Homebrew's prefix:
        ~/.local/share/pyve/toolchain/   (toolchain Python + hosted tools)
        ~/.local/bin/project-guide       (Project-Guide shim)

      `brew uninstall pyve` CANNOT remove these. For full teardown of the
      hosted tools, run the commands in this order:
        pyve self unprovision --all
        brew uninstall pyve

      Uninstalling Pyve alone leaves Project-Guide working in your projects
      (via the shim above); only the teardown commands above remove it.

      You can reprovision the toolchain any time while Pyve is installed,
      and it will upgrade the hosted Project-Guide:
        pyve self provision        # always pip-installs --upgrade
      (`pyve update` refreshes a project's scaffolding from the version of
      Project-Guide already hosted in the toolchain; it does NOT upgrade it.)

      For general info about Project-Guide, see
      https://pointmatic.github.io/project-guide/
    EOS
  end

  test do
    assert_match "pyve version #{version}", shell_output("#{bin}/pyve --version")
  end
end
