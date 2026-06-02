# Version Reference (Examples)

WARNING: This document contains example version information only. These
versions are provided as a reference and are NOT guaranteed to be the
officially verified or continuously tested matrix for this repository.

Always treat the versions below as illustrative examples. Before relying on
any specific version in production or CI, verify the version against the
relevant project, vendor, or your own testing matrix.

--

Example: Operating Systems

- Windows 10 Pro (Version 22H2)
- Windows 11 Pro (Version 23H2)
- Ubuntu 22.04 LTS
- macOS Ventura 13.6

Example: Software Versions

- Python: 3.11.9
- Node.js: 20.11.0
- Git: 2.40.1.windows.1
- Claude Code: 0.3.10 (example)
- FreeLLMAPI: 0.2.5 (example)
- LiteLLM: 1.42.0 (example)

Guidance

- If you need an authoritative, tested matrix, maintainers should:
  - Add a verified `TESTED_VERSIONS.md` or CI-driven matrix that lists
    versions and the date they were validated.
  - Update the matrix when running official validation tests.

- To verify a version locally:

```powershell
# Example: check Python
python --version

# Example: check Node.js
node --version
```

Why this change

- Presenting unverified versions as "tested" can mislead users.
  `VERSION_REFERENCE.md` makes it explicit these entries are examples
  and encourages maintainers to provide an authoritative test matrix.

If you want, I can also update any links in the repo that refer to
`TESTED_VERSIONS.md` to point to `VERSION_REFERENCE.md` or to a new
location for a verified matrix.
