# FreeLLMAPI Setup

This document provides instructions for setting up FreeLLMAPI.

## Overview

FreeLLMAPI is a server that provides an OpenAI-style chat completions API. It forwards requests to a pool of providers.

## Installation

1. **Install FreeLLMAPI:**
   - Install FreeLLMAPI using the provided script.

```powershell
pip install freellmapi
```

2. **Start FreeLLMAPI Server:**
   - Start the FreeLLMAPI server using the provided script.

```powershell
Start-Process -FilePath "fcc-server" -ArgumentList "--port 8082"
```

## Configuration

FreeLLMAPI is configured using a YAML file. The configuration file specifies the provider pool and other settings.

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