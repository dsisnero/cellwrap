# Cellwrap Examples

This directory contains example programs demonstrating various features of the `cellwrap` library.

## Running Examples

Each example can be run directly with Crystal:

```bash
# Run basic example
crystal examples/basic.cr

# Run ANSI colors example
crystal examples/ansi_colors.cr

# Run Unicode/emoji example
crystal examples/unicode.cr

# Run advanced features example
crystal examples/advanced.cr
```

## Example Files

### `basic.cr`
Demonstrates basic text wrapping functionality:
- Simple text wrapping
- Empty string handling
- Zero width limit
- Single long word hard-wrapping
- Tab preservation
- Existing newline preservation

### `ansi_colors.cr`
Shows ANSI escape sequence preservation:
- Basic color preservation (RGB, 256-color, named colors)
- Multiple colors in one line
- Text styling (bold, underline, italic)
- Background colors
- Complex SGR sequences

### `unicode.cr`
Demonstrates Unicode and emoji support:
- Wide characters (Japanese, Chinese)
- Basic emojis (2-cell width)
- Emoji with text
- Emoji ZWJ sequences (zero-width joiners)
- Skin tone modifiers
- Combining diacritical marks
- Thai text with combining marks

### `advanced.cr`
Shows advanced features:
- Custom breakpoint characters
- Non-breaking spaces (U+00A0)
- OSC-8 hyperlink support
- Mixed content (colors + Unicode + emoji)
- Paragraph wrapping
- Code-like text wrapping

## Key Features Demonstrated

1. **ANSI Awareness**: Colors and styles are preserved during wrapping
2. **Unicode Support**: Proper cell width calculation for wide characters
3. **Emoji Handling**: ZWJ sequences and skin tones treated as single units
4. **Word Boundary Wrapping**: Breaks at spaces, with configurable breakpoints
5. **Hard Wrap Fallback**: Long words are broken when they exceed width
6. **Existing Structure Preservation**: Tabs and newlines in input are preserved

## Expected Output

Each example prints both the original text and the wrapped result, making it easy to see how `cellwrap` transforms the input while preserving important formatting information.