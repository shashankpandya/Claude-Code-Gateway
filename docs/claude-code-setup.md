# Claude Code Setup

This document provides instructions for setting up Claude Code.

## Overview

Claude Code is the main application that interacts with the user.

## Installation

1. **Set Environment Variables:**
   - Set the necessary environment variables for Claude Code.

```powershell
$env:ANTHROPIC_AUTH_TOKEN = "your_api_key"
$env:ANTHROPIC_BASE_URL = "http://127.0.0.1:4000"
```

2. **Start Claude Code:**
   - Start Claude Code using the provided script.

```powershell
Start-Process -FilePath "claude-code" -ArgumentList "--config claude-config.yaml"
```

## Configuration

Claude Code is configured using environment variables and a YAML file. The configuration file specifies the API URL and other settings.

```yaml
api:
  auth_token: "your_api_key"
  base_url: "http://localhost:8082"

settings:
  debug: true
```
