# Troubleshooting on Windows

This guide provides solutions to common issues you might encounter while setting up and running the project on Windows.

## Common Issues

1. **UV Version Mismatch:**
   - **Symptom:** Error messages indicating a version mismatch.
   - **Root Cause:** Multiple versions of UV installed.
   - **Fix:** Ensure you have the correct version of UV installed.
   - **Example Command:** `pip install --upgrade uv`

2. **Multiple UV Installations:**
   - **Symptom:** Conflicts between multiple UV installations.
   - **Root Cause:** Multiple versions of UV installed.
   - **Fix:** Uninstall conflicting versions and install the correct one.
   - **Example Command:** `pip uninstall uv`

3. **PATH Conflicts:**
   - **Symptom:** Commands not found or conflicts.
   - **Root Cause:** PATH environment variable conflicts.
   - **Fix:** Update the PATH environment variable to include the correct paths.
   - **Example Command:** `set PATH=%PATH%;C:\path\to\uv`

4. **fcc-server Not Found:**
   - **Symptom:** Error messages indicating that fcc-server is not found.
   - **Root Cause:** fcc-server not installed or not in PATH.
   - **Fix:** Install fcc-server and ensure it is in PATH.
   - **Example Command:** `npm install -g fcc-server`

5. **Port 8082 Already in Use:**
   - **Symptom:** Error messages indicating that port 8082 is already in use.
   - **Root Cause:** Another service is using port 8082.
   - **Fix:** Stop the conflicting service or use a different port.
   - **Example Command:** `netstat -ano | findstr :8082`

6. **NVIDIA_NIM_API_KEY Errors:**
   - **Symptom:** Error messages related to NVIDIA_NIM_API_KEY.
   - **Root Cause:** Incorrect or missing API key.
   - **Fix:** Ensure the API key is correctly set in the environment variables.
   - **Example Command:** `set NVIDIA_NIM_API_KEY=your_api_key`

For more details, see the [Troubleshooting Guide](../TROUBLESHOOTING.md).