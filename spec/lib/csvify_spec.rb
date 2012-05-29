# spec for file-sniffing functions

require "spec_helper"

describe "csvification" do
  it "should convert pipes to standard commas" do
    filename = File.dirname(__FILE__) + "/../data/pipe_data.txt"
    tmp = Tempfile.new('csvify')
    results = Masticate.csvify(filename, :output => tmp, :col_sep => '|')
    output = File.read(tmp)
    tmp.unlink
    output.lines.count.should == 5
    results[:input_count].should == 5
    results[:output_count].should == 5
  end
end
