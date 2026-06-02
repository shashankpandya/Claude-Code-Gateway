# Installation on Windows

This guide provides step-by-step instructions for installing the project on Windows.

## Prerequisites

Ensure you have the following installed:

1. **Python** (Version 3.8 or higher)
2. **Node.js** (Version 16 or higher)
3. **Git** (Version 2.30 or higher)

## Installation Steps

1. **Clone the Repository:**
   - Open PowerShell and run:

```powershell
cd C:\Users\admin
git clone <repository-url> claudeCodeSetupWithfreellmapi
cd claudeCodeSetupWithfreellmapi
```

2. **Install Dependencies:**
   - Install dependencies (component-specific):

   Install dependencies inside each component's repository rather than from this repository root. For example:

   ```powershell
   # FreeLLMAPI
   cd C:\path\to\freellmapi
   npm install

   # LiteLLM
   cd C:\path\to\litellm
   pip install -r requirements.txt
   ```

3. **Start FreeLLMAPI:**
   - Run the FreeLLMAPI server using the provided script:

```powershell
.\examples\start-freellmapi.ps1
```

4. **Start LiteLLM:**
   - Configure LiteLLM using the provided configuration file.
   - Start the LiteLLM server:

```powershell
.\examples\start-litellm.ps1
```

5. **Start Claude Code:**
   - Set the necessary environment variables.
   - Start Claude Code:

```powershell
.\examples\start-claude.ps1
```

## Validation

To validate that everything is working correctly, run the provided test prompts and observe the logs.

For more details, see the [Validation Guide](../VALIDATION.md).
