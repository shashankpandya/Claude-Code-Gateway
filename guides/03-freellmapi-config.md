# FreeLLMAPI Configuration

This guide provides instructions for configuring FreeLLMAPI.

## Configuration File

FreeLLMAPI uses a YAML file for configuration. The configuration file specifies the provider pool and other settings.

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

## Configuration Options

1. **Provider Pool:**
   - A list of providers to use for fulfilling requests.

2. **Port:**
   - The port number to use for the FreeLLMAPI server.

3. **Debug:**
   - A boolean indicating whether to enable debug mode.

## Example Configuration

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

For more details, see the [FreeLLMAPI Configuration Guide](../FREELLMAPI_CONFIG.md).
