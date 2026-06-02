# Configuration Guide

This comprehensive guide covers all configuration aspects of the Claude Code with FreeLLMAPI + LiteLLM compatibility bridge system.

## Table of Contents

1. [Overview](#overview)
2. [FreeLLMAPI Configuration](#freellmapi-configuration)
3. [LiteLLM Configuration](#litellm-configuration)
4. [Claude Code Configuration](#claude-code-configuration)
5. [Environment Variables](#environment-variables)
6. [Examples](#examples)

## Overview

The system consists of three main components, each with their own configuration requirements:

- **FreeLLMAPI**: Provides the OpenAI-style API gateway
- **LiteLLM**: Translates requests between Claude Code and FreeLLMAPI formats
- **Claude Code**: The user-facing application that consumes the API

## FreeLLMAPI Configuration

### Configuration File

FreeLLMAPI uses a YAML configuration file to specify the provider pool and settings.

**Location**: `.fcc_env` or environment variables

### Key Configuration Options

```yaml
provider_pool:
  - name: local_model
    base_url: "http://localhost:5000"
    provider_type: "local"
  - name: remote_model
    base_url: "https://api.example.com"
    provider_type: "remote"

settings:
  port: 8082
  debug: true
  health_check_interval: 30
  timeout: 60
```

### Configuration Details

| Option                  | Description                            | Default |
| ----------------------- | -------------------------------------- | ------- |
| `port`                  | Port number for FreeLLMAPI server      | 8082    |
| `debug`                 | Enable debug logging                   | false   |
| `health_check_interval` | Seconds between provider health checks | 30      |
| `timeout`               | Request timeout in seconds             | 60      |

### Provider Pool Setup

Each provider in the pool can be:

1. **Local Models** (LM Studio, Ollama, etc.)

   ```yaml
   - name: local_llm
     base_url: "http://localhost:8000"
     provider_type: "local"
   ```

2. **Remote APIs** (OpenAI, Anthropic, etc.)
   ```yaml
   - name: remote_api
     base_url: "https://api.openai.com/v1"
     api_key: "${OPENAI_API_KEY}"
     provider_type: "remote"
   ```

### Startup Command

```powershell
# Windows
fcc-server --config .fcc_env

# Linux/macOS
fcc-server --config .fcc_env
```

## LiteLLM Configuration

### Configuration File

LiteLLM uses a YAML configuration file (`litellm-config.yaml`) to map Claude-style models to backend models.

### Complete Example Configuration

```yaml
litellm_settings:
  drop_params: true
  fail_on_invalid_key: false

model_list:
  # Claude Opus Model
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY"

  # Claude Sonnet Model
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/gpt-4o-mini
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY"

  # Claude Haiku Model
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/gpt-3.5-turbo
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY"

general_settings:
  master_key: "YOUR_LITELLM_MASTER_KEY"
  custom_openai:
    base_url: "http://localhost:8082"
    api_key: "YOUR_FREELLMAPI_API_KEY"
```

### Key Configuration Parameters

#### `drop_params: true`

This is a **critical** parameter that filters out unsupported parameters from Claude Code requests before they reach FreeLLMAPI.

**Why it's important**:

- Claude Code sends Anthropic-specific parameters that OpenAI-style APIs don't understand
- Setting `drop_params: true` prevents errors from unknown parameters
- Ensures seamless compatibility between Claude Code and OpenAI-style APIs

**Example of filtered parameters**:

- `top_k`
- `temperature` (may need adjustment)
- Anthropic-specific parameters

#### Model Mapping

Each model mapping consists of:

| Field                      | Description                                         |
| -------------------------- | --------------------------------------------------- |
| `model_name`               | Claude-style model name (what Claude Code requests) |
| `model: custom_openai/...` | The actual backend model being used                 |
| `api_base`                 | FreeLLMAPI endpoint URL                             |
| `api_key`                  | Authentication token                                |

#### `custom_openai` Explanation

The `custom_openai` provider allows LiteLLM to communicate with any OpenAI-compatible API:

```yaml
custom_openai:
  base_url: "http://localhost:8082" # FreeLLMAPI endpoint
  api_key: "YOUR_FREELLMAPI_API_KEY" # Authentication key
```

This acts as a bridge between Claude Code's Anthropic format and FreeLLMAPI's OpenAI format.

### Configuration Options

| Option                | Type    | Description                   | Required |
| --------------------- | ------- | ----------------------------- | -------- |
| `drop_params`         | boolean | Filter unsupported parameters | Yes      |
| `fail_on_invalid_key` | boolean | Fail if API key is invalid    | No       |
| `master_key`          | string  | Master authentication key     | Yes      |
| `base_url`            | string  | Custom OpenAI base URL        | Yes      |
| `api_key`             | string  | API key for authentication    | Yes      |

## Claude Code Configuration

### Environment Variables

Claude Code requires specific environment variables to connect to the LiteLLM gateway:

#### PowerShell Setup

```powershell
# Set environment variables for Claude Code
$env:ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
$env:ANTHROPIC_AUTH_TOKEN="YOUR_TOKEN"
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

# Verify settings
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_AUTH_TOKEN
```

#### Variable Explanations

| Variable                                     | Description                         | Example                     |
| -------------------------------------------- | ----------------------------------- | --------------------------- |
| `ANTHROPIC_BASE_URL`                         | URL of LiteLLM server               | `http://127.0.0.1:4000`     |
| `ANTHROPIC_AUTH_TOKEN`                       | Authentication token for API access | `YOUR_ANTHROPIC_AUTH_TOKEN` |
| `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` | Enable model discovery from gateway | `1`                         |

#### Permanent Setup (Windows)

To make these settings permanent, add to system environment variables:

1. Open **System Properties** (Win+Pause/Break)
2. Click **Environment Variables**
3. Under **User variables**, click **New**
4. Add each variable:
   - Variable name: `ANTHROPIC_BASE_URL`
   - Variable value: `http://127.0.0.1:4000`

### YAML Configuration (Alternative)

Some Claude Code installations may use a YAML configuration file:

```yaml
api:
  base_url: "http://127.0.0.1:4000"
  auth_token: "YOUR_TOKEN"
  enable_gateway_discovery: true

settings:
  debug: false
  timeout: 300
```

## Environment Variables

### Complete Environment Setup

```powershell
# FreeLLMAPI
$env:FCC_PORT="8082"
$env:FCC_DEBUG="true"
$env:PROVIDER_POOL_URL="http://localhost:5000"

# LiteLLM
$env:LITELLM_MASTER_KEY="YOUR_LITELLM_MASTER_KEY"
$env:LITELLM_CONFIG="litellm-config.yaml"
$env:LITELLM_LOG_LEVEL="INFO"

# Claude Code
$env:ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
$env:ANTHROPIC_AUTH_TOKEN="YOUR_TOKEN"
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

# API Keys
$env:OPENAI_API_KEY="YOUR_OPENAI_API_KEY"
$env:NVIDIA_NIM_API_KEY="xxxx"
```

### Environment File (.env)

Create a `.env` file in the project root:

```bash
# FreeLLMAPI Configuration
FCC_PORT=8082
FCC_DEBUG=true

# LiteLLM Configuration
LITELLM_MASTER_KEY=YOUR_LITELLM_MASTER_KEY
LITELLM_LOG_LEVEL=INFO

# Claude Code Configuration
ANTHROPIC_BASE_URL=http://127.0.0.1:4000
ANTHROPIC_AUTH_TOKEN=YOUR_TOKEN
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1

# API Keys (if using remote providers)
OPENAI_API_KEY=YOUR_OPENAI_API_KEY
NVIDIA_NIM_API_KEY=xxxx
```

**Important**: Add `.env` to `.gitignore` to prevent committing sensitive keys.

## Examples

### Example 1: Basic Local Setup

**FreeLLMAPI Configuration**:

```yaml
provider_pool:
  - name: ollama_local
    base_url: "http://localhost:11434"

settings:
  port: 8082
  debug: true
```

**LiteLLM Configuration**:

```yaml
model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/neural-chat:latest
      api_base: "http://localhost:8082"
```

### Example 2: Multi-Provider Setup

**FreeLLMAPI Configuration**:

```yaml
provider_pool:
  - name: openai
    base_url: "https://api.openai.com/v1"
    api_key: "${OPENAI_API_KEY}"
  - name: local_ollama
    base_url: "http://localhost:11434"
  - name: nvidia_nim
    base_url: "http://localhost:8000"
    api_key: "${NVIDIA_NIM_API_KEY}"

settings:
  port: 8082
  load_balancing: "round_robin"
```

### Example 3: Production Setup

**LiteLLM Configuration**:

```yaml
litellm_settings:
  drop_params: true
  fail_on_invalid_key: true

model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4
      api_base: "http://freellmapi.internal:8082"
      api_key: "${LITELLM_API_KEY}"
      timeout: 120
```

## Troubleshooting Configuration Issues

### Common Problems

**1. Port Already in Use**

```powershell
# Find process using port 8082
netstat -ano | findstr :8082

# Kill process
taskkill /PID <PID> /F
```

**2. Invalid YAML Syntax**

- Ensure proper indentation (2 spaces, not tabs)
- Use quotes for strings with special characters
- Validate with online YAML validators

**3. API Key Errors**

- Verify keys are set in environment variables
- Check that keys are not expired
- Ensure keys have appropriate permissions

**4. Connection Refused**

- Verify all services are running
- Check port configurations match
- Verify firewall settings

For additional help, refer to the [Troubleshooting Guide](TROUBLESHOOTING.md).
