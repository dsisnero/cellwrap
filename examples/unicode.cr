#!/usr/bin/env crystal
# Unicode and emoji handling example

require "../src/cellwrap"

puts "=== Unicode Character Support ==="

# Japanese text (wide characters)
japanese = "こんにちは世界！今日は良い天気ですね。"
puts "Japanese: #{japanese}"
puts "Wrapped to 10 columns:"
puts Cellwrap.wrap(japanese, 10)
puts

# Chinese text
chinese = "你好世界！这是一个测试。"
puts "Chinese: #{chinese}"
puts "Wrapped to 8 columns:"
puts Cellwrap.wrap(chinese, 8)
puts

puts "=== Emoji Support ==="

# Basic emojis (wide characters)
emojis = "😃🎉✨🌟🎈"
puts "Emojis: #{emojis}"
puts "Wrapped to 4 columns (each emoji is 2 cells wide):"
puts Cellwrap.wrap(emojis, 4)
puts

# Emoji with text
emoji_text = "Hello 😃 World 🌍!"
puts "Emoji with text: #{emoji_text}"
puts "Wrapped to 10 columns:"
puts Cellwrap.wrap(emoji_text, 10)
puts

# Emoji ZWJ sequences (zero-width joiners)
zwj_emoji = "👨‍👩‍👧‍👦 Family emoji (ZWJ sequence)"
puts "ZWJ emoji: #{zwj_emoji}"
puts "Wrapped to 15 columns:"
puts Cellwrap.wrap(zwj_emoji, 15)
puts

# Skin tone modifiers
skin_tones = "👍👍🏻👍🏼👍🏽👍🏾👍🏿"
puts "Skin tone variants: #{skin_tones}"
puts "Wrapped to 6 columns:"
puts Cellwrap.wrap(skin_tones, 6)
puts

puts "=== Combining Marks ==="

# Text with combining diacritical marks
accented = "café naïve naïve"
puts "Accented text: #{accented}"
puts "Wrapped to 8 columns:"
puts Cellwrap.wrap(accented, 8)
puts

# Thai with combining marks
thai = "สวัสดีครับ (Hello in Thai)"
puts "Thai text: #{thai}"
puts "Wrapped to 12 columns:"
puts Cellwrap.wrap(thai, 12)