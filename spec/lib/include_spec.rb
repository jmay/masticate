# spec for row inclusion

require "spec_helper"

describe "include" do
  it "should be pick only rows that match criterion" do
    filename = File.dirname(__FILE__) + "/../data/include_input.csv"
    tmp = Tempfile.new('include')
    results = Masticate.include(filename, :output => tmp, :field => 'CRITERION', :value => 'yes')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/include_results.csv")

    output.should == correct_output
  end
end
