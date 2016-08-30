# UnitSplit

Split numbers by unit

## Usage

Bytes (-b)

    $ unit_split -b 32227939482
     30 GB
     14 MB
    981 KB
    154

Seconds (-s)

    $ unit_split -s 50000
    13 hour
    53 min
    20

Japanese numbers (-j)

    $ unit_split -j 123534590029342
     123 cho
    5345 oku
    9002 man
    9342

You can pass number via STDIN

    $ echo "123382938749234" | unit_split -b
    112 TB
    221 GB
    323 MB
    786 KB
    306

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unit_split'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unit_split


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/unit_split. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

