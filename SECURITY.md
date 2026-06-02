# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it by opening an issue on GitHub. Include as much detail as possible, such as steps to reproduce the vulnerability, expected behavior, and actual behavior.

## Security Guidelines

1. **Never Commit Real API Keys:**
   - Never commit real API keys or sensitive information to the repository. Use environment variables or configuration files to store sensitive information.

2. **Use .env or Environment Variables:**
   - Use `.env` files or environment variables to store sensitive information.

3. **Rotate Exposed Secrets Immediately:**
   - If a secret is exposed, rotate it immediately.

4. **Add .gitignore Requirements:**
   - Ensure that `.env` files and other sensitive files are included in `.gitignore`.

5. **What to Do If a Key Was Leaked:**
   - If a key is leaked, rotate it immediately and update any affected systems.

6. **Safe Sharing Practices for Sample Configs:**
   - When sharing sample configurations, use placeholder values for sensitive information.

7. **Warning Against Exposing Local Ports Publicly:**
   - Do not expose local ports publicly. Use firewalls and other security measures to protect your system.