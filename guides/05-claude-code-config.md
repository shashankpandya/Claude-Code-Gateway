# Claude Code Configuration

This guide provides instructions for configuring Claude Code.

## Configuration File

Claude Code uses a YAML file for configuration. The configuration file specifies the API URL and other settings.

```yaml
api:
  auth_token: "your_api_key"
  base_url: "http://localhost:8082"

settings:
  debug: true
```

## Configuration Options

1. **Auth Token:**
   - The authentication token for the API.

2. **Base URL:**
   - The base URL for the API.

3. **Debug:**
   - A boolean indicating whether to enable debug mode.

## Example Configuration

```yaml
api:
  auth_token: "your_api_key"
  base_url: "http://localhost:8082"

settings:
  debug: true
```

For more details, see the [Claude Code Configuration Guide](../CLAUDE_CODE_CONFIG.md).
