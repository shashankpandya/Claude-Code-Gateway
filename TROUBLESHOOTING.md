# Troubleshooting Guide

This guide provides solutions to common issues you might encounter while setting up and running Claude Code with FreeLLMAPI and LiteLLM.

## Common Issues and Fixes

### 1. UV Version Mismatch

- **Symptom:** Error messages indicating a version mismatch when using uv.
- **Root Cause:** Multiple versions of UV installed or PATH conflicts.
- **Fix:** Ensure you have the correct version of UV installed and properly configured in PATH.
- **Example Commands:**

  ```powershell
  # Check current uv version
  uv --version

  # Install/upgrade to the correct version
  pip install --upgrade uv

  # Verify installation
  uv --version
  ```

- **Success Signal:** Consistent uv version output without errors.

### 2. Multiple UV Installations

- **Symptom:** Conflicting behavior or errors when running uv commands.
- **Root Cause:** Multiple versions of UV installed in different locations.
- **Fix:** Uninstall all versions and install a clean version.
- **Example Commands:**

  ```powershell
  # Uninstall uv
  pip uninstall uv

  # Reinstall clean version
  pip install uv

  # Verify single installation
  where uv  # Should show only one path
  ```

- **Success Signal:** Single uv installation path and consistent behavior.

### 3. PATH Conflicts

- **Symptom:** Commands not found or wrong versions being executed.
- **Root Cause:** PATH environment variable pointing to incorrect or multiple locations.
- **Fix:** Update PATH to prioritize correct installation directories.
- **Example Commands:**

  ```powershell
  # View current PATH
  echo $env:PATH

  # Add correct directory to PATH (example)
  $env:PATH = "C:\Users\admin\.cargo\bin;" + $env:PATH

  # Make permanent (System Properties > Advanced > Environment Variables)
  ```

- **Success Signal:** Correct commands execute from expected locations.

### 4. fcc-server Not Found

- **Symptom:** Error: "fcc-server : The term 'fcc-server' is not recognized..."
- **Root Cause:** FreeLLMAPI not installed or not in PATH.
- **Fix:** Install FreeLLMAPI and ensure it's accessible.
- **Example Commands:**

  ```powershell
  # Install FreeLLMAPI
  pip install freellmapi

  # Verify installation
  fcc-server --help

  # If still not found, check installation location and add to PATH
  ```

- **Success Signal:** fcc-server command executes and shows help output.

### 5. Port 8082 Already in Use

- **Symptom:** Error when starting FreeLLMAPI: "Address already in use"
- **Root Cause:** Another service is already using port 8082.
- **Fix:** Stop the conflicting service or change FreeLLMAPI port.
- **Example Commands:**

  ```powershell
  # Find what's using port 8082
  netstat -ano | findstr :8082

  # Stop the process (replace PID with actual process ID)
  taskkill /PID <PID> /F

  # Alternative: Change FreeLLMAPI port in configuration
  # Edit .fcc_env.example and set FCC_PORT=8083
  ```

- **Success Signal:** FreeLLMAPI starts successfully and binds to port.

### 6. NVIDIA_NIM_API_KEY Errors

- **Symptom:** Errors related to missing or invalid NVIDIA_NIM_API_KEY.
- **Root Cause:** API key not set or invalid when using NVIDIA NIM models.
- **Fix:** Set correct API key in environment variables.
- **Example Commands:**

  ```powershell
  # Set API key for current session
  $env:NVIDIA_NIM_API_KEY = "your_actual_nvidia_key_here"

  # To make permanent, add to system environment variables
  ```

- **Success Signal:** No NVIDIA API key errors in logs.

### 7. OpenRouter Proxy Confusion

- **Symptom:** Connection errors or timeouts when using OpenRouter.
- **Root Cause:** Incorrect proxy settings interfering with OpenRouter connection.
- **Fix:** Configure proxy correctly or bypass for OpenRouter.
- **Example Commands:**

  ```powershell
  # To bypass proxy for OpenRouter
  $env:NO_PROXY = "openrouter.ai"

  # Or configure specific proxy
  $env:HTTPS_PROXY = "http://proxy.example.com:8080"
  ```

- **Success Signal:** Successful connection to OpenRouter API.

### 8. LM Studio 404 Errors

- **Symptom:** 404 errors when accessing LM Studio endpoints.
- **Root Cause:** LM Studio not running or incorrect endpoint configuration.
- **Fix:** Ensure LM Studio is running and configured correctly.
- **Example Commands:**

  ```powershell
  # Start LM Studio (if not running)
  # Then verify it's accessible
  Invoke-WebRequest http://localhost:1234/v1/models

  # Default LM Studio port is usually 1234
  ```

- **Success Signal:** Successful response from LM Studio API.

### 9. Ollama 404 Errors

- **Symptom:** 404 errors when accessing Ollama endpoints.
- **Root Cause:** Ollama not running or incorrect endpoint configuration.
- **Fix:** Ensure Ollama is running and configured correctly.
- **Example Commands:**

  ```powershell
  # Start Ollama service
  ollama serve

  # Verify it's accessible (in another terminal)
  Invoke-WebRequest http://localhost:11434/api/tags
  ```

- **Success Signal:** Successful response from Ollama API showing available models.

### 10. Invalid Model Mapping

- **Symptom:** Errors indicating model not found or invalid model specification.
- **Root Cause:** Incorrect model mapping in LiteLLM configuration.
- **Fix:** Verify and correct model mappings in litellm-config.yaml.
- **Example Fix:**

  ```yaml
  # Incorrect
  - model_name: claude-opus-4-8
    litellm_params:
      model: nonexistent-model

  # Correct
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
  ```

- **Success Signal:** Claude Code recognizes and can use the mapped models.

### 11. Unsupported Anthropic Parameters

- **Symptom:** Errors about unsupported parameters like "reasoning_effort" or "context_management".
- **Root Cause:** LiteLLM not dropping unsupported Anthropic-specific parameters.
- **Fix:** Ensure `drop_params: true` is set in LiteLLM configuration.
- **Example Configuration:**
  ```yaml
  litellm_settings:
    drop_params: true # This is critical for compatibility
  ```
- **Success Signal:** No parameter rejection errors in LiteLLM logs.

### 12. /v1/responses Endpoint Mismatch

- **Symptom:** 404 errors on /v1/responses endpoint.
- **Root Cause:** Claude Code expects /v1/responses but FreeLLMAPI only provides /v1/chat/completions.
- **Fix:** Ensure LiteLLM is properly translating endpoints or use compatible gateway.
- **Verification:** Check LiteLLM logs for proper endpoint translation.
- **Success Signal:** Successful responses from Claude Code without 404 errors.

### 13. No Healthy Deployments

- **Symptom:** Errors indicating no healthy deployments available.
- **Root Cause:** Provider pool configuration issues or all providers unhealthy.
- **Fix:** Verify provider configurations and health.
- **Example Checks:**

  ```powershell
  # Test FreeLLMAPI health
  Invoke-WebRequest http://localhost:8082/health

  # Test provider endpoints directly
  Invoke-WebRequest http://localhost:5000/health  # Local model
  Invoke-WebRequest https://api.example.com/health  # Remote model
  ```

- **Success Signal:** Health checks pass and providers show as healthy.

### 14. reasoning_effort / context_management Errors

- **Symptom:** Errors about unsupported parameters specific to certain Anthropic features.
- **Root Cause:** These are Anthropic-specific parameters not supported by OpenAI-compatible APIs.
- **Fix:** Ensure `drop_params: true` is configured in LiteLLM to filter these out.
- **Example Configuration:**
  ```yaml
  litellm_settings:
    drop_params: true
    # Additional parameter filtering if needed
    # drop_params: ["reasoning_effort", "context_management"]
  ```
- **Success Signal:** No errors about these specific parameters.

### 15. LiteLLM Provider Detection Issues

- **Symptom:** Errors indicating LiteLLM cannot detect or initialize providers.
- **Root Cause:** Incorrect provider configuration or missing dependencies.
- **Fix:** Verify LiteLLM configuration and install required provider dependencies.
- **Example Checks:**

  ```powershell
  # Verify LiteLLM can load configuration
  litellm --config litellm-config.yaml --debug

  # Check provider-specific dependencies
  pip install openai  # For openai provider
  ```

- **Success Signal:** LiteLLM starts without provider detection errors.

### 16. custom_openai Provider Issues

- **Symptom:** Errors related to custom_openai provider configuration.
- **Root Cause:** Incorrect base_url, api_key, or other custom_openai settings.
- **Fix:** Verify custom_openai configuration matches FreeLLMAPI endpoint.
- **Example Configuration:**
  ```yaml
  custom_openai:
    base_url: "http://localhost:8082" # Must match FreeLLMAPI port
    api_key: "YOUR_FREELLMAPI_API_KEY" # Placeholder - replace with your FreeLLMAPI key
  ```
- **Success Signal:** LiteLLM successfully connects to FreeLLMAPI as custom_openai provider.

## General Troubleshooting Steps

1. **Check Logs:**
   - FreeLLMAPI logs: Check console output or log files
   - LiteLLM logs: Check console output or log files
   - Claude Code logs: Check console output or log files

2. **Verify Connectivity:**

   ```powershell
   # Test FreeLLMAPI
   Invoke-WebRequest http://localhost:8082/health

   # Test LiteLLM
   Invoke-WebRequest http://localhost:4000/health

   # Test Claude Code gateway
   Invoke-WebRequest http://localhost:4000/models
   ```

3. **Validate Configuration:**

- Verify all YAML files are properly formatted
- Check that environment variables are set correctly
- Ensure ports match between services

4. **Version Compatibility:**

- Check VERSION_REFERENCE.md for example version combinations (examples — not an authoritative tested matrix)
- Ensure all components are compatible versions

## Getting Further Help

If you've tried these troubleshooting steps and still encounter issues:

1. Check the [FAQ](FAQ.md) for common questions
2. Look through existing [GitHub Issues](https://github.com/shashankpandya/claude-code-freellmapi/issues)
3. Open a new issue with detailed information including:
   - Exact error messages
   - Steps to reproduce
   - Environment details (OS, versions, etc.)
   - Relevant log snippets
   - Configuration files (with secrets removed)
