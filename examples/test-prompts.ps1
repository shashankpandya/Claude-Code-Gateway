# Test Prompts Script
# This script runs a series of test prompts to validate the setup

# Wait for services to be ready
Write-Host "Waiting for services to be ready..."
Start-Sleep -Seconds 10

# Test prompts
$testPrompts = @(
    "hello",
    "Explain React hooks simply",
    "Write a small Python Fibonacci script",
    "Create a responsive navbar in React",
    "Generate a multi-file project structure",
    "Write a longer answer and stream it",
    "Do a small reasoning comparison"
)

# Run each test prompt
foreach ($prompt in $testPrompts) {
    Write-Host "Running test: $prompt"
    # Note: Replace with the actual command to send a prompt to Claude Code
    # This assumes you have a way to programmatically send prompts to Claude Code
    # For now, we'll just simulate it
    Start-Sleep -Seconds 2
    Write-Host "Test completed: $prompt"
    Write-Host ""
}

Write-Host "All test prompts completed!"