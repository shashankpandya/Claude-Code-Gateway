# Maintenance

This guide provides instructions for maintaining the project.

## Updating Dependencies

1. **Update Python Packages:**
   - Update Python packages inside the relevant component repository (for example, LiteLLM):

```powershell
# In the LiteLLM repository
cd /path/to/litellm
pip install --upgrade -r requirements.txt
```

2. **Update Node.js Packages:**
   - Update Node.js packages inside the relevant component repository (for example, FreeLLMAPI):

```powershell
# In the FreeLLMAPI repository
cd /path/to/freellmapi
npm update
```

## Updating Configuration

1. **Update FreeLLMAPI Configuration:**
   - Update the FreeLLMAPI configuration file to reflect any changes.

2. **Update LiteLLM Configuration:**
   - Update the LiteLLM configuration file to reflect any changes.

3. **Update Claude Code Configuration:**
   - Update the Claude Code configuration file to reflect any changes.

## Restarting Services

1. **Restart FreeLLMAPI:**
   - Restart the FreeLLMAPI service after updating the configuration.

2. **Restart LiteLLM:**
   - Restart the LiteLLM service after updating the configuration.

3. **Restart Claude Code:**
   - Restart the Claude Code service after updating the configuration.

For more details, see the [Maintenance Guide](../MAINTENANCE.md).
