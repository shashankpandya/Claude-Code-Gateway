# Common Errors Navigation Guide

This document serves as a centralized hub for finding solutions to common errors and issues encountered while working with Claude Code, FreeLLMAPI, and LiteLLM.

## Quick Navigation

### Error Categories

- **Troubleshooting Guide**: General troubleshooting steps and solutions
- **FAQ**: Frequently asked questions and answers
- **Docs Troubleshooting**: Platform-specific troubleshooting guides

## Resources

### 1. Main Troubleshooting Guide

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for:

- UV version and installation issues
- PATH conflicts and environment setup problems
- Service-specific errors (FreeLLMAPI, LiteLLM, Claude Code)
- Port conflicts and connectivity issues
- API key and authentication problems
- Proxy configuration issues
- Model-specific errors

### 2. Frequently Asked Questions

See [FAQ.md](FAQ.md) for:

- General setup questions
- Configuration questions
- Compatibility questions
- Performance and optimization questions
- Contributing and development questions

### 3. Platform-Specific Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for:

- Linux-specific issues
- macOS-specific issues
- Windows-specific issues

## Error Search

### Common Error Patterns

**Installation and Setup Errors**

- UV version mismatches
- Missing dependencies
- Environment variable issues
- PORT conflicts

**Configuration Errors**

- Invalid YAML syntax
- Incorrect model mappings
- API key problems
- Base URL misconfigurations

**Runtime Errors**

- Connection refused
- Timeout errors
- 404 errors
- Authentication failures

**Model Routing Errors**

- Model not found
- Unsupported parameters
- Provider pool issues
- Load balancing problems

## How to Use This Guide

1. **Identify your error**: Look for error messages or symptoms
2. **Search by category**: Use the sections above to find relevant documentation
3. **Read the appropriate guide**:
   - For general errors → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
   - For setup questions → [FAQ.md](FAQ.md)
   - For platform-specific issues → Platform docs
4. **Follow the solutions**: Each guide provides step-by-step fixes
5. **If unresolved**: Open an issue on GitHub with:
   - Error message (exact)
   - Steps to reproduce
   - Environment details (OS, versions)
   - Relevant logs

## Related Documentation

- [Architecture Guide](ARCHITECTURE.md) - System design and components
- [Configuration Guide](CONFIGURATION.md) - Detailed configuration instructions
- [Model Routing Guide](MODEL_ROUTING.md) - Model mapping and routing
- [Validation Guide](VALIDATION.md) - Testing and validation procedures

## Getting Help

If you cannot find your error in these guides:

1. Check the [FAQ](FAQ.md) for similar questions
2. Search [GitHub Issues](https://github.com/shashankpandya/claude-code-freellmapi/issues)
3. Open a new issue with detailed information
4. Join our [Community](COMMUNITY.md) for support

---

**Last Updated**: 2026
**Version**: 1.0
