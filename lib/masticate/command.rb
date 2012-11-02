require 'thor'
require 'pp'

class Masticate::Command < Thor

  no_tasks do
    def params
      opts = options.dup
      col_sep = opts[:delim]
      col_sep = "TAB" if col_sep == "\t"
      opts[:col_sep] = col_sep
      opts
    end

    def logmessage(command, options, results)
      $stderr.puts <<-EOT
  * masticate #{command} (#{options.keys.join(', ')})
    Lines in input: #{results[:input_count]}
    Lines in output: #{results[:output_count]}
    Headers: #{results[:headers].inspect}
  EOT
      if results[:field_counts]
        $stderr.puts "  Field counts: #{results[:field_counts].inspect}"
      end
    end
  end

  desc "sniff", "determine structure of source file"
  method_option :stats => :boolean, :desc => "Read entire file, report distribution of field counts"
  def sniff
    results = Masticate.sniff(filename, params)
    col_sep = results[:col_sep]
    col_sep = "TAB" if col_sep == "\t"
    quote_char = results[:quote_char] || "NONE"
    $stderr.puts <<-EOT
Processing complete.
  Input delimiter: #{col_sep}
  Quote char: #{quote_char}
  Field counts: #{results[:field_counts].inspect}
  Headers: #{results[:headers].join(',')}
EOT
  end

  desc "mend", "repair source file format"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :inlined => :boolean, :desc => "Source records repeat header fields on every line"
  method_option :snip => :numeric, :desc => "Ignore first N fields of each row"
  method_option :dejunk => :boolean, :desc => "Ignore short lines"
  method_option :buried => :numeric, :desc => "Remove embedded delimiters in field N"
  def mend(filename = nil)
    results = Masticate.mend(filename, params)
    logmessage(__method__, params, results)
  end

  desc "csvify", "convert input to standard CSV"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  def csvify(filename = nil)
    results = Masticate.csvify(filename, params)
    logmessage(__method__, params, results)
  end

  desc 'pluck', "ignore all but the specified columns"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :fields, :required => true, :desc => "field names to extract"
  def pluck(filename = nil)
    results = Masticate.pluck(filename, params)
    logmessage(__method__, params, results)
  end

  desc "datify", "parsed named field as formatted time/datestamp"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :field, :required => true, :desc => "Fieldname to interpret as a date/time"
  method_option :format, :required => true, :desc => "strptime format string"
  def datify(filename = nil)
    results = Masticate.datify(filename, params)
    logmessage(__method__, params, results)
  end

  desc "gsub", "applied substitution rule to named field"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :field, :required => true, :desc => "field to convert"
  method_option :from, :required => true, :desc => "regexp to apply to original value"
  method_option :to, :required => true, :desc => "string to replace capture with"
  def gsub(filename = nil)
    results = Masticate.gsub(filename, params)
    logmessage(__method__, params, results)
  end

  desc "maxrows", "compute SUM(max-field) GROUP BY(by-field)"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :max, :required => true, :desc => "field to sum"
  method_option :by, :required => true, :desc => "field to aggregate over"
  def maxrows(filename = nil)
    results = Masticate.maxrows(filename, params)
    logmessage(__method__, params, results)
  end

  desc "concat", "concatenate multiple input files, ignoring header lines on all but first file"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  def concat(filename = nil)
    results = Masticate.concat(ARGV, options)
    # logmessage(__method__, params, results)
  end

  desc "relabel", "replace header line in output"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :fields, :required => true, :desc => "list of field names to use in output"
  def relabel(filename = nil)
    results = Masticate.relabel(filename, params)
    # logmessage(__method__, params, results)
  end

  desc "exclude", "ignore input lines that match criteria"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :field, :required => true, :desc => "field to check for exclusion"
  method_option :value, :required => true, :desc => "value to compare with for exclusion"
  def exclude(filename = nil)
    results = Masticate.exclude(filename, params)
    logmessage(__method__, params, results)
  end

  desc "include", "ignore all input lines *except* those that match criteria"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :field, :required => true, :desc => "field to check for inclusion"
  method_option :value, :required => true, :desc => "value to compare with for inclusion"
  def include(filename = nil)
    results = Masticate.include(filename, params)
    logmessage(__method__, params, results)
  end

  desc "transform", "apply transformation rule to named field"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :rule, :required => true, :desc => "valid values are {upcase, downcase}"
  def transform(filename = nil)
    results = Masticate.transform(filename, params)
    logmessage(__method__, params, results)
  end

  desc "cook", "apply conversion recipe to input records"
  method_option :delim, :desc => "field delimiter (default is comma)"
  method_option :quote, :desc => "delimiter escape string (default is double-quotes when delim is comma, otherwise none)"
  method_option :recipe, :required => true, :desc => "filename containing recipe"
  def cook(filename = nil)
    results = Masticate.cook(filename, params)
    logmessage(__method__, params, results)
  end
end
