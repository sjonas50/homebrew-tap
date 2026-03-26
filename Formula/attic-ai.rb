class AtticAi < Formula
  desc "AI-first offline knowledge platform — local inference, RAG, and mesh networking"
  homepage "https://github.com/sjonas50/nomad2.0"
  url "https://github.com/sjonas50/nomad2.0/releases/latest/download/attic-ai-v2.0.0-arm64.zip"
  version "2.0.0"
  license "MIT"

  depends_on "docker" => :optional

  def install
    prefix.install Dir["*"]
    bin.install_symlink prefix/"install.command" => "attic-ai-install"
    bin.install_symlink prefix/"uninstall.command" => "attic-ai-uninstall"
  end

  def caveats
    <<~EOS
      The Attic AI requires Docker Desktop to be installed and running.

      To install and start all services:
        attic-ai-install

      To uninstall:
        attic-ai-uninstall

      Or run directly:
        cd #{prefix} && ./install.command

      After installation, open: http://localhost:3333
    EOS
  end
end
