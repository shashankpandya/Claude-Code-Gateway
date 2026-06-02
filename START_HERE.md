# Start Here

Welcome to the Claude Code with FreeLLMAPI + LiteLLM Compatibility Bridge repository! This guide will help you get started.

## Prerequisites

1. **Install Python and Node.js:**
   - Ensure you have Python and Node.js installed on your system.

2. **Clone the Repository:**
   - Clone this repository to your local machine.

```powershell
cd C:\Users\admin
git clone <repository-url> claudeCodeSetupWithfreellmapi
cd claudeCodeSetupWithfreellmapi
```

## Installation

1. **Start FreeLLMAPI:**
   - Run the FreeLLMAPI server using the provided script.

```powershell
.\examples\start-freellmapi.ps1
```

2. **Start LiteLLM:**
   - Configure LiteLLM using the provided configuration file.
   - Start the LiteLLM server.

```powershell
.\examples\start-litellm.ps1
```

3. **Start Claude Code:**
   - Set the necessary environment variables.
   - Start Claude Code.

```powershell
.\examples\start-claude.ps1
```

## Validation

To validate that everything is working correctly, run the provided test prompts and observe the logs.

For more details, see the [Start Here Guide](START_HERE.md).