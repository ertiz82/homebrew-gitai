class GitAi < Formula
  desc "AI-powered Git commit grouping and message generation"
  homepage "https://github.com/ertiz82/git-ai"
  url "https://github.com/ertiz82/git-ai/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b0f0d94a49c90822eff171cc1b98578a85f26a94a4747944be7fefb799b86e30"
  license "MIT"

  depends_on "node"

  def install
    cd "node-backend" do
      system "npm", "install", "--production"
      libexec.install Dir["*"]
    end

    # Create executable wrapper
    (bin/"git-ai").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/cli.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Configure your AI provider:

      # Option 1: Ollama (Free, Local)
      export AI_PROVIDER=ollama
      ollama pull llama3.2

      # Option 2: Anthropic
      export AI_PROVIDER=anthropic
      export CLOUD_AI_API_KEY="your-api-key"

      # Option 3: OpenAI
      export AI_PROVIDER=openai
      export CLOUD_AI_API_KEY="your-api-key"

      Usage:
        git-ai commit --dry-run  # Preview
        git-ai commit            # Execute

      Docs: https://github.com/ertiz82/git-ai
    EOS
  end

  test do
    assert_match "git-ai", shell_output("#{bin}/git-ai version")
  end
end