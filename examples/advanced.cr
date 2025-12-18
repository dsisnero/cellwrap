#!/usr/bin/env crystal
# Advanced features example

require "../src/cellwrap"

puts "=== Custom Breakpoints ==="

# Hyphen breakpoints (default)
hyphenated = "foo-bar-baz-qux"
puts "Hyphenated: #{hyphenated}"
puts "With hyphen breakpoints (width 5):"
puts Cellwrap.wrap(hyphenated, 5, "-")
puts

# Custom breakpoint characters
custom = "foo|bar|baz|qux"
puts "Custom pipe breakpoints: #{custom}"
puts "With pipe breakpoints (width 5):"
puts Cellwrap.wrap(custom, 5, "|")
puts

# Multiple breakpoints
multi_break = "foo-bar.baz,qux;test"
puts "Multiple breakpoints: #{multi_break}"
puts "With .,; breakpoints (width 6):"
puts Cellwrap.wrap(multi_break, 6, ".,;")
puts

puts "=== Non-breaking Spaces ==="

# Non-breaking spaces (U+00A0)
nbsp_text = "Hello\u00A0World! This\u00A0is\u00A0a\u00A0test."
puts "With non-breaking spaces: #{nbsp_text}"
puts "Wrapped to 15 columns (treats nbsp as regular character):"
puts Cellwrap.wrap(nbsp_text, 15)
puts

puts "=== Hyperlink Support (OSC-8) ==="

# OSC-8 hyperlinks
hyperlink = "Visit \e]8;;https://example.com\e\\Example Website\e]8;;\e\\ for more info."
puts "With hyperlink: #{hyperlink}"
puts "Wrapped to 20 columns:"
puts Cellwrap.wrap(hyperlink, 20)
puts

puts "=== Mixed Content ==="

# Everything combined
mixed = "\e[31mRed \e[32mGreen \e[34mBlue\e[0m text with 日本語 and 😃 emoji!"
puts "Mixed content: #{mixed}"
puts "Wrapped to 15 columns:"
puts Cellwrap.wrap(mixed, 15)
puts

puts "=== Paragraph Wrapping ==="

paragraph = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
puts "Paragraph: #{paragraph}"
puts "Wrapped to 30 columns:"
puts Cellwrap.wrap(paragraph, 30)
puts

puts "=== Code-like Text ==="

code = "function foo(bar, baz) { return bar + baz; } // Example function"
puts "Code-like text: #{code}"
puts "Wrapped to 20 columns:"
puts Cellwrap.wrap(code, 20)