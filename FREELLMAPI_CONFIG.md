# FreeLLMAPI Configuration Guide

This comprehensive guide covers all aspects of configuring FreeLLMAPI for the Claude Code compatibility bridge.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Configuration File](#configuration-file)
4. [Configuration Options](#configuration-options)
5. [Provider Pool Setup](#provider-pool-setup)
6. [Environment Variables](#environment-variables)
7. [Startup Commands](#startup-commands)
8. [Troubleshooting](#troubleshooting)

## Overview

**FreeLLMAPI** is the OpenAI-style API gateway that:

- Receives requests from LiteLLM
- Routes requests to appropriate providers in the pool
- Manages provider health and availability
- Returns standardized responses

## Installation

### Prerequisites

- Node.js 16+
- npm or yarn

### Install FreeLLMAPI

```powershell
# Install globally (recommended)
npm install -g freellmapi

# Or install locally in your project
npm install freellmapi
```

### Verify Installation

```powershell
fcc-server --version
# Should output: FreeLLMAPI version X.X.X
```

## Configuration File

### File Format

FreeLLMAPI uses YAML format for configuration.

**Location**: `.fcc_env` or specified with `--config` parameter

### Minimal Configuration

```yaml
provider_pool:
  - name: local_model
    base_url: "http://localhost:5000"

settings:
  port: 8082
```

### Complete Configuration Example

```yaml
# Provider Pool Configuration
provider_pool:
  # Local LM Studio
  - name: lm_studio
    base_url: "http://localhost:8000"
    provider_type: "local"
    timeout: 60
    retry_count: 3

  # Local Ollama
  - name: ollama
    base_url: "http://localhost:11434"
    provider_type: "local"
    timeout: 60

  # Remote OpenAI API
  - name: openai
    base_url: "https://api.openai.com/v1"
    api_key: "${OPENAI_API_KEY}"
    provider_type: "remote"
    timeout: 120

  # Remote NVIDIA NIM
  - name: nvidia_nim
    base_url: "http://localhost:8000"
    api_key: "${NVIDIA_NIM_API_KEY}"
    provider_type: "remote"
    timeout: 120

# Server Settings
settings:
  port: 8082
  debug: true
  log_level: "INFO"
  health_check_interval: 30
  timeout: 60
  cors_enabled: true
  max_connections: 100
  request_queue_size: 1000

# Load Balancing
load_balancing:
  strategy: "round_robin" # round_robin, random, least_loaded, weighted
  weights:
    lm_studio: 1.0
    ollama: 0.8
    openai: 1.2

# Authentication
auth:
  enabled: true
  api_key: "${FCC_API_KEY}"
  bearer_token: "${FCC_BEARER_TOKEN}"

# Logging
logging:
  level: "INFO"
  format: "json"
  file: "freellmapi.log"
  max_size: "10MB"
  max_age: "30d"
  rotate: true
```

## Configuration Options

### Server Settings

| Option                  | Type    | Default | Description                              |
| ----------------------- | ------- | ------- | ---------------------------------------- |
| `port`                  | integer | 8082    | Port number for FreeLLMAPI server        |
| `debug`                 | boolean | false   | Enable debug mode and verbose logging    |
| `log_level`             | string  | INFO    | Logging level (DEBUG, INFO, WARN, ERROR) |
| `health_check_interval` | integer | 30      | Seconds between provider health checks   |
| `timeout`               | integer | 60      | Default request timeout in seconds       |
| `cors_enabled`          | boolean | true    | Enable CORS for cross-origin requests    |
| `max_connections`       | integer | 100     | Maximum concurrent connections           |
| `request_queue_size`    | integer | 1000    | Maximum pending requests in queue        |

### Provider Configuration

Each provider in the pool supports:

| Option          | Type    | Required | Description                        |
| --------------- | ------- | -------- | ---------------------------------- |
| `name`          | string  | Yes      | Unique identifier for the provider |
| `base_url`      | string  | Yes      | Base URL of the provider API       |
| `provider_type` | string  | No       | Type: "local" or "remote"          |
| `api_key`       | string  | No       | API key for remote providers       |
| `timeout`       | integer | No       | Provider-specific timeout          |
| `retry_count`   | integer | No       | Number of retry attempts           |
| `enabled`       | boolean | No       | Enable/disable provider            |

### Load Balancing Strategies

1. **round_robin**: Distribute requests evenly across providers
2. **random**: Random provider selection
3. **least_loaded**: Send to provider with fewest active requests
4. **weighted**: Use specified weights for distribution

## Provider Pool Setup

### Local Providers

#### LM Studio

```yaml
provider_pool:
  - name: lm_studio
    base_url: "http://localhost:8000"
    provider_type: "local"
    timeout: 60
```

**Requirements**:

- LM Studio running on `localhost:8000`
- Model loaded in LM Studio

**Health Check**:

```powershell
Invoke-WebRequest http://localhost:8000/health
```

#### Ollama

```yaml
provider_pool:
  - name: ollama
    base_url: "http://localhost:11434"
    provider_type: "local"
    timeout: 60
```

**Requirements**:

- Ollama service running on `localhost:11434`
- Model pulled: `ollama pull <model-name>`

**Health Check**:

```powershell
Invoke-WebRequest http://localhost:11434/api/tags
```

### Remote Providers

#### OpenAI

```yaml
provider_pool:
  - name: openai
    base_url: "https://api.openai.com/v1"
    api_key: "${OPENAI_API_KEY}"
    provider_type: "remote"
```

**Setup**:

1. Get API key from openai.com
2. Set environment variable: `$env:OPENAI_API_KEY="YOUR_OPENAI_API_KEY"`
3. Ensure sufficient API credits

#### NVIDIA NIM

```yaml
provider_pool:
  - name: nvidia_nim
    base_url: "http://localhost:8000"
    api_key: "${NVIDIA_NIM_API_KEY}"
    provider_type: "remote"
```

**Setup**:

1. Deploy NVIDIA NIM container
2. Configure API key in environment

## Environment Variables

### Required Variables

```powershell
# FreeLLMAPI Port
$env:FCC_PORT="8082"

# API Key for FreeLLMAPI
$env:FCC_API_KEY="YOUR_FREELLMAPI_API_KEY"

# Log Level
$env:FCC_LOG_LEVEL="INFO"
```

### Provider API Keys

```powershell
# OpenAI

$env:OPENAI_API_KEY="YOUR_OPENAI_API_KEY"

# NVIDIA NIM
$env:NVIDIA_NIM_API_KEY="nvapi-xxxx"

# Other Providers
$env:PROVIDER_API_KEY="xxxx"
```

### Configuration via Environment

You can override `.fcc_env` settings with environment variables:

```powershell
# Override port
$env:FCC_PORT="9000"

# Override log level
$env:FCC_LOG_LEVEL="DEBUG"

# Override provider base URL
$env:PROVIDER_POOL_URL="http://custom:5000"
```

## Startup Commands

### Basic Startup

```powershell
# Using default configuration
fcc-server

# Using custom configuration file
fcc-server --config .fcc_env

# With specific port
fcc-server --port 8082

# With debug mode
fcc-server --debug
```

### PowerShell Script Startup

```powershell
# Start with output logging
$process = Start-Process -FilePath "fcc-server" `
  -ArgumentList "--config", ".fcc_env" `
  -RedirectStandardOutput "fcc-server.log" `
  -PassThru

Write-Host "FreeLLMAPI started with PID: $($process.Id)"
```

### Complete Example

```powershell
# Set up environment
$env:FCC_PORT="8082"
$env:FCC_LOG_LEVEL="INFO"
$env:OPENAI_API_KEY="YOUR_OPENAI_API_KEY"

# Create configuration file
@"
provider_pool:
  - name: lm_studio
    base_url: http://localhost:8000
  - name: openai
    base_url: https://api.openai.com/v1
    api_key: `${OPENAI_API_KEY}

settings:
  port: 8082
  debug: true
"@ | Out-File -FilePath ".fcc_env" -Encoding UTF8

# Start server
fcc-server --config .fcc_env
```

### Verify Server is Running

```powershell
# Check health endpoint
Invoke-WebRequest http://localhost:8082/health

# Expected response:
# { "status": "ok", "timestamp": "2026-01-01T00:00:00Z" }
```

## Health Monitoring

### Health Check Endpoints

```powershell
# Server health
curl http://localhost:8082/health

# Provider status
curl http://localhost:8082/providers

# Models available
curl http://localhost:8082/models
```

### Automatic Health Checks

FreeLLMAPI automatically checks provider health at intervals:

```yaml
settings:
  health_check_interval: 30 # Check every 30 seconds
```

Unhealthy providers are:

- Automatically marked as unavailable
- Excluded from request routing
- Periodically re-checked for recovery

## Troubleshooting

### Port Already in Use

**Error**: `Error: Port 8082 is already in use`

**Solution**:

```powershell
# Find process using port 8082
$process = Get-NetTCPConnection -LocalPort 8082 |
  Select-Object -ExpandProperty OwningProcess

# Stop the process
Stop-Process -Id $process -Force

# Or use different port
fcc-server --port 9000
```

### Provider Connection Failed

**Error**: `Cannot connect to provider at http://localhost:8000`

**Solution**:

1. Verify provider is running: `curl http://localhost:8000/health`
2. Check port number matches configuration
3. Verify firewall allows connection
4. Check API keys are set correctly

### Configuration Errors

**Error**: `Invalid YAML in configuration file`

**Solution**:

1. Check indentation (must be 2 spaces, not tabs)
2. Verify all required fields are present
3. Use online YAML validator
4. Check for special characters that need quoting

### High Memory Usage

**Issue**: FreeLLMAPI consuming excessive memory

**Solution**:

1. Reduce `max_connections` in settings
2. Reduce `request_queue_size`
3. Check for stuck requests
4. Monitor provider responses for hangs

### Slow Response Times

**Issue**: Requests taking too long to process

**Solution**:

1. Check provider health: `curl http://localhost:8082/providers`
2. Increase `timeout` values
3. Check load balancing strategy
4. Monitor system resources (CPU, memory, disk)

### Debug Mode

**Enable detailed logging**:

```powershell
fcc-server --debug --log-level DEBUG
```

This will show:

- All incoming requests
- Provider routing decisions
- Response times
- Error details

## Next Steps

1. **Configure Providers**: Add all providers to your pool
2. **Test Connectivity**: Verify each provider responds
3. **Configure LiteLLM**: Set up model mappings (see [LITELLM_CONFIG.md](LITELLM_CONFIG.md))
4. **Test Integration**: Run validation tests

## Related Documentation

- [CONFIGURATION.md](CONFIGURATION.md) - Overall configuration guide
- [LITELLM_CONFIG.md](LITELLM_CONFIG.md) - LiteLLM configuration
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions

---

**Last Updated**: 2026
**Version**: 1.0
