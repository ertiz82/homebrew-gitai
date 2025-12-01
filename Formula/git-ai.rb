class GitAi < Formula
  desc "AI-powered Git commit grouping and message generation"
  homepage "https://github.com/ertiz82/git-ai"
  url "https://github.com/ertiz82/git-ai/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "478ae902149bd507cdd23da5e0c6ee6f88e2a31413340045b7467b0d74c408c6"
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
      To use git-ai, you need to set your API key:
        export CLOUD_AI_API_KEY="your-api-key"

      Or create a jira.local.json in your project root.
      See: #{libexec}/jira.local.example.json
    EOS
  end

  test do
    assert_match "git-ai", shell_output("#{bin}/git-ai version")
  end
end