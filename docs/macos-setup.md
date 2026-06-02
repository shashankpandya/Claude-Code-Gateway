# macOS Setup

This document provides instructions for setting up the project on macOS.

## Prerequisites

1. **Install Python and Node.js:**
   - Ensure you have Python and Node.js installed on your system.

2. **Install Git:**
   - Ensure you have Git installed on your system.

## Installation

1. **Clone the Repository:**
   - Clone this repository to your local machine.

```bash
cd ~
git clone <repository-url> claudeCodeSetupWithfreellmapi
cd claudeCodeSetupWithfreellmapi
```

2. **Install dependencies (component-specific)**

Install dependencies inside each component's repository rather than from this repository root. For example:

```bash
# FreeLLMAPI
cd /path/to/freellmapi && npm install

# LiteLLM
cd /path/to/litellm && pip install -r requirements.txt
```

3. **Start FreeLLMAPI:**
   - Run the FreeLLMAPI server using the provided script.

```bash
./examples/start-freellmapi.sh
```

4. **Start LiteLLM:**
   - Configure LiteLLM using the provided configuration file.
   - Start the LiteLLM server.

```bash
./examples/start-litellm.sh
```

5. **Start Claude Code:**
   - Set the necessary environment variables.
   - Start Claude Code.

```bash
./examples/start-claude.sh
```

## Validation

To validate that everything is working correctly, run the provided test prompts and observe the logs.

For more details, see the [Validation Guide](../VALIDATION.md).
