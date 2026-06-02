# Claude Code Configuration Guide

This comprehensive guide covers all aspects of configuring Claude Code to work with the LiteLLM compatibility bridge.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Environment Variable Setup](#environment-variable-setup)
4. [PowerShell Configuration](#powershell-configuration)
5. [Permanent Setup (Windows)](#permanent-setup-windows)
6. [YAML Configuration (Alternative)](#yaml-configuration-alternative)
7. [Verification](#verification)
8. [Troubleshooting](#troubleshooting)

## Overview

**Claude Code** is the user-facing application that:

- Sends requests to the LiteLLM compatibility bridge
- Displays responses to the user
- Manages session state and history
- Handles model selection

For Claude Code to work with FreeLLMAPI and LiteLLM, you must:

1. Set the correct API endpoint (LiteLLM)
2. Provide authentication token
3. Enable gateway model discovery

## Prerequisites

Before configuring Claude Code, ensure:

1. **FreeLLMAPI is running**: `fcc-server --config .fcc_env`
2. **LiteLLM is running**: `litellm --config litellm-config.yaml --port 4000`
3. **Both services are healthy**: Check health endpoints

### Verify Services

```powershell
# Check FreeLLMAPI
Invoke-WebRequest http://localhost:8082/health
# Expected: {"status": "ok"}

# Check LiteLLM
Invoke-WebRequest http://localhost:4000/health
# Expected: 200 OK
```

## Environment Variable Setup

### Required Environment Variables

Claude Code requires three key environment variables:

| Variable                                     | Value                   | Description            |
| -------------------------------------------- | ----------------------- | ---------------------- |
| `ANTHROPIC_BASE_URL`                         | `http://127.0.0.1:4000` | LiteLLM endpoint       |
| `ANTHROPIC_AUTH_TOKEN`                       | Your API token          | Authentication         |
| `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` | `1`                     | Enable model discovery |

### PowerShell Configuration

#### Method 1: Set for Current Session

```powershell
# Set environment variables for current PowerShell session
$env:ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
$env:ANTHROPIC_AUTH_TOKEN="YOUR_ANTHROPIC_AUTH_TOKEN"
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

# Verify variables are set
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_AUTH_TOKEN
echo $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY
```

**Important**: These settings only persist for the current PowerShell session. They're lost when you close the terminal.

#### Method 2: Create Setup Script

Create a file `setup-claude-code.ps1`:

```powershell
# setup-claude-code.ps1

# Set environment variables for Claude Code
Write-Host "Setting up Claude Code environment variables..."

$env:ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
$env:ANTHROPIC_AUTH_TOKEN="YOUR_ANTHROPIC_AUTH_TOKEN"
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

Write-Host "Environment variables set:"
Write-Host "  ANTHROPIC_BASE_URL: $env:ANTHROPIC_BASE_URL"
Write-Host "  ANTHROPIC_AUTH_TOKEN: [REDACTED]"
Write-Host "  CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY: $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY"

Write-Host "`nStarting Claude Code..."
# Start Claude Code if installed
# claude
```

**Usage**:

```powershell
# Run the setup script
.\setup-claude-code.ps1

# Then start Claude Code
claude
```

#### Method 3: Combined Startup Script

Create a file `start-all-services.ps1`:

```powershell
# start-all-services.ps1

# Colors for output
$green = 'Green'
$yellow = 'Yellow'

Write-Host "Starting Claude Code compatibility bridge..." -ForegroundColor $green

# 1. Start FreeLLMAPI
Write-Host "`n[1/3] Starting FreeLLMAPI..." -ForegroundColor $yellow
$freellmapi_process = Start-Process -FilePath "fcc-server" `
  -ArgumentList "--config", ".fcc_env" `
  -PassThru `
  -NoNewWindow

Start-Sleep -Seconds 2

# 2. Start LiteLLM
Write-Host "[2/3] Starting LiteLLM..." -ForegroundColor $yellow
$litellm_process = Start-Process -FilePath "python" `
  -ArgumentList "-m", "litellm.proxy.server", `
    "--config", "litellm-config.yaml", `
    "--port", "4000" `
  -PassThru `
  -NoNewWindow

Start-Sleep -Seconds 2

# 3. Set Claude Code environment variables
Write-Host "[3/3] Configuring Claude Code..." -ForegroundColor $yellow
$env:ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
  $env:ANTHROPIC_AUTH_TOKEN="YOUR_ANTHROPIC_AUTH_TOKEN"
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

Write-Host "`nAll services started!" -ForegroundColor $green
Write-Host "  FreeLLMAPI PID: $($freellmapi_process.Id)"
Write-Host "  LiteLLM PID: $($litellm_process.Id)"
Write-Host "`nClaude Code is ready to use."
Write-Host "`nTo stop services, run:"
Write-Host "  Stop-Process -Id $($freellmapi_process.Id)"
Write-Host "  Stop-Process -Id $($litellm_process.Id)"

# Keep script running to monitor processes
Read-Host "Press Enter to stop all services"

Stop-Process -Id $freellmapi_process.Id -Force
Stop-Process -Id $litellm_process.Id -Force
Write-Host "Services stopped."
```

**Usage**:

```powershell
.\start-all-services.ps1
```

## Permanent Setup (Windows)

To make environment variables permanent across sessions:

### Option 1: Using GUI (Recommended for beginners)

1. **Open System Properties**:
   - Press `Win + Pause/Break` OR
   - Search for "Environment Variables" in Start Menu

2. **Click "Environment Variables" button**

3. **Under "User variables" section, click "New"**

4. **Add each variable**:

   **First Variable**:
   - Variable name: `ANTHROPIC_BASE_URL`
   - Variable value: `http://127.0.0.1:4000`
   - Click OK

   **Second Variable**:
   - Variable name: `ANTHROPIC_AUTH_TOKEN`

- Variable value: `YOUR_ANTHROPIC_AUTH_TOKEN`
- Click OK

**Third Variable**:

- Variable name: `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`
- Variable value: `1`
- Click OK

5. **Click OK to close Environment Variables window**

6. **Restart PowerShell** for changes to take effect

### Option 2: Using PowerShell (Admin Required)

```powershell
# Run PowerShell as Administrator

# Set permanent environment variables
[Environment]::SetEnvironmentVariable(
  "ANTHROPIC_BASE_URL",
  "http://127.0.0.1:4000",
  "User"
)

[Environment]::SetEnvironmentVariable(
  "ANTHROPIC_AUTH_TOKEN",
  "YOUR_ANTHROPIC_AUTH_TOKEN",
  "User"
)

[Environment]::SetEnvironmentVariable(
  "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY",
  "1",
  "User"
)

Write-Host "Environment variables set permanently"

# Restart PowerShell to apply changes
```

### Verify Permanent Setup

After restarting PowerShell:

```powershell
# Verify variables are set
$env:ANTHROPIC_BASE_URL
$env:ANTHROPIC_AUTH_TOKEN
$env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY

# All three should display their values
```

## YAML Configuration (Alternative)

Some Claude Code installations may use a YAML configuration file instead of environment variables.

### Configuration File Location

Check one of these locations:

- `~/.claude/config.yaml`
- `~/.anthropic/config.yaml`
- `./claude-config.yaml`
- `./config/claude-code.yaml`

### YAML Configuration Format

Create or modify `claude-config.yaml`:

```yaml
# Claude Code Configuration

# API Configuration
api:
  # LiteLLM gateway endpoint
  base_url: "http://127.0.0.1:4000"

  # Authentication token
  auth_token: "YOUR_ANTHROPIC_AUTH_TOKEN"

  # Enable model discovery from gateway
  enable_gateway_discovery: true

  # Request timeout in seconds
  timeout: 300

  # Retry configuration
  retries: 3
  retry_delay: 1

# Model Configuration
models:
  # Default model
  default: "claude-opus-4-8"

  # Available models (fetched from gateway if discovery enabled)
  available:
    - claude-opus-4-8
    - claude-sonnet-4-0
    - claude-3-5-haiku

# Application Settings
settings:
  # Debug mode (enable for troubleshooting)
  debug: false

  # Log level (DEBUG, INFO, WARNING, ERROR)
  log_level: "INFO"

  # Streaming responses
  streaming: true

  # Session persistence
  save_sessions: true
  session_dir: "./sessions"

# Behavior
behavior:
  # Maximum context window
  max_context: 8000

  # Temperature for responses
  temperature: 0.8

  # Enable keyboard shortcuts
  keyboard_shortcuts: true
```

### Using YAML Configuration

1. **Create the config file** in one of the locations above
2. **Ensure proper permissions** (readable by Claude Code)
3. **Restart Claude Code** to apply changes
4. **Verify** by checking which configuration format is being used

## Verification

### Check Environment Variables

```powershell
# Display current settings
Write-Host "Current Claude Code Configuration:"
Write-Host "ANTHROPIC_BASE_URL: $env:ANTHROPIC_BASE_URL"
Write-Host "ANTHROPIC_AUTH_TOKEN: [REDACTED if set]"
Write-Host "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY: $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY"

# Test connectivity to LiteLLM
try {
  $response = Invoke-WebRequest -Uri "http://127.0.0.1:4000/health"
  Write-Host "`n✓ LiteLLM is accessible"
  Write-Host "Response: $($response.StatusCode)"
} catch {
  Write-Host "`n✗ Cannot reach LiteLLM"
  Write-Host "Error: $($_.Exception.Message)"
}

# Test model discovery
try {
  $models = Invoke-WebRequest -Uri "http://127.0.0.1:4000/models"
  Write-Host "`n✓ Models available:"
  Write-Host $models.Content
} catch {
  Write-Host "`n✗ Cannot fetch models"
  Write-Host "Error: $($_.Exception.Message)"
}
```

### Test Claude Code Connection

```powershell
# Start Claude Code with debug output
$env:CLAUDE_CODE_DEBUG="1"
claude

# Check for error messages in console
```

### Common Connection Issues

| Issue              | Solution                              |
| ------------------ | ------------------------------------- |
| Connection refused | Check LiteLLM is running on port 4000 |
| 401 Unauthorized   | Check auth token is correct           |
| Model not found    | Check model discovery is enabled      |
| Timeout            | Check network connectivity            |

## Troubleshooting

### Environment Variables Not Working

**Issue**: Claude Code still trying to connect to Anthropic API

**Solution**:

1. Verify variables are set:
   ```powershell
   echo $env:ANTHROPIC_BASE_URL
   ```
2. If empty, set them again
3. If set, restart Claude Code completely
4. Check variable name spelling (case-sensitive in some shells)

### "Connection Refused" Error

**Issue**: Claude Code cannot connect to LiteLLM

**Solution**:

1. Verify LiteLLM is running:
   ```powershell
   curl http://127.0.0.1:4000/health
   ```
2. Check port 4000 is not blocked by firewall
3. Verify correct IP address (127.0.0.1 vs localhost)
4. Check ANTHROPIC_BASE_URL has correct port

### "Authentication Failed" Error

**Issue**: Invalid or missing authentication token

**Solution**:

1. Verify auth token is set:
   ```powershell
   echo $env:ANTHROPIC_AUTH_TOKEN
   ```
2. Check token matches LiteLLM master key
3. Verify token format (should start with `sk-`)
4. Check for trailing whitespace in token

### Models Not Available

**Issue**: Claude Code shows "No models available"

**Solution**:

1. Verify model discovery is enabled:
   ```powershell
   echo $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY
   ```
   Should be `1`
2. Check FreeLLMAPI is running
3. Verify LiteLLM configuration has model_list defined
4. Test model endpoint:
   ```powershell
   curl http://127.0.0.1:4000/models
   ```

### Debug Mode

Enable detailed logging:

```powershell
# Set debug environment variables
$env:CLAUDE_CODE_DEBUG="1"
$env:ANTHROPIC_DEBUG="1"

# Start Claude Code
claude

# Check console output for detailed error messages
```

## Complete Setup Checklist

Before using Claude Code:

- [ ] FreeLLMAPI is installed and running
- [ ] LiteLLM is installed and running
- [ ] `litellm-config.yaml` exists and is valid
- [ ] `.fcc_env` exists and is valid
- [ ] `ANTHROPIC_BASE_URL` is set to `http://127.0.0.1:4000`
- [ ] `ANTHROPIC_AUTH_TOKEN` is set
- [ ] `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` is set to `1`
- [ ] All three services are responding to health checks
- [ ] Claude Code can discover available models
- [ ] First test request succeeds

## Service Startup Order

**Important**: Start services in this order:

1. **Start FreeLLMAPI** first

   ```powershell
   fcc-server --config .fcc_env
   ```

2. **Wait 2 seconds**, then start LiteLLM

   ```powershell
   litellm --config litellm-config.yaml --port 4000
   ```

3. **Set environment variables** for Claude Code

   ```powershell
   $env:ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
   $env:ANTHROPIC_AUTH_TOKEN="YOUR_ANTHROPIC_AUTH_TOKEN"
   $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"
   ```

4. **Start Claude Code**
   ```powershell
   claude
   ```

## Next Steps

1. **Complete Setup**: Follow checklist above
2. **Test Connection**: Verify all services are responding
3. **Try First Prompt**: Send a test message through Claude Code
4. **Monitor Logs**: Watch console output for any errors
5. **Optimize**: Adjust configuration based on performance

## Related Documentation

- [CONFIGURATION.md](CONFIGURATION.md) - Overall configuration
- [LITELLM_CONFIG.md](LITELLM_CONFIG.md) - LiteLLM setup
- [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md) - FreeLLMAPI setup
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

---

**Last Updated**: 2026
**Version**: 1.0
