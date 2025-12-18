# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of cellwrap library
- ANSI-aware word wrapping with escape sequence preservation
- Unicode/emoji support with proper cell width calculation
- Word boundary wrapping with configurable breakpoints
- Hard wrap fallback for long words
- 117 comprehensive parity tests matching Go implementation
- GitHub Actions CI/CD workflow
- Comprehensive documentation and examples

### Features
- `Cellwrap.wrap()` method for ANSI-aware text wrapping
- Support for ANSI SGR sequences (colors, styles)
- Support for OSC-8 hyperlinks
- Proper handling of Unicode grapheme clusters
- Custom breakpoint characters
- Preservation of tabs and existing newlines

## [0.1.0] - 2025-12-18

### Added
- Initial release
- Crystal port of charmbracelet/x/cellbuf.Wrap
- MIT license
- Complete documentation
- Example programs
- Code quality tools (ameba, formatter)
- GitHub Actions CI/CD pipeline