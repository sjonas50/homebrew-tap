class AtticAi < Formula
  desc "AI-first offline knowledge platform — local inference, RAG, and mesh networking"
  homepage "https://github.com/sjonas50/TheAtticAI"
  url "https://github.com/sjonas50/TheAtticAI/releases/download/v2.1.0/attic-ai-v2.1.0-docker.zip"
  sha256 "c239444997cb86609149303c40523b42509f062ab856ecd0d3efe2dad0b9f911"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    libexec.install Dir["*"], ".env.example"

    # install.command and uninstall.command cd to their own directory and keep
    # .env (the generated secrets) and the Compose project there. The keg is
    # replaced on every upgrade, so the commands stage this release's files in
    # ~/.attic-ai — the same directory the one-line installer uses — keep .env,
    # and run the script from there.
    %w[install uninstall].each do |action|
      (bin/"attic-ai-#{action}").write <<~SH
        #!/bin/bash
        set -euo pipefail
        dir="${ATTIC_AI_HOME:-$HOME/.attic-ai}"
        mkdir -p "$dir"
        install -m 644 "#{opt_libexec}/docker-compose.yml" "#{opt_libexec}/.env.example" "$dir/"
        install -m 755 "#{opt_libexec}/install.command" "#{opt_libexec}/uninstall.command" "$dir/"
        exec /bin/bash "$dir/#{action}.command" "$@"
      SH
    end
  end

  def caveats
    <<~EOS
      The Attic AI runs in Docker. Install Docker Desktop (or Docker Engine with
      the compose plugin) first: https://www.docker.com/products/docker-desktop/

      To install and start all services (first run downloads ~3 GB of images
      plus 1-5 GB of AI models):
        attic-ai-install

      Configuration (.env) lives in ~/.attic-ai (set ATTIC_AI_HOME to change it)
      and survives upgrades. After `brew upgrade attic-ai`, run attic-ai-install
      again to pull the new images and migrate the database.

      To remove all containers, images and data:
        attic-ai-uninstall

      After installation, open: http://localhost:3333
    EOS
  end

  test do
    ENV["ATTIC_AI_HOME"] = testpath/"attic"
    # With no input the uninstaller's confirmation prompt fails, so it exits
    # before touching Docker, after the release files have been staged.
    output = shell_output("#{bin}/attic-ai-uninstall </dev/null 2>&1", 1)
    assert_match "permanently remove", output
    assert_path_exists testpath/"attic/.env.example"
    assert_path_exists testpath/"attic/docker-compose.yml"
    assert_predicate testpath/"attic/install.command", :executable?
  end
end
