# LiteLLM Configuration Guide

This comprehensive guide covers all aspects of configuring LiteLLM as the compatibility bridge between Claude Code and FreeLLMAPI.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Configuration File](#configuration-file)
4. [Complete Example Configuration](#complete-example-configuration)
5. [Configuration Parameters](#configuration-parameters)
6. [Model Mapping](#model-mapping)
7. [Parameter Filtering](#parameter-filtering)
8. [custom_openai Explanation](#custom_openai-explanation)
9. [Startup Commands](#startup-commands)
10. [Troubleshooting](#troubleshooting)

## Overview

**LiteLLM** is the compatibility bridge that:

- Translates Anthropic-format requests from Claude Code to OpenAI format
- Handles model name mapping
- Filters unsupported parameters
- Translates responses back to Anthropic format
- Manages API key routing

## Installation

### Prerequisites

- Python 3.8+
- pip

### Install LiteLLM

```powershell
# Install LiteLLM
pip install litellm

# Install with proxy support
pip install litellm[proxy]

# Verify installation
litellm --version
```

## Configuration File

### File Format

LiteLLM uses YAML format for configuration.

**Location**: `litellm-config.yaml` (in project root)

**Typical Structure**:

```
project-root/
├── litellm-config.yaml
├── .env
├── requirements.txt
└── ...
```

### Load Configuration

```powershell
# Set configuration file path
$env:LITELLM_CONFIG_PATH="litellm-config.yaml"

# Start LiteLLM with config
litellm --config litellm-config.yaml --port 4000
```

## Complete Example Configuration

### Minimal Configuration

```yaml
litellm_settings:
  drop_params: true

model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY"

general_settings:
  master_key: "YOUR_LITELLM_MASTER_KEY"
```

### Production Configuration

```yaml
# LiteLLM Settings
litellm_settings:
  # CRITICAL: Filter unsupported parameters
  drop_params: true

  # Fail if API key is invalid
  fail_on_invalid_key: true

  # Log token usage
  log_all_tokens: true

  # Request timeout
  request_timeout: 120

  # Number of retries on failure
  num_retries: 2

# Model Mapping List
model_list:
  # Claude Opus (Latest)
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
      api_key: "${LITELLM_API_KEY}"
      timeout: 120
      max_tokens: 4096

  # Claude Sonnet (Balanced)
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/gpt-4o-mini
      api_base: "http://localhost:8082"
      api_key: "${LITELLM_API_KEY}"
      timeout: 120
      max_tokens: 4096

  # Claude Haiku (Fast)
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/gpt-3.5-turbo
      api_base: "http://localhost:8082"
      api_key: "${LITELLM_API_KEY}"
      timeout: 60
      max_tokens: 2048

  # Backwards Compatibility Models
  - model_name: claude-3-opus-20240229
    litellm_params:
      model: custom_openai/gpt-4
      api_base: "http://localhost:8082"
      api_key: "${LITELLM_API_KEY}"

  - model_name: claude-3-sonnet-20240229
    litellm_params:
      model: custom_openai/gpt-4-turbo
      api_base: "http://localhost:8082"
      api_key: "${LITELLM_API_KEY}"

  - model_name: claude-3-haiku-20240307
    litellm_params:
      model: custom_openai/gpt-3.5-turbo
      api_base: "http://localhost:8082"
      api_key: "${LITELLM_API_KEY}"

# General Settings
general_settings:
  # Master API key for LiteLLM
  master_key: "${LITELLM_MASTER_KEY}"

  # Shared authentication for all models
  shared_auth: true

  # Default fallback model if requested model not found
  default_fallback: "claude-opus-4-8"

  # Custom OpenAI provider settings
  custom_openai:
    base_url: "http://localhost:8082"
    api_key: "${LITELLM_API_KEY}"
    organization: "my-org"

  # Token budget settings
  token_budget: 1000000

  # Response format
  response_format: "json"

# Routing Strategy
router:
  strategy: "least_latency" # least_latency, round_robin, random

# Caching
cache:
  type: "redis" # redis, in_memory
  ttl: 3600
  enabled: true

# Logging
logging:
  level: "INFO" # DEBUG, INFO, WARNING, ERROR
  format: "json"

# Monitoring
monitoring:
  type: "prometheus"
  enabled: true
```

## Configuration Parameters

### litellm_settings

| Parameter                 | Type | Required | Default | Description                                         |
| ------------------------- | ---- | -------- | ------- | --------------------------------------------------- |
| `drop_params`             | bool | **YES**  | false   | **CRITICAL**: Drop unsupported Anthropic parameters |
| `fail_on_invalid_key`     | bool | No       | false   | Fail if API key validation fails                    |
| `log_all_tokens`          | bool | No       | false   | Log all token usage                                 |
| `request_timeout`         | int  | No       | 600     | Request timeout in seconds                          |
| `num_retries`             | int  | No       | 2       | Number of retry attempts                            |
| `context_window_fallback` | bool | No       | false   | Auto-select smaller model if context exceeds limit  |

### model_list Parameters

Each model mapping requires:

| Parameter                   | Type   | Required | Description                     |
| --------------------------- | ------ | -------- | ------------------------------- |
| `model_name`                | string | Yes      | Claude model name (user-facing) |
| `litellm_params.model`      | string | Yes      | Backend model identifier        |
| `litellm_params.api_base`   | string | Yes      | FreeLLMAPI base URL             |
| `litellm_params.api_key`    | string | Yes      | API key for authentication      |
| `litellm_params.timeout`    | int    | No       | Model-specific timeout          |
| `litellm_params.max_tokens` | int    | No       | Maximum tokens for responses    |

### general_settings Parameters

| Parameter          | Type   | Description                                 |
| ------------------ | ------ | ------------------------------------------- |
| `master_key`       | string | Primary authentication key                  |
| `shared_auth`      | bool   | Use same auth for all models                |
| `default_fallback` | string | Model to use if requested model unavailable |
| `custom_openai`    | object | Custom OpenAI provider configuration        |

## Model Mapping

### Supported Claude Models

```yaml
model_list:
  # Current Generation (Claude 4)
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o

  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/gpt-4o-mini

  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/gpt-3.5-turbo

  # Previous Generation (Claude 3)
  - model_name: claude-3-opus-20240229
    litellm_params:
      model: custom_openai/gpt-4

  - model_name: claude-3-sonnet-20240229
    litellm_params:
      model: custom_openai/gpt-4-turbo

  - model_name: claude-3-haiku-20240307
    litellm_params:
      model: custom_openai/gpt-3.5-turbo
```

### Model Naming Convention

**Format**: `claude-{variant}-{version}`

**Examples**:

- `claude-opus-4-8` - Opus model, version 4.8
- `claude-sonnet-4-0` - Sonnet model, version 4.0
- `claude-3-5-haiku` - Haiku model, version 3.5

### Backend Model Mapping Strategy

**Claude → OpenAI Mapping**:

```
claude-opus-4-8        → gpt-4o          (most capable, slowest)
claude-sonnet-4-0      → gpt-4o-mini     (balanced)
claude-3-5-haiku       → gpt-3.5-turbo   (fast, least capable)
```

**Custom Backends**:

```yaml
- model_name: claude-opus-4-8
  litellm_params:
    model: custom_openai/neural-chat:7b # Local LM Studio
    api_base: "http://localhost:8000"
```

## Parameter Filtering

### Why drop_params Exists

Claude Code sends **Anthropic-specific parameters** that OpenAI-style APIs don't understand:

**Example Anthropic Parameters**:

- `temperature` (different scale)
- `top_k` (not in OpenAI)
- `top_p` (mapped differently)
- `max_tokens_to_sample` (Claude-specific)
- Model-specific parameters

**With `drop_params: true`**:

```
Claude Code Request:
{
  "model": "claude-opus-4-8",
  "messages": [...],
  "temperature": 0.8,
  "top_k": 40,
  "max_tokens_to_sample": 2000
}

LiteLLM Translation:
{
  "model": "gpt-4o",
  "messages": [...],
  "temperature": 0.8,
  "max_tokens": 2000
  // top_k and other unsupported params dropped
}
```

### Supported Parameters (After Filtering)

Parameters that survive the `drop_params` filter:

- `messages`
- `temperature`
- `top_p`
- `max_tokens`
- `system` (or `system_prompt`)
- `stop_sequences`

### Parameter Mapping

LiteLLM automatically maps parameters:

| Claude Parameter       | OpenAI Parameter | Notes                |
| ---------------------- | ---------------- | -------------------- |
| `max_tokens_to_sample` | `max_tokens`     | Renamed and adjusted |
| `temperature`          | `temperature`    | Preserved            |
| `top_p`                | `top_p`          | Preserved            |
| `top_k`                | ❌ Dropped       | No OpenAI equivalent |
| `system_prompt`        | `system`         | Format change        |

## custom_openai Explanation

### What is custom_openai?

`custom_openai` is a LiteLLM **provider plugin** that enables communication with **any OpenAI-compatible API**.

### Purpose

```yaml
custom_openai:
  base_url: "http://localhost:8082" # FreeLLMAPI endpoint
  api_key: "YOUR_FREELLMAPI_API_KEY" # Authentication token
```

This tells LiteLLM:

1. **Where to send requests**: `http://localhost:8082` (FreeLLMAPI)
2. **How to authenticate**: Using API key `YOUR_FREELLMAPI_API_KEY`
3. **How to communicate**: OpenAI-compatible format

### How It Works in the Flow

```
Claude Code
    ↓
LiteLLM (receives Anthropic format)
    ↓
custom_openai plugin
    ↓
Translates to OpenAI format
    ↓
Sends to FreeLLMAPI (http://localhost:8082)
    ↓
FreeLLMAPI routes to backend provider
    ↓
Response flows back through custom_openai
    ↓
Translated back to Anthropic format
    ↓
Claude Code
```

### Configuration Example

```yaml
general_settings:
  custom_openai:
    # Required: Base URL of FreeLLMAPI
    base_url: "http://localhost:8082"

    # Required: API key for authentication
    api_key: "YOUR_FREELLMAPI_API_KEY"

    # Optional: Organization ID (if multi-tenant)
    organization: "my-org"

    # Optional: API version
    api_version: "v1"

    # Optional: Custom headers
    headers:
      X-Custom-Header: "value"
```

### Using Environment Variables

```yaml
general_settings:
  custom_openai:
    base_url: "${FREELLMAPI_BASE_URL}"
    api_key: "${FREELLMAPI_API_KEY}"
```

Set in PowerShell:

```powershell
$env:FREELLMAPI_BASE_URL="http://localhost:8082"
$env:FREELLMAPI_API_KEY="YOUR_FREELLMAPI_API_KEY"
```

## Startup Commands

### Basic Startup

```powershell
# Start LiteLLM with config
litellm --config litellm-config.yaml --port 4000

# With verbose logging
litellm --config litellm-config.yaml --port 4000 --verbose

# With debug mode
litellm --config litellm-config.yaml --port 4000 --debug
```

### PowerShell Script Startup

```powershell
# Set environment variables
$env:LITELLM_MASTER_KEY="YOUR_LITELLM_MASTER_KEY"
$env:LITELLM_LOG_LEVEL="INFO"

# Start LiteLLM process
$process = Start-Process -FilePath "python" `
  -ArgumentList "-m", "litellm.proxy.server", `
    "--config", "litellm-config.yaml", `
    "--port", "4000" `
  -RedirectStandardOutput "litellm.log" `
  -PassThru

Write-Host "LiteLLM started with PID: $($process.Id)"
```

### Complete Setup Script

```powershell
# Set up environment
$env:LITELLM_MASTER_KEY="YOUR_LITELLM_MASTER_KEY"
$env:LITELLM_LOG_LEVEL="INFO"

# Create configuration
@"
litellm_settings:
  drop_params: true

model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY"

general_settings:
  master_key: "YOUR_LITELLM_MASTER_KEY"
"@ | Out-File -FilePath "litellm-config.yaml" -Encoding UTF8

# Start server
litellm --config litellm-config.yaml --port 4000 --verbose
```

### Verify Server is Running

```powershell
# Test LiteLLM health
Invoke-WebRequest http://localhost:4000/health

# List available models
Invoke-WebRequest http://localhost:4000/models
```

## Troubleshooting

### Configuration Errors

**Error**: `Error loading configuration: invalid YAML syntax`

**Solution**:

1. Check indentation (2 spaces, not tabs)
2. Verify all quotes are properly closed
3. Use online YAML validator: https://www.yamllint.com/
4. Check for special characters

**Example Fix**:

```yaml
# ❌ Wrong (tab indentation)
litellm_settings:
	drop_params: true

# ✅ Correct (2-space indentation)
litellm_settings:
  drop_params: true
```

### Model Not Found

**Error**: `Model 'claude-opus-4-8' not found in model list`

**Solution**:

1. Verify model name exactly matches `model_list` entry
2. Check configuration file is loaded: `--config litellm-config.yaml`
3. Restart LiteLLM after config changes
4. Check for typos in model names

### API Key Errors

**Error**: `Authentication failed - invalid API key`

**Solution**:

1. Verify API key in environment variables: `echo $env:LITELLM_MASTER_KEY`
2. Check FreeLLMAPI is running: `curl http://localhost:8082/health`
3. Verify API key matches FreeLLMAPI configuration
4. Check for whitespace in keys

### Connection Refused

**Error**: `Cannot connect to http://localhost:8082`

**Solution**:

1. Start FreeLLMAPI first: `fcc-server --config .fcc_env`
2. Verify FreeLLMAPI is running: `curl http://localhost:8082/health`
3. Check port number matches configuration (8082)
4. Check firewall allows local connections

### Parameter Errors

**Error**: `Unsupported parameter: top_k`

**Verify `drop_params` setting**:

```yaml
litellm_settings:
  drop_params: true # This must be true
```

If enabled and error persists:

1. Check Claude Code isn't sending invalid parameters
2. Review logs for parameter details
3. Manually filter in custom code if needed

### Timeout Errors

**Error**: `Request timed out after 120 seconds`

**Solution**:

1. Increase `request_timeout` in settings
2. Check FreeLLMAPI performance
3. Verify backend provider is responding
4. Check network latency

### Debug Mode

**Enable detailed logging**:

```powershell
litellm --config litellm-config.yaml --port 4000 --debug --verbose
```

This shows:

- All incoming requests
- Parameter mapping details
- Model selection logic
- Response times
- Error details

## Next Steps

1. **Create Configuration**: Copy example config and customize
2. **Set Environment Variables**: Configure API keys
3. **Start Services**: Start FreeLLMAPI first, then LiteLLM
4. **Test Connectivity**: Verify models are accessible
5. **Configure Claude Code**: Set ANTHROPIC_BASE_URL to LiteLLM endpoint

## Related Documentation

- [CONFIGURATION.md](CONFIGURATION.md) - Overall configuration guide
- [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md) - FreeLLMAPI configuration
- [CLAUDE_CODE_CONFIG.md](CLAUDE_CODE_CONFIG.md) - Claude Code setup
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

---

**Last Updated**: 2026
**Version**: 1.0
