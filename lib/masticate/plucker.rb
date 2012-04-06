# extract subset of columns from CSV
require "csv"

class Masticate::Plucker < Masticate::Base
  def pluck(opts)
    standard_options(opts)

    fields = opts[:fields] or raise "missing fields to pluck"

    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        if !headers
          headers = row
          indexes = fields.map {|f| headers.index(f) or raise "Unable to find column '#{f}'"}
          emit(fields.to_csv)
        else
          emit(indexes.map {|i| row[i]}.to_csv) if row
        end
      end
    end
    @output.close if opts[:output]

    {
      :input_count => input_count,
      :output_count => @output_count
    }
  end
end
