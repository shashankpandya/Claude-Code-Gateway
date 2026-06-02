# Advanced Configuration Guide

This guide covers advanced scenarios, model routing architecture, and custom configurations beyond the basic setup.

## Table of Contents

1. [Overview](#overview)
2. [Model Routing Flow](#model-routing-flow)
3. [Claude Model Mapping](#claude-model-mapping)
4. [LiteLLM Translation Layer](#litellm-translation-layer)
5. [custom_openai Explanation](#custom_openai-explanation)
6. [Backend Provider Routing](#backend-provider-routing)
7. [Architecture Diagrams](#architecture-diagrams)
8. [Advanced Scenarios](#advanced-scenarios)
9. [Custom Implementations](#custom-implementations)

## Overview

This guide explains the complete flow of how requests move through the system, from Claude Code all the way to backend providers and back.

### Key Concepts

1. **Model Routing**: How Claude-style models are mapped to backend models
2. **Translation Layer**: How Anthropic-format requests become OpenAI-format requests
3. **Provider Routing**: How requests are distributed across providers
4. **Response Translation**: How responses are translated back to Anthropic format

## Model Routing Flow

### Complete Request/Response Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                    USER REQUEST FLOW                           │
│                                                                 │
│  1. Claude Code User Input                                     │
│     └─ Model: "claude-opus-4-8"                               │
│     └─ Message: "Your prompt here"                            │
│     └─ Format: Anthropic API format                           │
│                                                                 │
│  2. HTTP Request to LiteLLM                                   │
│     POST http://127.0.0.1:4000/v1/messages                   │
│     └─ Headers: Authorization, Content-Type                   │
│     └─ Body: {model, messages, temperature, ...}              │
│                                                                 │
│  3. LiteLLM Processing                                        │
│     ├─ Parse Anthropic-format request                        │
│     ├─ Look up model in config (claude-opus-4-8)             │
│     ├─ Filter unsupported parameters (drop_params: true)     │
│     ├─ Translate to OpenAI format                            │
│     └─ Prepare custom_openai parameters                       │
│                                                                 │
│  4. HTTP Request to FreeLLMAPI                                │
│     POST http://localhost:8082/v1/chat/completions           │
│     └─ Model: "gpt-4o" (mapped from claude-opus-4-8)        │
│     └─ Format: OpenAI API format                              │
│                                                                 │
│  5. FreeLLMAPI Routing                                        │
│     ├─ Select provider from pool                              │
│     ├─ Load balance across healthy providers                  │
│     └─ Forward request to selected provider                   │
│                                                                 │
│  6. Backend Provider Processing                               │
│     ├─ Receive request                                        │
│     ├─ Generate response                                      │
│     └─ Return completion                                      │
│                                                                 │
│  7. Response Back Through FreeLLMAPI                          │
│     ├─ Format response                                        │
│     └─ Return to LiteLLM                                      │
│                                                                 │
│  8. LiteLLM Translation (Response)                            │
│     ├─ Parse OpenAI-format response                          │
│     ├─ Translate to Anthropic format                         │
│     └─ Return to Claude Code                                  │
│                                                                 │
│  9. Claude Code Display                                       │
│     └─ Show response to user                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Claude Model Mapping

### Standard Model Mappings

The standard mappings between Claude models and OpenAI-compatible backends:

```yaml
# Current Generation (Claude 4)
claude-opus-4-8
  └─> gpt-4o (most capable)
  └─> Local: neural-chat-7b, Mistral Large

claude-sonnet-4-0
  └─> gpt-4o-mini (balanced)
  └─> Local: Mistral Medium, Dolphin 2.7

claude-3-5-haiku
  └─> gpt-3.5-turbo (fast, small)
  └─> Local: Phi-3, TinyLlama

# Previous Generation (Claude 3)
claude-3-opus-20240229
  └─> gpt-4 (OpenAI-compatible)

claude-3-sonnet-20240229
  └─> gpt-4-turbo

claude-3-haiku-20240307
  └─> gpt-3.5-turbo
```

### Custom Model Mappings

Create custom mappings for your specific needs:

```yaml
model_list:
  # Map to local models
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/neural-chat:7b
      api_base: "http://localhost:8000" # LM Studio
      timeout: 180

  # Map to multiple backends with fallback
  - model_name: claude-opus-4-8-backup
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082" # FreeLLMAPI

  # Map to specialized models
  - model_name: claude-opus-coding
    litellm_params:
      model: custom_openai/deepseek-coder
      api_base: "http://localhost:9000"

  - model_name: claude-sonnet-fast
    litellm_params:
      model: custom_openai/dolphin:2.7
      api_base: "http://localhost:8000"
```

### Model Capability Tiers

```
TIER 1 (Maximum Capability)
├─ claude-opus-4-8
├─ gpt-4o
├─ Local: Neural-Chat 7B, Mistral Large
└─ Use for: Complex reasoning, long context, creative work

TIER 2 (Balanced)
├─ claude-sonnet-4-0
├─ gpt-4o-mini
├─ Local: Mistral Medium, Dolphin 2.7
└─ Use for: General purpose, balanced speed/capability

TIER 3 (Speed Optimized)
├─ claude-3-5-haiku
├─ gpt-3.5-turbo
├─ Local: Phi-3, TinyLlama
└─ Use for: Fast responses, simple tasks, cost-effective
```

## LiteLLM Translation Layer

### Request Translation Process

```python
# Input from Claude Code (Anthropic format)
request_anthropic = {
    "model": "claude-opus-4-8",
    "messages": [
        {"role": "user", "content": "What is 2+2?"}
    ],
    "max_tokens": 1024,
    "temperature": 0.8,
    "top_k": 40,           # Anthropic-specific
    "top_p": 0.95,
    "stop_sequences": ["---"]
}

# LiteLLM processes through litellm-config.yaml:
# 1. Look up model mapping:
#    claude-opus-4-8 -> custom_openai/gpt-4o
# 2. Apply drop_params: true
#    Removes: top_k (no OpenAI equivalent)
# 3. Translate parameter names:
#    max_tokens_to_sample -> max_tokens
# 4. Convert stop sequences:
#    stop_sequences -> stop (array)

# Output to FreeLLMAPI (OpenAI format)
request_openai = {
    "model": "gpt-4o",
    "messages": [
        {"role": "user", "content": "What is 2+2?"}
    ],
    "max_tokens": 1024,
    "temperature": 0.8,
    "top_p": 0.95,
    "stop": ["---"]
    # top_k removed (unsupported)
}
```

### Parameter Handling

```yaml
# Parameters that survive drop_params filter
preserved_parameters:
  - messages # Core parameter
  - temperature # Scaling differs but preserved
  - top_p # Preserved
  - max_tokens # Renamed from max_tokens_to_sample
  - stop # Renamed from stop_sequences
  - system # Converted from system_prompt

# Parameters that are dropped
dropped_parameters:
  - top_k # No OpenAI equivalent
  - anthropic_version # Anthropic-specific
  - metadata # Implementation specific
  - tools # Different structure
  - tool_choice # Different structure
```

## custom_openai Explanation

### Architecture Role

```
┌──────────────────────────────────────────────────────────┐
│                    LiteLLM                              │
│  ┌────────────────────────────────────────────────────┐ │
│  │        Model Lookup & Translation                  │ │
│  │  anthropic format → openai format                  │ │
│  └────────────────────────────────────────────────────┘ │
│                        ↓                                 │
│  ┌────────────────────────────────────────────────────┐ │
│  │       custom_openai Provider Plugin               │ │
│  │  • Handles OpenAI-compatible protocol             │ │
│  │  • Manages authentication                         │ │
│  │  • Routes to custom base URL                      │ │
│  └────────────────────────────────────────────────────┘ │
│                        ↓                                 │
│       HTTP Request to FreeLLMAPI (8082)               │
│                                                         │
└──────────────────────────────────────────────────────────┘
```

### Configuration Parameters

```yaml
general_settings:
  custom_openai:
    base_url: "http://localhost:8082" # Where to send requests
    api_key: "YOUR_FREELLMAPI_API_KEY" # Authentication
    organization: "my-org" # Optional tenant/org
    api_version: "v1" # API version
    headers: # Custom headers
      X-Custom-Header: "value"
    timeout: 120 # Request timeout
    retry_count: 3 # Retry attempts
    backoff_factor: 2 # Exponential backoff
```

### Request Flow Through custom_openai

```
┌─ LiteLLM decides to use custom_openai provider ─┐
│                                                 │
├─ Retrieve configuration:                       │
│  • base_url = "http://localhost:8082"         │
│  • api_key = "YOUR_FREELLMAPI_API_KEY"                        │
│  • timeout = 120s                             │
│                                                │
├─ Construct HTTP request:                      │
│  • URL: base_url + "/v1/chat/completions"    │
│  • Method: POST                               │
│  • Headers:                                   │
│    - Authorization: "Bearer YOUR_FREELLMAPI_API_KEY"         │
│    - Content-Type: "application/json"        │
│                                                │
├─ Send request to FreeLLMAPI                  │
│                                                │
├─ FreeLLMAPI:                                  │
│  • Receives OpenAI-format request            │
│  • Routes to provider in pool                │
│  • Returns OpenAI-format response            │
│                                                │
├─ custom_openai receives response             │
│                                                │
└─ Response returned to LiteLLM                │
```

### Error Handling

```yaml
# Retry configuration for custom_openai
custom_openai:
  base_url: "http://localhost:8082"
  retry_count: 3 # Retry 3 times on failure
  backoff_factor: 2 # Wait 2s, 4s, 8s between retries
  retry_on_status: [408, 429, 500, 502, 503, 504]
  timeout: 120 # Don't wait more than 120s
```

## Backend Provider Routing

### Provider Pool Architecture

```yaml
provider_pool:
  # Provider 1: LM Studio (Local)
  - name: lm_studio
    base_url: "http://localhost:8000"
    provider_type: "local"
    health_check_interval: 30
    timeout: 60
    priority: 1 # Higher priority
    enabled: true

  # Provider 2: Ollama (Local)
  - name: ollama
    base_url: "http://localhost:11434"
    provider_type: "local"
    health_check_interval: 30
    timeout: 60
    priority: 2 # Lower priority than LM Studio
    enabled: true

  # Provider 3: OpenAI (Remote)
  - name: openai
    base_url: "https://api.openai.com/v1"
    provider_type: "remote"
    api_key: "${OPENAI_API_KEY}"
    timeout: 120
    priority: 3 # Fallback
    enabled: true
```

### Load Balancing Strategies

```yaml
# Strategy 1: Round Robin (Default)
load_balancing:
  strategy: "round_robin"
  # Distributes requests evenly across all providers

# Strategy 2: Least Loaded
load_balancing:
  strategy: "least_loaded"
  # Sends requests to provider with fewest active connections

# Strategy 3: Random
load_balancing:
  strategy: "random"
  # Random provider selection

# Strategy 4: Weighted
load_balancing:
  strategy: "weighted"
  weights:
    lm_studio: 2.0    # 50% of traffic
    ollama: 1.0       # 25% of traffic
    openai: 1.0       # 25% of traffic
```

### Health Checking and Failover

```
Request arrives at FreeLLMAPI
        ↓
Check provider health status
        ↓
Is preferred provider healthy?
    Yes ↓                  No ↓
Route to              Check next provider
provider 1                  ↓
    ↓              Is backup provider healthy?
Request sent         Yes ↓              No ↓
                Route to          All providers down
                provider 2         ↓
                    ↓         Queue request or
                Request sent   fail gracefully
```

## Architecture Diagrams

### Complete System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  Claude Code                        │   │
│  │  (User-facing application)                         │   │
│  │                                                     │   │
│  │  Environment Variables:                            │   │
│  │  • ANTHROPIC_BASE_URL=http://127.0.0.1:4000      │   │
│  │  • ANTHROPIC_AUTH_TOKEN=YOUR_ANTHROPIC_AUTH_TOKEN  │   │
│  │  • CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1   │   │
│  └─────────────────────────────────────────────────────┘   │
│                         │                                   │
│                         │ Anthropic Format                 │
│                         ↓                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              LiteLLM (Port 4000)                    │   │
│  │  • Model mapping                                   │   │
│  │  • Request translation                            │   │
│  │  • Parameter filtering                            │   │
│  │  • Response translation                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                         │                                   │
│                         │ OpenAI Format                    │
│                         ↓                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           FreeLLMAPI (Port 8082)                    │   │
│  │  • Provider pool management                        │   │
│  │  • Load balancing                                  │   │
│  │  • Health monitoring                               │   │
│  └─────────────────────────────────────────────────────┘   │
│                         │                                   │
│              ┌──────────┼──────────┐                        │
│              ↓          ↓          ↓                        │
│        ┌──────────┐ ┌────────┐ ┌──────────┐               │
│        │LM Studio │ │Ollama  │ │OpenAI    │               │
│        │8000      │ │11434   │ │api.o.com │               │
│        └──────────┘ └────────┘ └──────────┘               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow Diagram

```
Claude Code Request
    │
    ├─ Parse Anthropic format
    ├─ Extract model name
    ├─ Extract messages
    └─ Extract parameters

    ↓ HTTP POST to http://127.0.0.1:4000/v1/messages

LiteLLM Configuration Lookup
    ├─ Find model_name in config
    ├─ Get backend model mapping
    ├─ Get api_base (FreeLLMAPI)
    └─ Get api_key

    ↓ Parameter Translation

Filter Parameters (drop_params: true)
    ├─ Keep: messages, temperature, top_p, max_tokens
    ├─ Drop: top_k, anthropic_version
    └─ Rename: max_tokens_to_sample → max_tokens

    ↓ Prepare custom_openai Request

custom_openai Provider
    ├─ Set base_url: http://localhost:8082
    ├─ Add Authorization header
    └─ POST to /v1/chat/completions

    ↓ HTTP POST to http://localhost:8082/v1/chat/completions

FreeLLMAPI Processing
    ├─ Receive OpenAI-format request
    ├─ Select provider from pool
    ├─ Load balance if needed
    └─ Forward to selected provider

    ↓ Request to Backend Provider

Backend Provider (LM Studio/Ollama/OpenAI)
    ├─ Receive request
    ├─ Process with model
    └─ Generate response

    ↓ Response through chain

Response flows back:
FreeLLMAPI → LiteLLM → Claude Code
    │
    ├─ Translate to Anthropic format
    └─ Display to user
```

## Advanced Scenarios

### Scenario 1: Multi-Provider Failover

```yaml
model_list:
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
      timeout: 120
      retry_count: 3
      fallback_provider: "claude-opus-4-8-local"

  - model_name: claude-opus-4-8-local
    litellm_params:
      model: custom_openai/neural-chat:7b
      api_base: "http://localhost:8000"
      timeout: 180
```

**Behavior**:

1. Try FreeLLMAPI (remote + local providers)
2. If timeout or error, fallback to local LM Studio
3. Retry up to 3 times
4. Fail if all attempts exhausted

### Scenario 2: Cost Optimization

```yaml
model_list:
  # Fast and cheap for simple tasks
  - model_name: claude-3-5-haiku
    litellm_params:
      model: custom_openai/gpt-3.5-turbo
      api_base: "http://localhost:8082"

  # Balanced cost/capability
  - model_name: claude-sonnet-4-0
    litellm_params:
      model: custom_openai/gpt-4o-mini
      api_base: "http://localhost:8082"

  # Premium for complex work
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"
```

**Usage**:

- Use `claude-3-5-haiku` for fast, simple tasks
- Use `claude-sonnet-4-0` for general work
- Use `claude-opus-4-8` only when needed

### Scenario 3: Specialized Models

```yaml
model_list:
  # General purpose
  - model_name: claude-opus-4-8
    litellm_params:
      model: custom_openai/gpt-4o
      api_base: "http://localhost:8082"

  # Code generation
  - model_name: claude-opus-coding
    litellm_params:
      model: custom_openai/deepseek-coder:33b
      api_base: "http://localhost:8000"

  # Math and reasoning
  - model_name: claude-opus-math
    litellm_params:
      model: custom_openai/openhermes-2-mistral:70b
      api_base: "http://localhost:8000"

  # Creative writing
  - model_name: claude-opus-creative
    litellm_params:
      model: custom_openai/neural-chat:7b
      api_base: "http://localhost:8000"
```

## Custom Implementations

### Custom Parameter Mapping

```python
# In your application, override parameter mapping
def custom_param_mapping(claude_params):
    """Custom mapping for specific needs"""
    openai_params = {}

    # Map standard parameters
    openai_params['messages'] = claude_params.get('messages')
    openai_params['temperature'] = claude_params.get('temperature', 0.7)
    openai_params['max_tokens'] = claude_params.get('max_tokens_to_sample')

    # Custom handling for top_k
    if 'top_k' in claude_params:
        # Convert top_k to top_p equivalent
        openai_params['top_p'] = convert_top_k_to_top_p(claude_params['top_k'])

    return openai_params
```

### Custom Provider Implementation

```yaml
# Add custom provider to FreeLLMAPI
provider_pool:
  - name: custom_provider
    base_url: "http://127.0.0.1:5000"
    provider_type: "custom"
    model_adapter: "my_custom_adapter.py"
    timeout: 180
```

## Related Documentation

- [MODEL_ROUTING.md](MODEL_ROUTING.md) - Model routing basics
- [CONFIGURATION.md](CONFIGURATION.md) - Basic configuration
- [LITELLM_CONFIG.md](LITELLM_CONFIG.md) - LiteLLM details
- [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md) - FreeLLMAPI details

---

**Last Updated**: 2026
**Version**: 1.0
