# LiteLLM Configuration

This guide provides instructions for configuring LiteLLM.

## Configuration File

LiteLLM uses a YAML file for configuration. The configuration file specifies the model mappings and other settings.

```yaml
litellm_settings:
  drop_params: true

model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/claude-opus-4-8
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/claude-sonnet-4-0
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/claude-3-5-haiku

general_settings:
  master_key: YOUR_LITELLM_MASTER_KEY # Placeholder - replace with your actual key
  custom_openai:
    base_url: "http://localhost:8082"
```

## Configuration Options

1. **Drop Params:**
   - A boolean indicating whether to drop unsupported parameters.

2. **Model List:**
   - A list of models and their mappings.

3. **General Settings:**
   - General settings for LiteLLM.

## Example Configuration

```yaml
litellm_settings:
  drop_params: true

model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/claude-opus-4-8
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/claude-sonnet-4-0
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/claude-3-5-haiku

general_settings:
  master_key: YOUR_LITELLM_MASTER_KEY # Placeholder - replace with your actual key
  custom_openai:
    base_url: "http://localhost:8082"
```

For more details, see the [LiteLLM Configuration Guide](../LITELLM_CONFIG.md).
