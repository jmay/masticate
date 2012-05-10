# exclude rows based on field = value

class Masticate::Exclude < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @field = opts[:field] or raise "missing field to exclude"
    @value = opts[:value] or raise "missing value to exclude"

    # row-loading automatically strips leading & trailing whitespace and converts blanks to nils,
    # so when looking for blanks need to compare to nil instead of ''
    @value = nil if @value.empty?
  end

  def exclude(opts)
    execute(opts)
  end

  def crunch(row)
    if !@headers
      @headers = row
      f = @field
      @index =
        case f
        when Fixnum, /^\d+$/
          f = f.to_i
          if f > row.count
            raise "Cannot pluck column #{f}, there are only #{row.count} fields"
          else
            f-1
          end
        else
          row.index(f) or raise "Unable to find column '#{f}' in headers"
        end
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
