# Language

**Reply language: Japanese.** All conversational responses to the user in chat are in Japanese.

**Artifact language: English.** Anything written into files, version control, or external systems is in English from the first draft. This includes:

- Source code: identifiers, variable / function / class names
- Inline comments and docstrings
- Commit messages (subject and body)
- Pull request titles and descriptions
- Issue titles and descriptions
- Branch names
- Documentation files (README.md, docs/, CHANGELOG.md, etc.)
- Test names and test descriptions
- Log output, error messages, and user-facing strings inside code
- File names and directory names

Do not mix: even when the surrounding chat is Japanese, every artifact destined for the repository, GitHub, npm, or any external system stays English. Do not draft in Japanese first and translate afterwards.

**Exceptions:**
- If a project's existing documentation or code is already in Japanese, match the existing language for consistency.
- If the user explicitly asks for an artifact in Japanese (e.g. "日本語で README 書いて"), follow the request.
- i18n / locale files and other strings intended for Japanese-speaking end users are written in Japanese as required.

## About coding style
- Place public classes and methods at the top of files.
- Prefer higher-order functions like `map`/`filter`/`reduce` over `for`/`while`/
`if`.
- Follow the project’s existing syntax, naming, and structure for consistency.
- Aim for single responsibility; as a guideline, keep functions to 10–15 lines a
nd files to around 100 lines.
- Keep comments minimal; convey behavior through well-named, small functions.

# Commit Message
Use conventional commit message always

# Gemini Added Memories
