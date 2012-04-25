# apply regex transformation to a field

class Masticate::Gsubber < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @field = opts[:field] or raise "missing field to gsub"
    @from = Regexp.new(opts[:from]) or raise "Invalid regex '#{opts[:from]}' for conversion"
    @to = opts[:to] or raise "missing 'to' string for gsub"
  end

  def set_headers(row)
    @headers = row
    @index = @headers.index(@field) or raise "Unable to find column '#{@field}' in headers"
  end

  def gsub(opts)
    execute(opts)
  end

  def crunch(row)
    if !@headers
      set_headers(row)
    elsif row
      row[@index] = row[@index].gsub(@from, @to)
    end
    row
  end
end
