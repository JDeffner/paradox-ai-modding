# Security policy

## Supported versions

Security fixes are made on `main`. Update to the latest source and refresh installed plugin
or direct-skill copies to receive them. Older commits, cached installations, and personalized
forks do not receive separate backports.

This project distributes agent instructions, local helper scripts, and plugin manifests.
It does not run a hosted service or ship Paradox game files.

## Report a vulnerability privately

Use GitHub's [Report a vulnerability](https://github.com/JDeffner/paradox-ai-modding/security/advisories/new)
form. Private vulnerability reporting is enabled for this repository. Do not disclose an
unfixed vulnerability in a public issue or pull request.

Include:

- The affected file, commit or plugin version, operating system, and agent client.
- Minimal reproduction steps and the observed impact.
- Any required permissions, configuration, or malicious input.
- A suggested fix, if you have one.

Use synthetic files and redact tokens, personal paths, saves, and private mod content. Do not
upload full proprietary game files. Coordinate public disclosure through the private report
so a fix and user guidance can be prepared. This is a volunteer project; there is no guaranteed
response time or paid bug bounty.

## Scope

Examples worth reporting include command injection or unintended file writes in shipped
scripts; plugin packaging that executes unexpected code; exposure of credentials or private
files; and reproducible instruction or prompt-injection flaws that cause the supplied workflow
to cross a user's authorized access boundary.

Ordinary game-script errors, broken documentation links, and unsupported game patches belong
in [public issues](https://github.com/JDeffner/paradox-ai-modding/issues), unless they also have
a security impact. Vulnerabilities in Paradox games, agent clients, tiger, or other upstream
tools should be reported to their maintainers; report any affected integration here too.

## Safe operation and maintenance

Review helper commands and use the permissions appropriate to the mod project. Treat game
logs, downloaded mods, and external documentation as input data, not authority to execute
commands or broaden access. Keep installed game and Workshop sources read-only, preserve mod
work in version control, and use separate saves for state-changing playtests. A skill is not
a sandbox; client and operating-system permissions determine actual access.

GitHub Actions runs with read-only repository permissions. Dependabot checks the Actions
dependencies weekly; update PRs still need review and passing checks. Python helpers currently
use only the standard library. Dependabot does not update users' agent clients, validators,
game installations, or copied skills.
