# Examples Guide

This document provides examples of configurations and usage.

## LiteLLM Configuration

```yaml
litellm_settings:
  drop_params: true

model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/claude-opus-4-8
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/claude-sonnet-4-0
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/claude-3-5-haiku

general_settings:
  master_key: YOUR_LITELLM_MASTER_KEY # Placeholder - replace with your actual key
  custom_openai:
    base_url: "http://localhost:8082"
```

## Startup Scripts

### start-freellmapi.ps1

```powershell
# Start FreeLLMAPI server
Start-Process -FilePath "fcc-server" -ArgumentList "--port 8082"
```

### start-litellm.ps1

```powershell
# Start LiteLLM server
Start-Process -FilePath "litellm" -ArgumentList "--config litellm-config.yaml"
```

### start-claude.ps1

```powershell
# Set environment variables (example placeholders)
$env:ANTHROPIC_AUTH_TOKEN = "YOUR_ANTHROPIC_AUTH_TOKEN"
$env:ANTHROPIC_BASE_URL = "http://127.0.0.1:4000"  # LiteLLM default endpoint

# Start Claude Code (use the `claude` CLI or the provided script)
# Recommended: run the helper script: .\examples\start-claude.ps1
```

### combined-startup.ps1

```powershell
# Start FreeLLMAPI server (run from FreeLLMAPI repo or use system install)
Start-Process -FilePath "pwsh" -ArgumentList "-File", ".\examples\start-freellmapi.ps1"

# Start LiteLLM server
Start-Process -FilePath "pwsh" -ArgumentList "-File", ".\examples\start-litellm.ps1"

# Set Claude environment variables (example placeholders)
$env:ANTHROPIC_AUTH_TOKEN = "YOUR_ANTHROPIC_AUTH_TOKEN"
$env:ANTHROPIC_BASE_URL = "http://127.0.0.1:4000"

# Start Claude Code via helper script
Start-Process -FilePath "pwsh" -ArgumentList "-File", ".\examples\start-claude.ps1"
```

For more details, see the [Examples Guide](EXAMPLES.md).
