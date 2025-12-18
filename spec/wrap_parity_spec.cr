require "./spec_helper"

describe Cellwrap do
  cases = [
    {
      name:     "simple",
      input:    "I really \e[38;2;249;38;114mlove the\e[0m Go language!",
      expected: "I really \e[38;2;249;38;114mlove\e[m\n\e[38;2;249;38;114mthe\e[0m Go\nlanguage!",
      width:    14,
    },
    {name: "passthrough", input: "hello world", expected: "hello world", width: 11},
    {name: "asian", input: "こんにち", expected: "こんに\nち", width: 7},
    {name: "emoji", input: "😃👰🏻‍♀️🫧", expected: "😃\n👰🏻‍♀️\n🫧", width: 2},
    {
      name:     "long style",
      input:    "\e[38;2;249;38;114ma really long string\e[0m",
      expected: "\e[38;2;249;38;114ma really\e[m\n\e[38;2;249;38;114mlong\e[m\n\e[38;2;249;38;114mstring\e[0m",
      width:    10,
    },
    {
      name:     "long style nbsp",
      input:    "\e[38;2;249;38;114ma really\u00a0long string\e[0m",
      expected: "\e[38;2;249;38;114ma\e[m\n\e[38;2;249;38;114mreally\u00a0lon\e[m\n\e[38;2;249;38;114mg string\e[0m",
      width:    10,
    },
    {
      name:     "longer",
      input:    "the quick brown foxxxxxxxxxxxxxxxx jumped over the lazy dog.",
      expected: "the quick brown\nfoxxxxxxxxxxxxxx\nxx jumped over\nthe lazy dog.",
      width:    16,
    },
    {
      name:     "longer asian",
      input:    "猴 猴 猴猴 猴猴猴猴猴猴猴猴猴 猴猴猴 猴猴 猴’ 猴猴 猴.",
      expected: "猴 猴 猴猴\n猴猴猴猴猴猴猴猴\n猴 猴猴猴 猴猴\n猴’ 猴猴 猴.",
      width:    16,
    },
    {
      name:     "long input",
      input:    "Rotated keys for a-good-offensive-cheat-code-incorporated/animal-like-law-on-the-rocks.",
      expected: "Rotated keys for a-good-offensive-cheat-code-incorporated/animal-like-law-\non-the-rocks.",
      width:    76,
    },
    {
      name:     "long input2",
      input:    "Rotated keys for a-good-offensive-cheat-code-incorporated/crypto-line-operating-system.",
      expected: "Rotated keys for a-good-offensive-cheat-code-incorporated/crypto-line-\noperating-system.",
      width:    76,
    },
    {name: "hyphen breakpoint", input: "a-good-offensive-cheat-code", expected: "a-good-\noffensive-\ncheat-code", width: 10},
    {name: "exact", input: "\e[91mfoo\e[0m", expected: "\e[91mfoo\e[0m", width: 3},
    {name: "extra space", input: "foo ", expected: "foo", width: 3},
    {name: "extra space style", input: "\e[mfoo \e[m", expected: "\e[mfoo\e[m", width: 3},
    {
      name:     "paragraph with styles",
      input:    "Lorem ipsum dolor \e[1msit\e[m amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \e[31mUt enim\e[m ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea \e[38;5;200mcommodo consequat\e[m. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \e[1;2;33mExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\e[m",
      expected: "Lorem ipsum dolor \e[1msit\e[m amet,\nconsectetur adipiscing elit,\nsed do eiusmod tempor\nincididunt ut labore et dolore\nmagna aliqua. \e[31mUt enim\e[m ad minim\nveniam, quis nostrud\nexercitation ullamco laboris\nnisi ut aliquip ex ea \e[38;5;200mcommodo\e[m\n\e[38;5;200mconsequat\e[m. Duis aute irure\ndolor in reprehenderit in\nvoluptate velit esse cillum\ndolore eu fugiat nulla\npariatur. \e[1;2;33mExcepteur sint\e[m\n\e[1;2;33moccaecat cupidatat non\e[m\n\e[1;2;33mproident, sunt in culpa qui\e[m\n\e[1;2;33mofficia deserunt mollit anim\e[m\n\e[1;2;33mid est laborum.\e[m",
      width:    30,
    },
    {name: "hyphen break", input: "foo-bar", expected: "foo-\nbar", width: 5},
    {name: "double space", input: "f  bar foobaz", expected: "f  bar\nfoobaz", width: 6},
    {name: "passthrough width 0", input: "foobar\n ", expected: "foobar\n ", width: 0},
    {name: "pass", input: "foo", expected: "foo", width: 3},
    {name: "toolong", input: "foobarfoo", expected: "foob\narfo\no", width: 4},
    {name: "white space", input: "foo bar foo", expected: "foo\nbar\nfoo", width: 4},
    {name: "broken_at_spaces", input: "foo bars foobars", expected: "foo\nbars\nfoob\nars", width: 4},
    {name: "hyphen", input: "foob-foobar", expected: "foob\n-foo\nbar", width: 4},
    {name: "wide_emoji_breakpoint", input: "foo🫧 foobar", expected: "foo\n🫧\nfoob\nar", width: 4},
    {name: "space_breakpoint", input: "foo --bar", expected: "foo --bar", width: 9},
    {name: "simple small", input: "foo bars foobars", expected: "foo\nbars\nfoob\nars", width: 4},
    {name: "limit", input: "foo bar", expected: "foo\nbar", width: 5},
    {name: "remove white spaces", input: "foo    \nb   ar   ", expected: "foo\nb\nar", width: 4},
    {name: "white space trail width", input: "foo\nb\t a\n bar", expected: "foo\nb\t a\n bar", width: 4},
    {name: "explicit_line_break", input: "foo bar foo\n", expected: "foo\nbar\nfoo\n", width: 4},
    {name: "explicit_breaks", input: "\nfoo bar\n\n\nfoo\n", expected: "\nfoo\nbar\n\n\nfoo\n", width: 4},
    {
      name:     "example",
      input:    " This is a list: \n\n\t* foo\n\t* bar\n\n\n\t* foo  \nbar    ",
      expected: " This\nis a\nlist: \n\n\t* foo\n\t* bar\n\n\n\t* foo\nbar",
      width:    6,
    },
    {
      name:     "style_code_dont_affect_length",
      input:    "\e[38;2;249;38;114mfoo\e[0m\e[38;2;248;248;242m \e[0m\e[38;2;230;219;116mbar\e[0m",
      expected: "\e[38;2;249;38;114mfoo\e[0m\e[38;2;248;248;242m \e[0m\e[38;2;230;219;116mbar\e[0m",
      width:    7,
    },
    {
      name:     "style_code_dont_get_wrapped",
      input:    "\e[38;2;249;38;114m(\e[0m\e[38;2;248;248;242mjust another test\e[38;2;249;38;114m)\e[0m",
      expected: "\e[38;2;249;38;114m(\e[0m\e[38;2;248;248;242mjust\e[m\n\e[38;2;248;248;242manother\e[m\n\e[38;2;248;248;242mtest\e[38;2;249;38;114m)\e[0m",
      width:    7,
    },
    {
      name:     "osc8_wrap",
      input:    "สวัสดีสวัสดี\e]8;;https://example.com\e\\ สวัสดีสวัสดี\e]8;;\e\\",
      expected: "สวัสดีสวัสดี\e]8;;https://example.com\e\\\e]8;;\a\n\e]8;;https://example.com\aสวัสดีสวัสดี\e]8;;\e\\",
      width:    8,
    },
    {name: "tab", input: "foo\tbar", expected: "foo\nbar", width: 3},
    {name: "wrapped styles example", input: "", expected: "", width: 10},
    {
      name:     "punctuation after formatted word with space",
      input:    "\e[38;5;203;48;5;236m arm64 \e[0m, \e[38;5;203;48;5;236m amd64 \e[0m, \e[38;5;203;48;5;236m i386 \e[0m",
      expected: "\e[38;5;203;48;5;236m arm64 \e[0m,\n\e[38;5;203;48;5;236m amd64 \e[0m, \e[38;5;203;48;5;236m i386 \e[0m",
      width:    15,
    },
  ]

  cases.each do |tc|
    it "wraps like cellbuf.Wrap: #{tc[:name]}" do
      Cellwrap.wrap(tc[:input].as(String), tc[:width].as(Int32), "").should eq(tc[:expected])
    end
  end
end
