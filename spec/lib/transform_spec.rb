# spec for field transformation

require "spec_helper"

describe "transform" do
  it "should be able to downcase fields" do
    filename = File.dirname(__FILE__) + "/../data/datify_input.csv"
    tmp = Tempfile.new('transform')
    results = Masticate.transform(filename, :output => tmp, :field => 'LAST_NAME', :rule => 'downcase')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/downcase_results.csv")

    output.should == correct_output
  end

  it "should be able to upcase fields" do
    filename = File.dirname(__FILE__) + "/../data/downcase_results.csv"
    tmp = Tempfile.new('transform')
    results = Masticate.transform(filename, :output => tmp, :field => 'LAST_NAME', :rule => 'upcase')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/datify_input.csv")

    output.should == correct_output
  end
end
