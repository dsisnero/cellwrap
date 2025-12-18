# Contributing to Cellwrap

Thank you for your interest in contributing to Cellwrap! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/cellwrap.git
   cd cellwrap
   ```
3. Install dependencies:
   ```bash
   shards install
   ```

## Development Workflow

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Run quality checks:
   ```bash
   ./bin/check
   ```

4. Commit your changes with a descriptive message:
   ```bash
   git commit -m "Add feature: your feature description"
   ```

5. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

6. Create a Pull Request

## Code Style

- Follow Crystal's standard formatting:
  ```bash
  crystal tool format
  ```

- Run the linter before committing:
  ```bash
  ameba
  ```

- Write tests for new functionality
- Update documentation when adding or changing features
- Keep commits focused and atomic

## Testing

- Run all tests:
  ```bash
  crystal spec
  ```

- Run specific test file:
  ```bash
  crystal spec spec/cellwrap_spec.cr
  ```

- Run specific test:
  ```bash
  crystal spec spec/cellwrap_spec.cr:10
  ```

## Adding New Features

1. **Start with an issue**: Discuss the feature before implementing
2. **Write tests first**: Ensure your feature is testable
3. **Implement the feature**: Follow existing code patterns
4. **Update documentation**: Add examples and update README if needed
5. **Run all checks**: Ensure everything passes

## Bug Reports

When reporting bugs, please include:

1. Crystal version (`crystal --version`)
2. Steps to reproduce
3. Expected behavior
4. Actual behavior
5. Any relevant error messages or stack traces

## Pull Request Guidelines

- Keep PRs focused on a single feature or bug fix
- Include tests for new functionality
- Update documentation as needed
- Ensure all checks pass
- Follow the PR template when creating a pull request

## Release Process

Releases follow semantic versioning:

- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality (backwards compatible)
- **PATCH** version for bug fixes (backwards compatible)

To create a release:

1. Update version in `shard.yml`
2. Update `CHANGELOG.md`
3. Create git tag: `git tag vX.Y.Z`
4. Push tag: `git push --tags`
5. GitHub Actions will create a release automatically

## Questions?

Feel free to open an issue for questions about contributing!