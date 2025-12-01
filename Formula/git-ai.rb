class GitAi < Formula
  desc "AI-powered Git commit grouping and message generation"
  homepage "https://github.com/ertiz82/git-ai"
  url "https://github.com/ertiz82/git-ai/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "43cba407f7abecbd6230697cbed9eafd2aa0d6a27568f7d2f26bc9d06d1d303d"
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
      Configure your AI provider:

      # Option 1: Ollama (Free, Local)
      export AI_PROVIDER=ollama
      export CLOUD_AI_MODEL=gemma3:4b
      ollama pull gemma3:4b

      # Option 2: Anthropic
      export AI_PROVIDER=anthropic
      export CLOUD_AI_API_KEY="your-api-key"

      # Option 3: OpenAI
      export AI_PROVIDER=openai
      export CLOUD_AI_API_KEY="your-api-key"

      Or add jira.local.json to your project root:
      {"cloud":{"provider":"ollama","model":"gemma3:4b"}}

      Usage:
        git-ai commit --dry-run  # Preview
        git-ai commit            # Execute

      Docs: https://github.com/ertiz82/git-ai
    EOS
  end

  test do
    # Basic version test
    output = shell_output("#{bin}/git-ai version")
    assert_match "git-ai", output
  end
end

