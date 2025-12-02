class GitAi < Formula
  desc "AI-powered Git commit grouping and message generation"
  homepage "https://github.com/ertiz82/git-ai"
  url "https://github.com/ertiz82/git-ai/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "8d4bf88839770ccca9f835c708ae8743b8039e241042fb1ee4dca2107f6ec65c"
  license "MIT"

  depends_on "node"

  def install
    # Node backend
    cd "node-backend" do
      system "npm", "install", "--production"
      libexec.install Dir["*"]
    end

    # Executable wrapper
    (bin/"git-ai").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/cli.js" "$@"
    EOS
    chmod 0755, bin/"git-ai"
  end

  def caveats
    <<~EOS
      Quick Start:
        cd your-project
        git-ai init              # Interactive setup (recommended)
        git-ai commit --dry-run  # Preview commits
        git-ai commit            # Execute commits

      Supported AI Providers:
        - Ollama (Free, Local)
        - Google Gemini
        - OpenAI (GPT)
        - Anthropic (Claude)

      Docs: https://github.com/ertiz82/git-ai
    EOS
  end

  test do
    # Basic version test
    output = shell_output("#{bin}/git-ai version")
    assert_match "git-ai", output
  end
end

