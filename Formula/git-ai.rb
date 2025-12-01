class GitAi < Formula
  desc "AI-powered Git commit grouping and message generation"
  homepage "https://github.com/ertiz82/git-ai"
  url "https://github.com/ertiz82/git-ai/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9b2894180af84209cb97804fedf0cf4882fac8cca2803f6ba613d4199b6511bc"
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