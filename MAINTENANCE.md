# Maintenance Guide

This guide covers maintaining, updating, and troubleshooting the Claude Code with FreeLLMAPI + LiteLLM system in production.

## Table of Contents

1. [Overview](#overview)
2. [Regular Maintenance Tasks](#regular-maintenance-tasks)
3. [Updating Components](#updating-components)
4. [API Key Management](#api-key-management)
5. [Cache Management](#cache-management)
6. [Performance Optimization](#performance-optimization)
7. [Backup and Recovery](#backup-and-recovery)
8. [Monitoring](#monitoring)
9. [Troubleshooting](#troubleshooting)

## Overview

### Maintenance Frequency

| Task                    | Frequency |
| ----------------------- | --------- |
| Check logs              | Daily     |
| Verify services         | Daily     |
| Update security patches | Monthly   |
| Clear cache             | Weekly    |
| Full backup             | Weekly    |
| Component updates       | Quarterly |

### System Components to Maintain

1. **FreeLLMAPI**: API gateway and provider management
2. **LiteLLM**: Compatibility bridge and model translation
3. **Claude Code**: User application
4. **Provider Pool**: Backend models (LM Studio, Ollama, etc.)
5. **Dependencies**: Python packages and Node.js modules

## Regular Maintenance Tasks

### Daily: Check Service Health

```powershell
# Check FreeLLMAPI
$fcc_health = try {
  Invoke-WebRequest -Uri "http://localhost:8082/health" -ErrorAction Stop
  "✓ OK"
} catch {
  "✗ FAILED"
}

# Check LiteLLM
$litellm_health = try {
  Invoke-WebRequest -Uri "http://localhost:4000/health" -ErrorAction Stop
  "✓ OK"
} catch {
  "✗ FAILED"
}

Write-Host "FreeLLMAPI: $fcc_health"
Write-Host "LiteLLM: $litellm_health"
```

### Daily: Monitor Logs

```powershell
# Check for errors in FreeLLMAPI logs
Get-Content -Tail 50 freellmapi.log | Select-String "ERROR"

# Check for errors in LiteLLM logs
Get-Content -Tail 50 litellm.log | Select-String "ERROR"
```

### Weekly: Clear Cache

```powershell
# Clear LiteLLM cache (if using cache)
Remove-Item -Path "./litellm_cache/*" -Force -Recurse

# Clear temporary files
Remove-Item -Path "./temp/*" -Force -Recurse

# Clean old logs (keep last 30 days)
Get-ChildItem -Path "./logs" -Filter "*.log" |
  Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
  Remove-Item -Force
```

### Weekly: Validate Configuration

```powershell
# Verify configuration files exist and are readable
Test-Path "litellm-config.yaml"
Test-Path ".fcc_env"
Test-Path ".env"

# Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('litellm-config.yaml'))"

# Check file permissions
Get-Item -Path "litellm-config.yaml" | Format-List -Property @{
  Label='Can Read'; Expression={$_.Access -contains 'Read'}
}
```

## Updating Components

### Update LiteLLM

```powershell
# Check current version
litellm --version

# Update to latest version
pip install --upgrade litellm

# Update to specific version
pip install litellm==1.0.0

# Verify update
litellm --version
```

**After Update**:

1. Test configuration loads
2. Verify all models still work
3. Check compatibility with Claude Code
4. Monitor for issues

### Update FreeLLMAPI

```powershell
# Check current version
fcc-server --version

# Update to latest version
npm update -g freellmapi

# Update to specific version
npm install -g freellmapi@1.0.0

# Verify update
fcc-server --version
```

**After Update**:

1. Restart FreeLLMAPI
2. Verify provider pool still accessible
3. Run health checks
4. Monitor performance

### Update Claude Code

```powershell
# Check for updates (depends on installation method)
# If installed via package manager:
choco upgrade claude-code

# If installed via npm:
npm update -g claude-code

# If installed via direct binary:
# Download latest from official source and replace
```

**After Update**:

1. Verify environment variables still set
2. Test connection to LiteLLM
3. Try sample prompts
4. Check for new features

### Update Python Packages

Run Python package updates only within the relevant component repositories (for example, LiteLLM).

```powershell
# In the LiteLLM repository (example)
cd /path/to/litellm
pip install --upgrade -r requirements.txt

# Update a specific package in that repo
pip install --upgrade litellm
```

### Update Node.js Packages

Run Node.js package updates inside the target project directory (for example, FreeLLMAPI).

```powershell
# In the FreeLLMAPI repository
cd /path/to/freellmapi
npm outdated
npm update
npm install freellmapi@latest
```

## API Key Management

### Key Rotation

Periodically rotate API keys for security:

```powershell
# Step 1: Generate new API key
# (Instructions depend on API provider)

# Step 2: Update environment variable
$env:NEW_OPENAI_API_KEY="YOUR_OPENAI_API_KEY"

# Step 3: Update litellm-config.yaml
# - Edit the file and update the key
# - Or reload config without restarting

# Step 4: Test with new key
Invoke-WebRequest -Headers @{"Authorization"="Bearer YOUR_OPENAI_API_KEY"} `
  -Uri "http://localhost:4000/health"

# Step 5: Verify all models work with new key

# Step 6: Remove old key from environment
Remove-Item -Path Env:\OLD_OPENAI_API_KEY

# Step 7: Document rotation
Write-Output "$(Get-Date): API key rotated" | Add-Content key-rotation.log
```

### Secure Key Storage

```powershell
# Use secure string storage (Windows)
$apiKey = Read-Host "Enter API Key" -AsSecureString
$apiKey | ConvertFrom-SecureString | Set-Content api-key.secure

# Retrieve key when needed
$apiKey = Get-Content api-key.secure | ConvertTo-SecureString
$apiKey_Plain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
  [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($apiKey)
)
```

### Key Backup

```powershell
# Backup configuration (without exposing keys)
Copy-Item -Path "litellm-config.yaml" -Destination "litellm-config.yaml.backup"

# Backup environment variables (securely)
# Never backup with actual keys!
@{
  ANTHROPIC_BASE_URL = $env:ANTHROPIC_BASE_URL
  CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = $env:CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY
  # Note: Never include actual keys in backup
} | ConvertTo-Json | Out-File -Path "env-backup.json"
```

## Cache Management

### Clear LiteLLM Cache

```powershell
# If using in-memory cache
# (Automatic on restart)

# If using Redis cache
redis-cli FLUSHALL

# If using file-based cache
Remove-Item -Path "./cache/*" -Force -Recurse
```

### Monitor Cache Size

```powershell
# Get cache directory size
$cacheSize = (Get-ChildItem -Path "./cache" -Recurse |
  Measure-Object -Property Length -Sum).Sum

Write-Host "Cache Size: $($cacheSize / 1MB) MB"

# Set up automatic cleanup if over threshold
if ($cacheSize -gt 1GB) {
  Write-Host "Cache exceeds 1GB, clearing..."
  Remove-Item -Path "./cache/*" -Force -Recurse
}
```

## Performance Optimization

### Monitor Resource Usage

```powershell
# Check process resource usage
Get-Process fcc-server, python | Select-Object Name, CPU, Memory

# Get detailed FreeLLMAPI info
Get-Process -Name "node" | Get-Member

# Monitor over time
$times = @()
for ($i = 0; $i -lt 5; $i++) {
  $times += @{
    Timestamp = Get-Date
    FCC_CPU = (Get-Process fcc-server).CPU
    LiteLLM_CPU = (Get-Process python).CPU
  }
  Start-Sleep -Seconds 5
}
$times | Format-Table
```

### Optimize Configuration

```yaml
# High-traffic optimization
litellm_settings:
  drop_params: true
  num_retries: 2
  request_timeout: 120

# Increase request queue
settings:
  request_queue_size: 2000
  max_connections: 200

# Use faster models for simple tasks
model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      # Higher timeout for complex requests
      timeout: 180
  - model_name: claude-3-5-haiku
    litellm_params:
      # Lower timeout for simple requests
      timeout: 30
```

### Connection Pooling

```powershell
# FreeLLMAPI connection pool
# In .fcc_env:
# settings:
#   max_connections: 500
#   connection_timeout: 30

# LiteLLM connection pool
# In litellm-config.yaml:
# general_settings:
#   connection_pool_size: 100
```

## Backup and Recovery

### Backup Procedure

```powershell
# Create backup directory
$backup_dir = "backups\backup-$(Get-Date -Format 'yyyy-MM-dd-HHmmss')"
New-Item -ItemType Directory -Path $backup_dir

# Backup configuration files
Copy-Item "litellm-config.yaml" "$backup_dir\"
Copy-Item ".fcc_env" "$backup_dir\"
Copy-Item ".env" "$backup_dir\"

# Backup logs
Copy-Item "logs\*" "$backup_dir\logs\" -Recurse -Force

# Backup session data (if applicable)
Copy-Item "sessions\*" "$backup_dir\sessions\" -Recurse -Force

# Create manifest
@{
  Date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  Components = @(
    "Configuration files",
    "Logs",
    "Session data"
  )
} | ConvertTo-Json | Out-File "$backup_dir\manifest.json"

Write-Host "Backup created at: $backup_dir"
```

### Recovery Procedure

```powershell
# List available backups
Get-ChildItem -Path "backups\" -Directory | Sort-Object -Property CreationTime -Descending

# Restore from backup
$backup = Read-Host "Enter backup directory name"
Copy-Item "backups\$backup\litellm-config.yaml" ".\"
Copy-Item "backups\$backup\.fcc_env" ".\"
Copy-Item "backups\$backup\.env" ".\"

# Restart services
Stop-Process -Name "fcc-server", "python" -Force
Start-Sleep -Seconds 2
fcc-server --config .fcc_env
litellm --config litellm-config.yaml --port 4000
```

## Monitoring

### Set Up Health Monitoring

```powershell
# Create monitoring script
@"
function Check-SystemHealth {
  Write-Host "=== System Health Check ===" -ForegroundColor Green

  # Check services
  `$services = @(
    @{ Name = "FreeLLMAPI"; Port = 8082 },
    @{ Name = "LiteLLM"; Port = 4000 }
  )

  foreach (`$svc in `$services) {
    `$health = try {
      Invoke-WebRequest -Uri "http://localhost:$($svc.Port)/health" -ErrorAction Stop
      "✓ Healthy"
    } catch {
      "✗ Offline"
    }
    Write-Host "`$($svc.Name): `$health"
  }

  # Check disk space
  `$disk = Get-PSDrive C | Select-Object -ExpandProperty Free
  Write-Host "Free Disk Space: $([math]::Round(`$disk / 1GB, 2)) GB"

  # Check memory
  `$memory = Get-Process | Measure-Object -Property WorkingSet -Sum
  Write-Host "Total Memory Usage: $([math]::Round(`$memory.Sum / 1MB, 2)) MB"
}

Check-SystemHealth
"@ | Out-File "health-check.ps1"

# Run health check
.\health-check.ps1
```

### Automated Monitoring

```powershell
# Create scheduled task for monitoring
$trigger = New-ScheduledTaskTrigger -Daily -At 9:00AM
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\path\to\health-check.ps1"
Register-ScheduledTask -TaskName "Claude-Code-Health-Check" -Trigger $trigger -Action $action
```

## Troubleshooting

### Service Won't Start

```powershell
# Check if port is in use
netstat -ano | findstr :8082
netstat -ano | findstr :4000

# Check firewall
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*LiteLLM*"}

# Check logs for error
Get-Content litellm.log -Tail 50
```

### Performance Degradation

```powershell
# Check system resources
Get-Process | Where-Object {$_.Name -match "fcc-server|python"} | Format-Table Name, CPU, Memory

# Check network connectivity
Test-NetConnection -ComputerName localhost -Port 8082
Test-NetConnection -ComputerName localhost -Port 4000

# Check provider pool status
Invoke-WebRequest http://localhost:8082/providers
```

### Connection Issues

```powershell
# Test connectivity between components
$fcc = Invoke-WebRequest http://localhost:8082/health
$litellm = Invoke-WebRequest http://localhost:4000/health

# Test model availability
$models = Invoke-WebRequest http://localhost:4000/models
Write-Host $models.Content
```

## Next Steps

1. **Set Maintenance Schedule**: Create calendar reminders
2. **Automate Backups**: Set up daily/weekly backups
3. **Monitor Logs**: Configure log rotation and monitoring
4. **Update Regularly**: Keep components up to date
5. **Document Changes**: Track all modifications

## Related Documentation

- [CONFIGURATION.md](CONFIGURATION.md) - Configuration guide
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Problem solving
- [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md) - FreeLLMAPI details
- [LITELLM_CONFIG.md](LITELLM_CONFIG.md) - LiteLLM details

---

**Last Updated**: 2026
**Version**: 1.0
