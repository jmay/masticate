# spec for file concatenation

require "spec_helper"

describe "concatenation" do
  it "should leave just one header row in the result" do
    file1 = File.dirname(__FILE__) + "/../data/tabbed_data.txt"
    file2 = File.dirname(__FILE__) + "/../data/pipe_data.txt"
    file3 = File.dirname(__FILE__) + "/../data/quoted_csv_data.txt"
    tmp = Tempfile.new('concat')
    results = Masticate.concat([file1, file2, file3], :output => tmp.path)
    output = File.read(tmp)
    tmp.unlink
    correct_output = File.read(File.dirname(__FILE__) + "/../data/concat_result.txt")
    output.should == correct_output
  end
end
