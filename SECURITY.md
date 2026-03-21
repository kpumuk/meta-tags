# Security Policy

## Supported Versions

Security fixes are provided for the latest released version of `meta-tags`.

Older releases may not receive security updates. If you are reporting a vulnerability, please confirm whether it affects the latest release.

## Reporting a Vulnerability

Please do not report security issues through public GitHub issues, discussions, or pull requests.

Use GitHub's private vulnerability reporting feature in the repository's `Security` tab to report a vulnerability.

If private reporting through GitHub is unavailable for any reason, send a report by email to `kpumuk@kpumuk.info` with `SECURITY` in the subject line.

When possible, include:

- a short description of the issue
- the affected version, commit, or tag
- any required environment or configuration details
- step-by-step reproduction instructions
- proof-of-concept code, logs, or screenshots
- an explanation of the likely impact

## Disclosure Policy

Please allow a reasonable amount of time to investigate and prepare a fix before making the issue public.

If the report is confirmed, the fix will be released as soon as practical. Public disclosure will generally happen through a GitHub security advisory and/or release notes after a fix is available.

## Scope Notes

`meta-tags` is a Ruby gem for Rails applications that renders HTML metadata such as titles, descriptions, canonical links, robots directives, and social tags.

Some behavior may depend on the host Rails application, layouts, templates, framework version, gem version, or deployment/runtime configuration. If a report depends on a specific setup, include those details.

## Response Expectations

This is a single-maintainer project, so response times may vary. Good-faith reports are appreciated, and I will try to acknowledge valid reports as quickly as practical.
