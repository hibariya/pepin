# Pepin

Pepin is a Percol and Peco like, interactive filtering tool for CLI written in Ruby.
`Pepin.search` Launches interactive window for filtering, and returns the filtered item.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pepin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pepin

## Usage

The most simple example is below.

```ruby
#!/usr/bin/env ruby

require 'pepin'

list = %w(Alpha Bravo Charlie Delta Echo)
item = Pepin.search(list) # Launches interactive window and returns selected item

puts %(You selected "#{item}" from #{list.inspect}.)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hibariya/pepin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
