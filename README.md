# cellwrap

ANSI-aware word wrapping in terminal cell widths (Crystal port of [charmbracelet/x/cellbuf.Wrap](https://github.com/charmbracelet/x/tree/main/cellbuf))

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/dsisnero/cellwrap/ci.yml?branch=main)](https://github.com/dsisnero/cellwrap/actions)
[![GitHub release](https://img.shields.io/github/v/release/dsisnero/cellwrap)](https://github.com/dsisnero/cellwrap/releases)
[![License](https://img.shields.io/github/license/dsisnero/cellwrap)](LICENSE)
[![Crystal](https://img.shields.io/badge/crystal-1.18.2+-brightgreen)](https://crystal-lang.org)

`Cellwrap` is a small, ANSI-aware word wrapping utility that treats ANSI escape sequences as zero-width and tries to wrap at word boundaries, hard-wrapping when a single word exceeds the width.

## Features

- **ANSI escape sequence aware** - Preserves colors, styles, and hyperlinks while wrapping
- **Unicode/emoji support** - Proper cell width calculation for wide characters
- **Word boundary wrapping** - Wraps at spaces, with configurable breakpoints
- **Hard wrap fallback** - Breaks long words when they exceed width limit
- **Go parity** - 117 comprehensive tests matching the Go implementation

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cellwrap:
       github: dsisnero/cellwrap
   ```

2. Run `shards install`

## Usage

```crystal
require "cellwrap"

# Basic text wrapping
text = "The quick brown fox jumps over the lazy dog"
wrapped = Cellwrap.wrap(text, 15)
puts wrapped
# Output:
# The quick brown
# fox jumps over
# the lazy dog

# ANSI color preservation
colored = "I really \e[38;2;249;38;114mlove the\e[0m Go language!"
wrapped_colored = Cellwrap.wrap(colored, 14)
puts wrapped_colored
# Output (with preserved colors):
# I really \e[38;2;249;38;114mlove\e[m
# \e[38;2;249;38;114mthe\e[0m Go
# language!

# Unicode/emoji support
emoji = "😃👰🏻‍♀️🫧 Hello world!"
wrapped_emoji = Cellwrap.wrap(emoji, 8)
puts wrapped_emoji
# Output:
# 😃
# 👰🏻‍♀️
# 🫧 Hello
# world!

# Custom breakpoints
text = "foo-bar-baz-qux"
wrapped = Cellwrap.wrap(text, 5, "-")  # Allow breaking on hyphens
puts wrapped
# Output:
# foo-
# bar-
# baz-
# qux
```

## API

### `Cellwrap.wrap(str : String, limit : Int32, breakpoints : String = "") : String`

Wraps a string to a given cell width, preserving ANSI escape sequences.

**Parameters:**
- `str` - The input string to wrap (may contain ANSI escape sequences)
- `limit` - Maximum cell width for each line
- `breakpoints` - Optional string of 1-cell characters that are valid wrap breakpoints (a hyphen `-` is always considered a breakpoint)

**Returns:** The wrapped string with newlines inserted at appropriate positions.

**Behavior:**
- ANSI escape sequences (colors, styles, hyperlinks) are treated as zero-width
- Tries to wrap at word boundaries (spaces)
- If a single word exceeds the width limit, hard-wraps at the limit
- Preserves existing newlines in the input
- Handles tabs as single-cell characters
- Properly handles Unicode grapheme clusters (emoji ZWJ sequences, combining marks)

## Development

### Setup

```bash
git clone https://github.com/dsisnero/cellwrap.git
cd cellwrap
shards install
```

### Testing

```bash
crystal spec  # Run all tests
```

### Code Quality

```bash
crystal tool format --check  # Check formatting
ameba                        # Run linter
```

### Building Documentation

```bash
crystal docs  # Generate API documentation
```

### Running Examples

See the [examples directory](examples/) for practical usage examples:

```bash
crystal examples/basic.cr      # Basic text wrapping
crystal examples/ansi_colors.cr # ANSI color preservation
crystal examples/unicode.cr    # Unicode and emoji handling
crystal examples/advanced.cr   # Advanced features
```

## Contributing

1. Fork it (<https://github.com/dsisnero/cellwrap/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and development process.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by [charmbracelet/x/cellbuf.Wrap](https://github.com/charmbracelet/x/tree/main/cellbuf) (Go)
- Uses [naqvis/uni_char_width](https://github.com/naqvis/uni_char_width) for Unicode width calculation
- Uses [naqvis/uni_text_seg](https://github.com/naqvis/uni_text_seg) for grapheme segmentation

## Contributors

- [Dominic Sisneros](https://github.com/dsisnero) - creator and maintainer
