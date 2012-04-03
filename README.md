# Masticate

Data file crunching

## Installation

Add this line to your application's Gemfile:

    gem 'masticate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install masticate

## Usage

    masticate sniff filename
    masticate mend filename

or

    > require 'masticate'
    > f = File.open(filename)
    > Masticate.sniff(f)
    > Masticate.mend(f, :output => $stdout, :col_sep => "\t")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
