# exclude rows based on field = value

class Masticate::Exclude < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @field = opts[:field] or raise "missing field to exclude"
    @value = opts[:value] or raise "missing value to exclude"
  end

  def set_headers(row)
    @headers = row
    @index = @headers.index(@field) or raise "Unable to find column '#{@field}' in headers"
  end

  def exclude(opts)
    execute(opts)
  end

  def crunch(row)
    if !@headers
      set_headers(row)
      row
    elsif row
      if row[@index] == @value
        # exclude
      else
        row
      end
    end
  end
end
