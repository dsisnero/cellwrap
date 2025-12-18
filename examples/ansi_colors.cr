#!/usr/bin/env crystal
# ANSI color preservation example

require "../src/cellwrap"

puts "=== ANSI Color Preservation ==="

# Basic colors
colored = "I really \e[38;2;249;38;114mlove the\e[0m Go language!"
puts "Original with colors: #{colored}"
puts "Wrapped to 14 columns (colors preserved):"
puts Cellwrap.wrap(colored, 14)
puts

# Multiple colors in one line
multi_color = "\e[31mRed\e[0m \e[32mGreen\e[0m \e[34mBlue\e[0m text with colors"
puts "Multiple colors: #{multi_color}"
puts "Wrapped to 10 columns:"
puts Cellwrap.wrap(multi_color, 10)
puts

# Bold and underline
styled = "\e[1mBold text\e[0m and \e[4munderlined text\e[0m"
puts "Styled text: #{styled}"
puts "Wrapped to 15 columns:"
puts Cellwrap.wrap(styled, 15)
puts

# Background colors
bg_colored = "\e[48;5;236mDark background\e[0m with \e[48;5;226mYellow background\e[0m"
puts "Background colors: #{bg_colored}"
puts "Wrapped to 12 columns:"
puts Cellwrap.wrap(bg_colored, 12)
puts

# Complex SGR sequences
complex = "\e[1;3;4;38;5;208mBold, italic, underlined orange\e[0m text"
puts "Complex styling: #{complex}"
puts "Wrapped to 20 columns:"
puts Cellwrap.wrap(complex, 20)