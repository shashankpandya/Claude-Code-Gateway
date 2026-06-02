# Start FreeLLMAPI server
# FreeLLMAPI provides an OpenAI-compatible API endpoint that manages the provider pool

# ============================================================================
# IMPORTANT: FreeLLMAPI must be run from its own installation directory
# ============================================================================
# This script does NOT automatically install or run FreeLLMAPI
# FreeLLMAPI is a separate Node.js application

# If you haven't installed FreeLLMAPI yet:
#   npm install -g freellmapi

# To run this script correctly:
# 1. Navigate to your FreeLLMAPI installation directory (or project root)
# 2. Ensure you have a .fcc_env configuration file with provider settings
# 3. Run this script from PowerShell

# Example setup (if FreeLLMAPI is in C:\path\to\freellmapi):
$freellmapi_dir = "C:\path\to\freellmapi"
if (-not (Test-Path $freellmapi_dir)) {
    Write-Host "ERROR: FreeLLMAPI directory not found at $freellmapi_dir"
    Write-Host "Please update the path or install FreeLLMAPI first"
    Write-Host "`nTo install FreeLLMAPI:"
    Write-Host "  npm install -g freellmapi"
    Exit 1
}

# Set environment variables for FreeLLMAPI
$env:FCC_PORT = "8082"
$env:FCC_DEBUG = "1"
Write-Host "Starting FreeLLMAPI..."
Write-Host "Port: $env:FCC_PORT"
Write-Host "Debug: $env:FCC_DEBUG"

# Start the FreeLLMAPI server
# The --config flag points to your FreeLLMAPI configuration file
# Update the path to match your .fcc_env location
fcc-server --config .fcc_env

Write-Host "FreeLLMAPI started on port 8082"
Write-Host "Health check: curl http://localhost:8082/health"