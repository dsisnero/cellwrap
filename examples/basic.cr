#!/usr/bin/env crystal
# Basic usage example for cellwrap

require "../src/cellwrap"

puts "=== Basic Text Wrapping ==="
text = "The quick brown fox jumps over the lazy dog"
puts "Original: #{text}"
puts "Wrapped to 15 columns:"
puts Cellwrap.wrap(text, 15)
puts

puts "=== Empty String ==="
puts "Empty string: '#{Cellwrap.wrap("", 10)}'"
puts

puts "=== Zero Width Limit ==="
puts "Zero width returns original: '#{Cellwrap.wrap("hello", 0)}'"
puts

puts "=== Single Long Word ==="
puts "Long word hard-wrapped:"
puts Cellwrap.wrap("supercalifragilisticexpialidocious", 10)
puts

puts "=== With Tabs ==="
puts "Text with tabs:"
puts Cellwrap.wrap("name\tage\tcity", 8)
puts

puts "=== Preserving Newlines ==="
puts "Text with existing newlines:"
puts Cellwrap.wrap("First line\nSecond line\nThird line", 20)