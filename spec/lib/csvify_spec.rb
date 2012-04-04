# spec for file-sniffing functions

require "spec_helper"

describe "csvification" do
  it "should convert pipes to standard commas" do
    filename = File.dirname(__FILE__) + "/../data/pipe_data.txt"
    file = File.open(filename)
    strio = StringIO.new
    Masticate.csvify(file, :output => strio, :col_sep => '|')
    strio.close
    strio.string.lines.count.should == 5
  end
end
