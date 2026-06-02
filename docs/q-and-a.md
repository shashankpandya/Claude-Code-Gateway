# Q&A

This document provides a more detailed Q&A section covering various topics related to setting up and using the project.

## Installation

1. **What are the prerequisites for installation?**
   - You need Python and Node.js installed on your system.

2. **How do I start FreeLLMAPI?**
   - Run the FreeLLMAPI server using the provided script.

```powershell
.\examples\start-freellmapi.ps1
```

3. **How do I start LiteLLM?**
   - Configure LiteLLM using the provided configuration file and start the LiteLLM server.

```powershell
.\examples\start-litellm.ps1
```

## Configuration

1. **How do I configure LiteLLM?**
   - Use the provided configuration file and adjust the settings as needed.

2. **How do I set environment variables for Claude Code?**
   - Set the necessary environment variables using the provided script.

```powershell
.\examples\start-claude.ps1
```

## Troubleshooting

1. **What should I do if I encounter a UV version mismatch?**
   - Ensure you have the correct version of UV installed.

```powershell
pip install --upgrade uv
```

2. **How do I fix PATH conflicts?**
   - Update the PATH environment variable to include the correct paths.

```powershell
set PATH=%PATH%;C:\path\to\uv
```

For more details, see the [Q&A Guide](../Q_AND_A.md).