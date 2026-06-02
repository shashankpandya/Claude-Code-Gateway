# Setup Notes

This document provides additional notes on setting up the environment for the Claude Code with FreeLLMAPI + LiteLLM compatibility bridge.

## Prerequisites

Before starting the setup process, ensure you have the following prerequisites installed:

1. **Python 3.8+**:
   - Required for running FreeLLMAPI and LiteLLM
   - Download from https://www.python.org/downloads/
   - Verify installation: `python --version`

2. **Node.js 16+**:
   - Required for running FreeLLMAPI and other Node.js-based components
   - Download from https://nodejs.org/
   - Verify installation: `node --version`

3. **Git**:
   - Required for version control and cloning the repository
   - Download from https://git-scm.com/downloads
   - Verify installation: `git --version`

4. **PowerShell**:
   - Required for running the provided PowerShell scripts
   - Comes with Windows 10/11 by default
   - Verify installation: `powershell -version`

## Installation Steps

1. **Clone the Repository**:

   ```powershell
   git clone https://github.com/shashankpandya/claude-code-freellmapi.git
   cd claude-code-freellmapi
   ```

2. **Install Dependencies**:

   Note: This repository is documentation-focused. Do NOT run global
   `pip install -r requirements.txt` or `npm install` from the repository
   root. Instead, install dependencies per-component in their own project
   directories as described below.
   - FreeLLMAPI (Node.js): follow [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md) —
     run `npm install` inside the FreeLLMAPI project directory only if you
     are running that project locally.
   - LiteLLM (Python): follow [LITELLM_CONFIG.md](LITELLM_CONFIG.md) —
     install Python packages inside the LiteLLM environment (e.g. `pip install -r requirements.txt` in the LiteLLM repo only).
   - Claude Code: follow [CLAUDE_CODE_CONFIG.md](CLAUDE_CODE_CONFIG.md) for any runtime installation steps.

3. **Set Up Environment Variables**:
   - Copy `.env.example` to `.env` and fill in your API keys
   - Copy `.fcc_env.example` to `.fcc_env` and configure FreeLLMAPI settings
   - Set environment variables for Claude Code

4. **Configure Services**:
   - Edit `litellm-config.yaml` to set up model mappings
   - Configure FreeLLMAPI provider pool in its configuration file

5. **Start Services**:
   ```powershell
   .\examples\combined-startup.ps1
   ```

## Configuration Details

### FreeLLMAPI Configuration

1. **Provider Pool**:
   - Configure the provider pool in FreeLLMAPI to include all the models you want to use
   - Example configuration in `.fcc_env.example`

2. **Port Configuration**:
   - By default, FreeLLMAPI runs on port 8082
   - Change by setting `FCC_PORT` environment variable

### LiteLLM Configuration

1. **Model Mappings**:
   - Configure model mappings in `litellm-config.yaml`
   - Map Claude-style model names to actual backend models

2. **Parameter Handling**:
   - Ensure `drop_params: true` is set to filter unsupported parameters

### Claude Code Configuration

1. **Environment Variables**:
   - `ANTHROPIC_BASE_URL`: Set to `http://127.0.0.1:4000` (LiteLLM default endpoint)
   - `ANTHROPIC_AUTH_TOKEN`: YOUR_ANTHROPIC_AUTH_TOKEN (placeholder)
   - `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`: Set to `1`

2. **Model Selection**:
   - Configure the default model in Claude Code settings

## Troubleshooting

If you encounter issues during setup:

1. **Check Logs**:
   - FreeLLMAPI logs: Check console output or log files
   - LiteLLM logs: Check console output or log files
   - Claude Code logs: Check console output or log files

2. **Verify Connectivity**:

   ```powershell
   # Test FreeLLMAPI
   Invoke-WebRequest http://localhost:8082/health

   # Test LiteLLM
   Invoke-WebRequest http://localhost:4000/health

   # Test Claude Code gateway
   Invoke-WebRequest http://localhost:4000/models
   ```

3. **Validate Configuration**:
   - Verify all YAML files are properly formatted
   - Check that environment variables are set correctly
   - Ensure ports match between services

4. **Version Compatibility**:
   - Check VERSION_REFERENCE.md for example version combinations (examples — not an authoritative tested matrix)
   - Ensure all components are compatible versions

## Security Considerations

1. **API Key Security**:
   - Never commit real API keys to version control
   - Use environment variables or secure vault solutions
   - Add `.env` and `.fcc_env` to `.gitignore`

2. **Network Security**:
   - For development, local network is generally safe
   - For production, implement proper authentication and encryption

3. **Firewall Configuration**:
   - Configure firewall to allow communication between services
   - Only expose necessary ports to the network

## Next Steps

After completing the setup:

1. **Run Validation Tests**:

   ```powershell
   .\examples\test-prompts.ps1
   ```

2. **Explore Features**:
   - Experiment with different models and configurations
   - Try out various prompts and features

3. **Monitor Performance**:
   - Keep an eye on resource usage and performance
   - Adjust configurations as needed

4. **Update Regularly**:
   - Keep components updated for security and performance improvements

For more detailed information on specific components, refer to their respective documentation files.
