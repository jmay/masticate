# apply transformation rules to a field

class Masticate::Transform < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @field = opts[:field] or raise "missing field to transform"
    @rule = opts[:rule] or raise "missing transformation rule"
    unless ['upcase', 'downcase'].include?(@rule)
      raise "invalid transformation rule <#{@rule}>: supported rules are downcase, upcase"
    end
  end

  def set_headers(row)
    @headers = row
    @index = @headers.index(@field) or raise "Unable to find column '#{@field}' in headers"
  end

  def transform(opts)
    execute(opts)
  end

  def crunch(row)
    if !@headers
      set_headers(row)
    elsif row
      row[@index] = case @rule
      when 'downcase'
        row[@index].downcase
      when 'upcase'
        row[@index].upcase
      else
        raise "no code for rule #{@rule}"
      end
    end

    row
  end
end
