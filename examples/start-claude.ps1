# Start Claude Code with FreeLLMAPI + LiteLLM compatibility bridge

# IMPORTANT: Before running this script, ensure that:
# 1. FreeLLMAPI is running on port 8082
# 2. LiteLLM is running on port 4000
# 3. Claude Code is installed and available in PATH

# Set environment variables for Claude Code
# These tell Claude Code to use LiteLLM as its API endpoint

# ANTHROPIC_BASE_URL: The URL of the LiteLLM gateway
# This must point to the LiteLLM server (default port 4000)
$env:ANTHROPIC_BASE_URL = "http://127.0.0.1:4000"

# ANTHROPIC_AUTH_TOKEN: Authentication token for the API
# Replace "YOUR_ANTHROPIC_AUTH_TOKEN" with your actual token
# This should match the master_key configured in litellm-config.yaml
$env:ANTHROPIC_AUTH_TOKEN = "YOUR_ANTHROPIC_AUTH_TOKEN"

# CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY: Enable model discovery from gateway
# Set to "1" to enable automatic discovery of available models from LiteLLM
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = "1"

Write-Host "Environment variables set:"
Write-Host "  ANTHROPIC_BASE_URL: $env:ANTHROPIC_BASE_URL"
Write-Host "  ANTHROPIC_AUTH_TOKEN: [REDACTED]"
Write-Host "  CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY: $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY"

# Start Claude Code
# This launches the Claude Code application
Write-Host "`nStarting Claude Code..."
$env:CLAUDE_CODE_DEBUG = "1"  # Optional: Enable debug mode
claude

Write-Host "Claude Code started with LiteLLM compatibility bridge"