require "./spec_helper"

describe Cellwrap do
  # TODO: Write tests

  it "wraps basic text" do
    Cellwrap.wrap("hello world", 5).should eq("hello\nworld")
  end
end
