require "uniwidth"

# `Cellwrap` is a small, ANSI-aware word wrapping utility inspired by
# `github.com/charmbracelet/x/cellbuf.Wrap` (Go).
#
# It treats ANSI escape sequences as zero-width and tries to wrap at word
# boundaries, hard-wrapping when a single word exceeds the width.
#
# This code lives under `lib/` so it can be extracted into a shard later.
module Cellwrap
  NBSP        = 0x00A0
  RESET_STYLE = "\e[m"
  BEL         = 0x07_u8

  # Wrap a string to a given cell width, preserving ANSI escape sequences.
  #
  # `breakpoints` is a set of 1-cell characters that are valid wrap breakpoints.
  # A hyphen (`-`) is always considered a breakpoint.
  def self.wrap(str : String, limit : Int32, breakpoints : String = "") : String
    return "" if str.empty?
    return str if limit < 1

    breakpoints_set = breakpoints.each_char.map(&.ord).to_set

    # Map byte offsets to grapheme end offsets so we treat extended grapheme
    # clusters as atomic units (emoji ZWJ sequences, combining marks, etc.).
    grapheme_end = Hash(Int32, Int32).new
    offset = 0
    str.each_grapheme do |grapheme|
      gs = grapheme.to_s
      size = gs.bytesize
      grapheme_end[offset] = offset + size
      offset += size
    end

    bytes = str.to_slice
    i = 0

    cur_width = 0
    word_width = 0
    space_width = 0

    out = String::Builder.new
    word = IO::Memory.new
    space = IO::Memory.new

    sgr = SgrState.new
    style_seq = ""               # parse-time style sequence
    link = Hyperlink.new("", "") # parse-time link state

    cur_style_seq = ""               # active style applied to `out`
    cur_link = Hyperlink.new("", "") # active link applied to `out`

    add_space = -> do
      cur_width += space_width
      out << space.to_s
      space.clear
      space_width = 0
    end

    add_word = -> do
      if word_width != 0 || word.size != 0
        cur_link = link
        cur_style_seq = style_seq
        add_space.call
        cur_width += word_width
        out << word.to_s
        word.clear
        word_width = 0
      end
    end

    add_newline = -> do
      if !cur_style_seq.empty?
        out << RESET_STYLE
      end
      if cur_link.active?
        out << cur_link.reset_sequence
      end
      out << '\n'
      if cur_link.active?
        out << cur_link.set_sequence
      end
      out << cur_style_seq unless cur_style_seq.empty?
      cur_width = 0
      space.clear
      space_width = 0
    end

    while i < bytes.size
      if bytes[i] == 0x1b_u8
        seq_len = consume_escape(bytes, i)
        seq = String.new(bytes[i, seq_len])

        # Track SGR style (CSI ... m).
        if seq_len >= 3 && bytes[i + 1]? == '['.ord.to_u8 && bytes[i + seq_len - 1]? == 'm'.ord.to_u8
          codes = parse_sgr_codes(seq)
          sgr.apply(codes)
          if codes.empty? || codes.includes?(0)
            style_seq = ""
          else
            style_seq = seq
          end
        end

        # Track OSC-8 hyperlinks.
        if seq_len >= 4 && bytes[i + 1]? == ']'.ord.to_u8
          if parsed_link = Hyperlink.parse(seq)
            link = parsed_link
          end
        end

        word << seq
        i += seq_len
        next
      end

      cp_len = 1
      cp = bytes[i].to_i32
      if end_idx = grapheme_end[i]?
        cp_len = end_idx - i
        cp = bytes[i].to_i32
      else
        cp, cp_len = decode_utf8(bytes, i)
      end

      if cp == '\t'.ord
        add_word.call
        space.write(bytes[i, cp_len])
        space_width += 1
        i += cp_len
        next
      end

      if cp == '\n'.ord
        if word_width == 0
          if cur_width + space_width > limit
            cur_width = 0
          else
            out << space.to_s
          end
          space.clear
          space_width = 0
        end

        add_word.call
        add_newline.call
        i += cp_len
        next
      end

      width =
        if cp_len == 1 && cp < 0x80
          1
        else
          cell_width(String.new(bytes[i, cp_len]))
        end

      # ASCII-only space splitting, similar to Go's cellbuf.Wrap.
      if cp_len == 1 && cp < 0x80 && cp != NBSP && cp.chr.whitespace? && width == 1 && sgr.blank_style?
        add_word.call
        space.write(bytes[i, cp_len])
        space_width += 1
        i += cp_len
        next
      end

      if cp_len == 1 && (cp == '-'.ord || (width == 1 && breakpoints_set.includes?(cp)))
        add_space.call
        if cur_width + word_width + width <= limit
          add_word.call
          out.write(bytes[i, cp_len])
          cur_width += width
          i += cp_len
          next
        end
      end

      if word_width + width > limit
        add_word.call
      end

      word.write(bytes[i, cp_len])
      word_width += width

      if cur_width + word_width + space_width > limit
        add_newline.call
      end

      i += cp_len
    end

    if word_width == 0
      if cur_width + space_width > limit
        cur_width = 0
      else
        out << space.to_s
      end
      space.clear
      space_width = 0
    end

    add_word.call

    # Close open link/style state (Go cellbuf.Wrap parity).
    if cur_link.active?
      out << cur_link.reset_sequence
    end
    if !cur_style_seq.empty?
      out << RESET_STYLE
    end

    out.to_s
  end

  private struct SgrState
    @reverse : Bool = false
    @bg : Bool = false
    @underline : Bool = false

    def blank_style? : Bool
      !@reverse && !@bg && !@underline
    end

    def apply(codes : Array(Int32)) : Nil
      i = 0
      while i < codes.size
        c = codes[i]
        case c
        when 0
          @reverse = false
          @bg = false
          @underline = false
        when 4
          @underline = true
        when 24
          @underline = false
        when 7
          @reverse = true
        when 27
          @reverse = false
        when 48
          # Background color set (48;5;n or 48;2;r;g;b).
          @bg = true
          mode = codes[i + 1]?
          if mode == 5
            i += 2
          elsif mode == 2
            i += 4
          end
        when 49
          @bg = false
        else
          # Background colors.
          if (40..47).includes?(c) || (100..107).includes?(c)
            @bg = true
          end
        end
        i += 1
      end
    end
  end

  private record Hyperlink, url : String, params : String do
    def active? : Bool
      !url.empty?
    end

    def reset_sequence : String
      # Canonicalize reset to BEL-terminated OSC 8 (matches Go ansi.ResetHyperlink()).
      "\e]8;;\a"
    end

    def set_sequence : String
      # Canonicalize set to BEL-terminated OSC 8.
      "\e]8;#{params};#{url}\a"
    end

    def self.parse(seq : String) : Hyperlink?
      # OSC 8: ESC ] 8 ; params ; url ST|BEL
      return unless seq.starts_with?("\e]8;")
      payload = seq[3..]?
      return unless payload

      # Strip terminator: BEL or ST(ESC \).
      if payload.ends_with?("\a")
        inner = payload[0...-1]
      elsif payload.ends_with?("\e\\")
        inner = payload[0...-2]
      else
        return
      end

      # inner: "8;params;url" (we already matched "8;" in prefix, but keep robust).
      parts = inner.split(';', 3)
      return unless parts.size == 3
      return Hyperlink.new("", "") if parts[2].empty?
      Hyperlink.new(parts[2], parts[1])
    end
  end

  private def self.consume_escape(bytes : Bytes, idx : Int32) : Int32
    return 1 if idx + 1 >= bytes.size

    second = bytes[idx + 1]
    if second == '['.ord.to_u8
      j = idx + 2
      while j < bytes.size
        final = bytes[j]
        j += 1
        break if final >= 0x40_u8 && final <= 0x7E_u8
      end
      return j - idx
    end

    if second == ']'.ord.to_u8
      j = idx + 2
      while j < bytes.size
        b = bytes[j]
        j += 1
        # BEL terminator.
        break if b == 0x07_u8
        # ST terminator: ESC \
        if b == 0x1b_u8 && j < bytes.size && bytes[j] == '\\'.ord.to_u8
          j += 1
          break
        end
      end
      return j - idx
    end

    1
  end

  private def self.decode_utf8(bytes : Bytes, idx : Int32) : {Int32, Int32}
    b0 = bytes[idx]
    return {b0.to_i32, 1} if b0 < 0x80_u8

    len =
      if (b0 & 0xE0_u8) == 0xC0_u8
        2
      elsif (b0 & 0xF0_u8) == 0xE0_u8
        3
      elsif (b0 & 0xF8_u8) == 0xF0_u8
        4
      else
        1
      end
    len = 1 if idx + len > bytes.size

    cp = 0_i32
    case len
    when 2
      cp = ((b0 & 0x1F_u8).to_i32 << 6) | (bytes[idx + 1] & 0x3F_u8).to_i32
    when 3
      cp = ((b0 & 0x0F_u8).to_i32 << 12) |
           ((bytes[idx + 1] & 0x3F_u8).to_i32 << 6) |
           (bytes[idx + 2] & 0x3F_u8).to_i32
    when 4
      cp = ((b0 & 0x07_u8).to_i32 << 18) |
           ((bytes[idx + 1] & 0x3F_u8).to_i32 << 12) |
           ((bytes[idx + 2] & 0x3F_u8).to_i32 << 6) |
           (bytes[idx + 3] & 0x3F_u8).to_i32
    else
      cp = b0.to_i32
    end

    {cp, len}
  end

  private def self.parse_sgr_codes(seq : String) : Array(Int32)
    # seq is something like "\e[0;31;48;5;123m". We'll parse the params between
    # '[' and 'm'. Unknown values are ignored.
    open = seq.index('[')
    return [] of Int32 unless open
    inner = seq[(open + 1)..-2]? || ""
    return [0] of Int32 if inner.empty?

    inner.split(';').compact_map do |segment|
      segment.to_i?
    end
  end

  private def self.cell_width(str : String) : Int32
    str.each_char.sum { |char| cell_width_char(char) }
  end

  private def self.cell_width_char(ch : Char) : Int32
    cp = ch.ord

    # Common zero-width codepoints used in emoji ZWJ sequences.
    return 0 if cp == 0x200D                     # ZWJ
    return 0 if cp == 0xFE0E                     # VS15 text presentation
    return 0 if cp == 0xFE0F                     # VS16 emoji presentation
    return 0 if (0x1F3FB..0x1F3FF).includes?(cp) # skin tone modifiers
    return 0 if combining_mark_codepoint?(cp)

    w = UnicodeCharWidth.width(ch)
    # Heuristic: many terminals treat emoji-range codepoints as wide even when
    # older width tables don't include them.
    if w == 1 && (0x1F000..0x1FFFF).includes?(cp)
      return 2
    end
    w
  end

  private def self.combining_mark_codepoint?(cp : Int32) : Bool
    # Broad set of combining mark ranges (zero-width), including Thai marks.
    return true if (0x0300..0x036F).includes?(cp) # Combining Diacritical Marks
    return true if (0x1AB0..0x1AFF).includes?(cp) # Combining Diacritical Marks Extended
    return true if (0x1DC0..0x1DFF).includes?(cp) # Combining Diacritical Marks Supplement
    return true if (0x20D0..0x20FF).includes?(cp) # Combining Diacritical Marks for Symbols
    return true if (0xFE20..0xFE2F).includes?(cp) # Combining Half Marks

    # Thai combining marks.
    return true if cp == 0x0E31
    return true if (0x0E34..0x0E3A).includes?(cp)
    return true if (0x0E47..0x0E4E).includes?(cp)

    false
  end
end
