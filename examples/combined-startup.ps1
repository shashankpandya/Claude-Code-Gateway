# Combined Startup Script
# Orchestrates the startup of the complete Claude Code compatibility bridge system
# Starts: FreeLLMAPI -> LiteLLM -> Claude Code (with environment variables)

# ============================================================================
# IMPORTANT PREREQUISITES
# ============================================================================
# Before running this script, ensure:
# 1. FreeLLMAPI is installed: npm install -g freellmapi
# 2. LiteLLM is installed: pip install litellm
# 3. Claude Code is installed and available in PATH
# 4. .fcc_env file exists (FreeLLMAPI configuration)
# 5. litellm-config.yaml exists (LiteLLM configuration)

# ============================================================================
# Startup Order
# ============================================================================
# 1. FreeLLMAPI: Starts on port 8082 (API gateway + provider pool)
# 2. LiteLLM: Starts on port 4000 (compatibility bridge)
# 3. Claude Code: Launches with environment variables pointing to LiteLLM

Write-Host "" 
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Claude Code Compatibility Bridge - Complete Startup" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# Step 1: Start FreeLLMAPI
# ============================================================================
Write-Host "[STEP 1/3] Starting FreeLLMAPI on port 8082..." -ForegroundColor Yellow
Write-Host "FreeLLMAPI: Provides OpenAI-compatible API endpoint + provider pool"
Write-Host "Expected endpoint: http://localhost:8082"
Write-Host ""

# Note: FreeLLMAPI should be started from its own directory
# This assumes you're running from the project root and FreeLLMAPI is globally installed
Start-Process -FilePath "pwsh" -ArgumentList "-File", ".\examples\start-freellmapi.ps1" -WindowStyle New

Write-Host "Waiting 3 seconds for FreeLLMAPI to initialize..."
Start-Sleep -Seconds 3

# ============================================================================
# Step 2: Start LiteLLM
# ============================================================================
Write-Host "[STEP 2/3] Starting LiteLLM on port 4000..." -ForegroundColor Yellow
Write-Host "LiteLLM: Compatibility bridge (Anthropic format ↔ OpenAI format)"
Write-Host "Expected endpoint: http://localhost:4000"
Write-Host ""

Start-Process -FilePath "pwsh" -ArgumentList "-File", ".\examples\start-litellm.ps1" -WindowStyle New

Write-Host "Waiting 3 seconds for LiteLLM to initialize..."
Start-Sleep -Seconds 3

# ============================================================================
# Step 3: Set Claude Code Environment Variables and Launch
# ============================================================================
Write-Host "[STEP 3/3] Launching Claude Code..." -ForegroundColor Yellow
Write-Host "Claude Code: User-facing application"
Write-Host "Expected endpoint: http://127.0.0.1:4000 (via LiteLLM)"
Write-Host ""

Start-Process -FilePath "pwsh" -ArgumentList "-File", ".\examples\start-claude.ps1" -WindowStyle New

# ============================================================================
# Startup Complete
# ============================================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "All services started!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Service Status:" -ForegroundColor Cyan
Write-Host "  FreeLLMAPI: http://localhost:8082" -ForegroundColor Green
Write-Host "  LiteLLM: http://localhost:4000" -ForegroundColor Green
Write-Host "  Claude Code: Running (check new window)" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Verify FreeLLMAPI: curl http://localhost:8082/health"
Write-Host "  2. Verify LiteLLM: curl http://localhost:4000/health"
Write-Host "  3. Use Claude Code in the new window"
Write-Host ""
Write-Host "Troubleshooting:" -ForegroundColor Cyan
Write-Host "  - If a service fails to start, check the corresponding .ps1 script"
Write-Host "  - Review logs in each service window"
Write-Host "  - Refer to TROUBLESHOOTING.md for common issues"
Write-Host ""
Write-Host "To stop all services:" -ForegroundColor Cyan
Write-Host "  1. Close each service window (Ctrl+C)"
Write-Host "  2. Or run: Get-Process fcc-server, python, claude | Stop-Process"
Write-Host ""