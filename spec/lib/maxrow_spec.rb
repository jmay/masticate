# spec for picking most-recent or highest-scoring rows
#
# something like:
#   select * from rows group by col_a having col_b = max(col_b)
#
# usage: masticate maxrows --by col_a --max col_b

require "spec_helper"
require "tempfile"

describe "maxrows" do
  it "should find " do
    filename = File.dirname(__FILE__) + "/../data/events.csv"
    tmp = Tempfile.new('maxrows')
    results = Masticate.maxrows(filename, :output => tmp, :by => 'uid', :max => 'timestamp')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/events_reduced.csv")

    output.should == correct_output
  end
end
