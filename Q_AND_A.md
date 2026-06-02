# Detailed Q&A

This document provides a more detailed question and answer section covering various topics related to setting up and using Claude Code with FreeLLMAPI and LiteLLM.

## Installation and Setup

**Q: Do I need to install FreeLLMAPI and LiteLLM separately?**
A: Yes, both FreeLLMAPI and LiteLLM need to be installed separately. FreeLLMAPI provides the API gateway functionality, while LiteLLM acts as the compatibility bridge between Claude Code and FreeLLMAPI.

**Q: Can I use Docker instead of installing directly?**
A: While this guide focuses on direct installation, Docker containers are available for both FreeLLMAPI and LiteLLM. You would need to adapt the startup scripts to use docker run commands instead.

**Q: What if I don't have administrative privileges on my machine?**
A: You can install Python, Node.js, and the required packages in user space using options like `--user` with pip or nvm for Node.js version management.

**Q: Do I need to restart my terminal after setting environment variables?**
A: For session-specific variables set in PowerShell, no restart is needed. For permanent system environment variables, you may need to restart your terminal or IDE.

## Configuration Details

**Q: Why do we need to set `drop_params: true` in LiteLLM?**
A: Claude Code sends Anthropic-specific parameters (like `reasoning_effort`, `context_management`) that are not supported by OpenAI-compatible APIs. Setting `drop_params: true` tells LiteLLM to remove these unsupported parameters before forwarding requests to FreeLLMAPI.

**Q: What happens if I don't set `ANTHROPIC_BASE_URL` correctly?**
A: Claude Code will attempt to connect to the default Anthropic API endpoint instead of your local setup, resulting in connection failures or unexpected behavior if you don't have valid Anthropic API credentials.

**Q: Can I use different ports for the services?**
A: Yes, you can configure different ports for each service:

- FreeLLMAPI: Set `FCC_PORT` environment variable
- LiteLLM: Change the port in the configuration or use command-line arguments
- Claude Code: Set `ANTHROPIC_BASE_URL` to match your LiteLLM endpoint

**Q: What is `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` and why do I need it?**
A: This environment variable tells Claude Code to enable model discovery when using a gateway/proxy setup. Without it, Claude Code may not properly recognize the available models through your compatibility layer.

## Model Mapping and Providers

**Q: Why are we mapping Claude models to OpenAI model names?**
A: FreeLLMAPI provides an OpenAI-compatible API, so we need to map the Claude-style model names that Claude Code expects to the actual OpenAI-compatible model names that FreeLLMAPI can serve.

**Q: Can I use models other than OpenAI models with this setup?**
A: Yes, as long as your FreeLLMAPI provider pool includes services that offer OpenAI-compatible APIs for those models. For example, you could add Ollama or LM Studio providers that serve Llama, Mistral, or other model families.

**Q: How do I add a new model mapping?**
A: Add a new entry to the `model_list` in your `litellm-config.yaml` file:

```yaml
- model_name: claude-3-opus-latest
  litellm_params:
    model: custom_openai/gpt-4o
    api_base: "http://localhost:8082"
    api_key: "YOUR_FREELLMAPI_API_KEY"
```

**Q: What if I want to use multiple different backend models for the same Claude model name?**
A: You can create multiple entries with the same `model_name` but different `litellm_params.model` values. LiteLLM will distribute requests across these options.

## Security and Privacy

**Q: Is it safe to expose these services on my local network?**
A: For development and testing on a trusted local network, it's generally acceptable. However, for production use or on untrusted networks, you should implement proper authentication, encryption, and access controls.

**Q: Should I be concerned about data privacy with this setup?**
A: Since all services run locally on your machine, your data never leaves your computer unless you explicitly configure remote providers in your FreeLLMAPI pool. Always review the privacy policies of any remote providers you choose to use.

**Q: How do I securely handle API keys in team environments?**
A: Use environment variables or secure vault solutions. Never commit real API keys to version control. Consider using tools like .env files with appropriate .gitignore rules or secret management systems.

## Performance and Optimization

**Q: Will this setup add latency to my requests?**
A: Yes, there will be some additional latency due to the extra network hops (Claude Code → LiteLLM → FreeLLMAPI → Provider). However, for local development, this is usually negligible compared to the benefits of compatibility.

**Q: How can I optimize performance?**
A:

1. Ensure all services are running on the same machine to minimize network latency
2. Use appropriate model sizes for your hardware
3. Monitor resource usage and adjust accordingly
4. Consider using connection pooling if available in your providers

**Q: Does this setup support streaming responses?**
A: Yes, both LiteLLM and FreeLLMAPI support streaming responses, and Claude Code will handle them appropriately when streaming is enabled.

## Advanced Usage

**Q: Can I use this setup with other IDEs or editors besides the Claude Code CLI?**
A: This setup is specifically designed for the Claude Code CLI. Other integrations would need to be configured to point to your LiteLLM endpoint instead of the default Anthropic API.

**Q: How do I debug issues with request/response formatting?**
A: Enable verbose logging in both LiteLLM (`set_verbose: true` in config) and FreeLLMAPI (debug mode) to see the exact requests and responses being exchanged.

**Q: Can I customize the timeout values for requests?**
A: Yes, both LiteLLM and FreeLLMAPI allow you to configure timeout values. Refer to their respective documentation for the specific configuration options.

**Q: Is it possible to add request/response transformation or middleware?**
A: LiteLLM supports some preprocessing and postprocessing hooks. For more complex transformations, you might need to implement a custom middleware layer or use FreeLLMAPI's extension capabilities if available.

## Maintenance and Updates

**Q: How often should I update the components?**
A: Regularly check for updates, especially for security patches. A good practice is to check for updates weekly or whenever you encounter issues that might be related to outdated versions.

**Q: Will updating break my existing configuration?**
A: Minor updates typically maintain backward compatibility. Major version changes might require configuration adjustments. Always check the release notes before updating.

**Q: How do I backup and restore my configuration?**
A: Simply backup your configuration files:

- `litellm-config.yaml`
- `.fcc_env.example` or equivalent environment variable setup
- Any custom scripts or additional configuration files

**Q: Can I run multiple instances of this setup for different projects?**
A: Yes, by using different ports or separate environments for each instance. Ensure that each service instance uses unique ports to avoid conflicts.
