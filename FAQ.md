# Frequently Asked Questions

This document answers common questions about setting up and using Claude Code with FreeLLMAPI and LiteLLM.

## General Questions

1. **What is this repository for?**
   - This repository provides a complete guide for setting up Claude Code with FreeLLMAPI and LiteLLM as a compatibility bridge to ensure smooth operation across different providers.

2. **Why do I need a compatibility layer?**
   - Claude Code expects Anthropic-compatible APIs, but many local providers only offer OpenAI-compatible APIs. The compatibility layer translates between these formats.

3. **What is the architecture of this setup?**
   - Claude Code → LiteLLM (compatibility bridge) → FreeLLMAPI (API gateway) → Provider Pool (local/remote models)

## Installation Questions

4. **What are the prerequisites for installation?**
   - Python 3.8+
   - Node.js 16+
   - Git
   - Basic command-line knowledge

5. **How do I install the prerequisites?**
   - Python: Download from https://www.python.org/downloads/
   - Node.js: Download from https://nodejs.org/
   - Git: Download from https://git-scm.com/downloads

6. **How do I start the installation process?**
   - Clone the repository: `git clone <repository-url>`
   - Install component dependencies per the guides (do NOT run `pip install -r requirements.txt` or `npm install` from the repository root):
     - FreeLLMAPI: follow [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md) and run `npm install` inside the FreeLLMAPI project if running locally.
     - LiteLLM: follow [LITELLM_CONFIG.md](LITELLM_CONFIG.md) and install dependencies inside the LiteLLM project (e.g. `pip install -r requirements.txt` in that repo).
   - Follow the setup guides in the `guides/` directory

## FreeLLMAPI Questions

7. **What is FreeLLMAPI?**
   - FreeLLMAPI is a server that provides an OpenAI-compatible API endpoint and forwards requests to a pool of providers.

8. **How do I start FreeLLMAPI?**
   - Run the FreeLLMAPI server using the provided script: `.\examples\start-freellmapi.ps1`

9. **What port does FreeLLMAPI run on?**
   - By default, FreeLLMAPI runs on port 8082, but this can be configured in the `.fcc_env.example` file.

10. **How do I configure FreeLLMAPI?**
    - Edit the `.fcc_env.example` file or set environment variables directly.

## LiteLLM Questions

11. **What is LiteLLM?**
    - LiteLLM is a compatibility bridge that translates requests from Claude Code (Anthropic format) to a format that FreeLLMAPI can understand (OpenAI format).

12. **How do I start LiteLLM?**
    - Configure LiteLLM using the provided configuration file and start the LiteLLM server: `.\examples\start-litellm.ps1`

13. **What port does LiteLLM run on?**
    - By default, LiteLLM runs on port 4000, but this can be configured in the `litellm-config.yaml` file.

14. **How do I configure LiteLLM?**
    - Edit the `litellm-config.yaml` file to adjust model mappings, API keys, and other settings.

## Claude Code Questions

15. **How do I configure Claude Code to work with this setup?**
    - Set the necessary environment variables: `ANTHROPIC_BASE_URL`, `ANTHROPIC_AUTH_TOKEN`, and `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`

16. **What environment variables do I need to set for Claude Code?**
    - `ANTHROPIC_BASE_URL=http://127.0.0.1:4000` (LiteLLM endpoint)
    - `ANTHROPIC_AUTH_TOKEN=YOUR_ANTHROPIC_AUTH_TOKEN` (API key placeholder)
    - `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1` (enables model discovery through gateway)

17. **How do I start Claude Code?**
    - After setting environment variables, start Claude Code: `.\examples\start-claude.ps1`

## Model Mapping Questions

18. **How does model mapping work in this setup?**
    - LiteLLM maps Claude-style model names (like `claude-opus-4-8`) to actual backend models (like `gpt-4o`) through its configuration.

19. **What are the default model mappings?**
    - `claude-opus-4-8` → `gpt-4o`
    - `claude-sonnet-4-0` → `gpt-4o-mini`
    - `claude-3-5-haiku` → `gpt-4o-mini`

20. **How do I customize model mappings?**
    - Edit the `model_list` section in `litellm-config.yaml` to change which backend models correspond to which Claude-style names.

## Security Questions

21. **How do I keep my API keys secure?**
    - Never commit real API keys to the repository. Use environment variables or `.env` files that are listed in `.gitignore`.

22. **What should I do if I accidentally commit an API key?**
    - Immediately revoke the key, remove it from the repository history, and replace it with a placeholder.

23. **Are the example configuration files safe to share?**
    - Yes, as long as they contain only placeholder values and no real API keys or secrets.

## Troubleshooting Questions

24. **Where can I find troubleshooting help?**
    - See the [Troubleshooting Guide](TROUBLESHOOTING.md) for solutions to common issues.

25. **What are the most common issues encountered?**
    - UV version conflicts, port conflicts, incorrect environment variables, and model mapping issues.

26. **How do I check if services are running correctly?**
    - Check the console output of each service and verify they're listening on their expected ports.
    - Use `Invoke-WebRequest` to test endpoints: `Invoke-WebRequest http://localhost:8082/health`

## Validation Questions

27. **How do I validate that my setup is working correctly?**
    - Run the test prompts in `examples\test-prompts.ps1` and verify you get expected responses.

28. **What test prompts are included for validation?**
    - Simple greetings, explanations, code generation, and reasoning tasks.

29. **What should I expect from a successful validation?**
    - Coherent, relevant responses from Claude Code for each test prompt.

## Advanced Questions

30. **Can I use this setup with other providers besides FreeLLMAPI?**
    - Yes, as long as they provide an OpenAI-compatible API endpoint.

31. **Can I add more providers to the FreeLLMAPI pool?**
    - Yes, by editing the provider pool configuration in FreeLLMAPI.

32. **How do I update the software components?**
    - Use `pip install --upgrade` for Python packages and `npm update` for Node.js packages.

33. **Is this setup suitable for production use?**
    - This setup is primarily designed for development and testing. For production, consider additional security measures and reliability enhancements.

34. **How do I contribute to this repository?**
    - See the [Contributing Guide](CONTRIBUTING.md) for detailed instructions on how to contribute.

35. **Where can I find more information about the individual components?**
    - Claude Code: https://github.com/anthropics/claude-code
    - FreeLLMAPI: https://github.com/freellmapi/freellmapi
    - LiteLLM: https://github.com/BerriAI/litellm
