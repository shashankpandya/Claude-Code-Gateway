# Quick Start Guide

This guide will help you get started with setting up Claude Code with FreeLLMAPI and LiteLLM quickly.

## Prerequisites

1. **Install Python 3.8+ and Node.js 16+**:
   - Ensure you have Python and Node.js installed on your system.

2. **Install Git**:
   - Ensure you have Git installed on your system.

## Quick Setup

1. **Clone the Repository**:

   ```powershell
   git clone https://github.com/shashankpandya/claude-code-freellmapi.git
   cd claude-code-freellmapi
   ```

2. **Install Component Dependencies**:

   Install dependencies per component rather than from the repository root. Examples:

   ```powershell
   # FreeLLMAPI (if running locally)
   cd C:\path\to\freellmapi
   npm install

   # LiteLLM (if running locally)
   cd C:\path\to\litellm
   pip install -r requirements.txt
   ```

   See the component guides for details: [FREELLMAPI_CONFIG.md](FREELLMAPI_CONFIG.md), [LITELLM_CONFIG.md](LITELLM_CONFIG.md)

3. **Start All Services**:

   ```powershell
   .\examples\combined-startup.ps1
   ```

4. **Run Test Prompts**:
   ```powershell
   .\examples\test-prompts.ps1
   ```

For more detailed instructions, see the [Full Installation Guide](guides/02-installation-windows.md).
