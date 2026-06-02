# Start LiteLLM server
# LiteLLM acts as a compatibility bridge between Claude Code and FreeLLMAPI

# ============================================================================
# What is LiteLLM?
# ============================================================================
# LiteLLM is a gateway that:
# - Translates Anthropic-format requests from Claude Code to OpenAI format
# - Maps Claude model names to backend models
# - Filters unsupported parameters
# - Routes requests to FreeLLMAPI

# ============================================================================
# Prerequisites
# ============================================================================
# 1. LiteLLM must be installed: pip install litellm
# 2. litellm-config.yaml must exist in the project root
# 3. FreeLLMAPI must be running on port 8082

# Configuration file location
# The litellm-config.yaml file contains:
# - Model mappings (e.g., claude-opus-4-8 -> gpt-4o)
# - Provider settings (FreeLLMAPI URL, authentication)
# - Parameter filtering rules (drop_params: true)

# Update this path if your configuration file is in a different location
$config_path = "litellm-config.yaml"

if (-not (Test-Path $config_path)) {
    Write-Host "ERROR: Configuration file not found: $config_path"
    Write-Host "Please create litellm-config.yaml in the project root"
    Write-Host "Refer to the LITELLM_CONFIG.md guide for configuration details"
    Exit 1
}

Write-Host "Starting LiteLLM..."
Write-Host "Configuration file: $config_path"
Write-Host "Expected endpoint: http://localhost:4000"
Write-Host "`nIMPORTANT: Ensure FreeLLMAPI is running on port 8082 before this starts"

# Start LiteLLM with the configuration file
# --port 4000: LiteLLM listens on port 4000 (used by Claude Code)
# --config: Path to the LiteLLM configuration file
litellm --config $config_path --port 4000 --verbose

Write-Host "`nLiteLLM started on port 4000"
Write-Host "Health check: curl http://localhost:4000/health"
Write-Host "List models: curl http://localhost:4000/models"