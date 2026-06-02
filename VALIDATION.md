# Validation Guide

This guide provides instructions on how to validate that your setup is working correctly.

## Test Prompts

### 1. Basic Greeting
- **Prompt:** "hello"\n- **Expected Response:** A friendly greeting from Claude Code
- **Verification:**
  - Should respond with a simple greeting like "Hello! How can I assist you today?"
  - Should not contain errors or unexpected formatting
- **Logs to Check:**
  - FreeLLMAPI should show a successful request to /v1/chat/completions
  - LiteLLM should show the request being translated and forwarded

### 2. Simple Explanation
- **Prompt:** "Explain React hooks simply"
- **Expected Response:** A concise explanation of React hooks
- **Verification:**
  - Should explain hooks in simple terms without technical jargon
  - Should cover at least useState, useEffect, and useContext
  - Should be clear and easy to understand
- **Logs to Check:**
  - FreeLLMAPI should show the request being processed
  - LiteLLM should show the request being translated

### 3. Code Generation
- **Prompt:** "Write a small Python Fibonacci script"
- **Expected Response:** A working Python Fibonacci script
- **Verification:**
  - Should provide a complete, working script
  - Should include comments explaining the code
  - Should handle edge cases (like negative numbers)
- **Logs to Check:**
  - FreeLLMAPI should show the request being processed
  - LiteLLM should show the request being translated

### 4. Frontend Component
- **Prompt:** "Create a responsive navbar in React"
- **Expected Response:** A React component for a responsive navbar
- **Verification:**
  - Should include complete component code
  - Should include CSS for responsiveness
  - Should handle mobile and desktop views
- **Logs to Check:**
  - FreeLLMAPI should show the request being processed
  - LiteLLM should show the request being translated

### 5. Project Structure
- **Prompt:** "Generate a multi-file project structure"
- **Expected Response:** A project structure with multiple files
- **Verification:**
  - Should provide a clear directory structure
  - Should include at least 3-5 files with appropriate content
  - Should be logically organized
- **Logs to Check:**
  - FreeLLMAPI should show the request being processed
  - LiteLLM should show the request being translated

### 6. Streaming Response
- **Prompt:** "Write a longer answer and stream it"
- **Expected Response:** A longer answer streamed in chunks
- **Verification:**
  - Should provide a complete answer
  - Should show streaming behavior (content appears gradually)
  - Should not contain errors or interruptions
- **Logs to Check:**
  - FreeLLMAPI should show streaming response
  - LiteLLM should show streaming being handled

### 7. Reasoning Task
- **Prompt:** "Do a small reasoning comparison"
- **Expected Response:** A comparison of reasoning capabilities
- **Verification:**
  - Should provide a clear comparison between different approaches
  - Should explain the reasoning behind the comparison
  - Should be logical and well-structured
- **Logs to Check:**
  - FreeLLMAPI should show the request being processed
  - LiteLLM should show the request being translated

## Log Verification

### FreeLLMAPI Logs
- Check for successful request processing
- Verify that requests are being forwarded to the correct provider
- Look for any error messages or warnings
- Check that the response format matches expectations

### LiteLLM Logs
- Verify that requests are being properly translated
- Check that parameters are being correctly filtered or transformed
- Look for any translation errors or warnings
- Verify that responses are being correctly formatted

## Validation Script

For automated validation, you can use the provided test-prompts.ps1 script:

```powershell
.\examples\test-prompts.ps1
```

This script runs through all the test prompts and provides a summary of results.

## Success Indicators

1. All test prompts receive appropriate responses without errors
2. Logs show proper request processing and translation
3. No unexpected behavior or errors in the services
4. The test-prompts.ps1 script completes successfully without errors

## Troubleshooting

If validation fails:
1. Check the logs for specific error messages
2. Verify all services are running and accessible
3. Ensure configuration files are properly set up
4. Check network connectivity between services
5. Refer to the [Troubleshooting Guide](TROUBLESHOOTING.md) for specific solutions

## Next Steps

After successful validation:
1. Proceed with your development work
2. Monitor performance and logs for any issues
3. Regularly run validation tests to ensure stability
4. Keep your components updated for security and performance improvements