# Model Routing Guide

This document provides a detailed explanation of model routing and how to configure it in the Claude Code with FreeLLMAPI + LiteLLM setup.

## Overview

Model routing is a critical aspect of the compatibility layer that maps between Claude-style model names and actual backend models. This ensures that requests from Claude Code are properly routed to the appropriate models in the provider pool.

## Model Mapping Process

1. **Claude Code Request**: Sends a request with a specific model name (e.g., `claude-opus-4-8`)
2. **LiteLLM Translation**: Maps the model name to the appropriate backend model
3. **FreeLLMAPI Routing**: Forwards the request to the correct provider
4. **Provider Processing**: The actual model processes the request
5. **Response Flow**: The response follows the reverse path back to Claude Code

## Configuration Requirements

### 1. LiteLLM Configuration

The primary configuration for model routing is done in the `litellm-config.yaml` file. Here's a detailed breakdown:

```yaml
litellm_settings:
  drop_params: true # Critical for filtering unsupported parameters

model_list:
  # Mapping for Claude Opus model
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY" # Placeholder - replace with your actual key

  # Mapping for Claude Sonnet model
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/gpt-4o-mini
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY" # Placeholder - replace with your actual key

  # Mapping for Claude Haiku model
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/gpt-4o-mini
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY" # Placeholder - replace with your actual key

  # Additional mappings for older model versions
  - model_name: claude-3-haiku-20240307
    litellm_params:
      model: custom_openai/gpt-3.5-turbo
      api_base: "http://localhost:8082"
      api_key: "YOUR_FREELLMAPI_API_KEY" # Placeholder - replace with your actual key

general_settings:
  master_key: "YOUR_LITELLM_MASTER_KEY" # Placeholder - replace with your actual key
  custom_openai:
    base_url: "http://localhost:8082"
    api_key: "YOUR_FREELLMAPI_API_KEY" # Placeholder - replace with your actual key
```

### 2. FreeLLMAPI Configuration

FreeLLMAPI also plays a role in model routing by managing the provider pool. Ensure that your FreeLLMAPI configuration includes all the providers you want to use:

```yaml
provider_pool:
  - name: local_model
    base_url: "http://localhost:5000"
  - name: remote_model
    base_url: "https://api.example.com"

settings:
  port: 8082
  debug: true
```

## Model Mapping Best Practices

1. **Consistent Naming**: Use consistent naming conventions for model names across all components.
2. **Comprehensive Coverage**: Ensure all models you want to support are properly mapped.
3. **Parameter Filtering**: Always set `drop_params: true` to filter out unsupported parameters.
4. **API Key Security**: Never commit real API keys to version control. Use environment variables or secure vault solutions.
5. **Health Checks**: Regularly verify that all mapped models are healthy and accessible.
6. **Documentation**: Keep your model mapping documentation up to date as you add or modify mappings.

## Troubleshooting Model Routing Issues

If you encounter issues with model routing:

1. **Verify Configuration**: Check that all model mappings are correct in `litellm-config.yaml`.
2. **Check Logs**: Examine logs from LiteLLM and FreeLLMAPI for routing errors.
3. **Test Endpoints**: Manually test the endpoints for each provider to ensure they're accessible.
4. **Parameter Validation**: Ensure that parameter filtering is properly configured to handle unsupported parameters.
5. **Model Discovery**: Verify that model discovery is properly configured in Claude Code.

## Advanced Model Routing

For more advanced scenarios, you can:

1. **Dynamic Routing**: Implement dynamic routing based on load or availability.
2. **Fallback Models**: Configure fallback models in case primary models are unavailable.
3. **Load Balancing**: Implement load balancing strategies for high-traffic models.
4. **Custom Middleware**: Add custom middleware for specialized routing needs.

For more details on advanced model routing, see the [Advanced Configuration Guide](ADVANCED_CONFIGURATION.md).
