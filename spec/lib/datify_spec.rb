# spec for data translation functions

require "spec_helper"

describe "datification" do
  it "should transform dates" do
    filename = File.dirname(__FILE__) + "/../data/datify_input.csv"
    tmp = Tempfile.new('datify')
    results = Masticate.datify(filename, :output => tmp, :field => 'timestamp', :format => '%m/%d/%Y %H:%M:%S%p')
    output = File.read(tmp)
    tmp.unlink

    correct_output = File.read(File.dirname(__FILE__) + "/../data/datify_result.csv")
  end
end
