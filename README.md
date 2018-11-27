# Rack::Request::Sampler

Rack middleware for sampling requests with the specified rate and handling it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-request-sampler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-request-sampler

## Usage

When you want to handle the requests once in three times,

```ruby
use Rack::Request::Sampler

Rack::Request::Sampler.config.on_picked_up = { numerator: 1, denominator: 3 }, Proc.new do |env|
  # Write the code to be applied to the picked up request
end
```

If you want to pick up requests in the multiple conditions, 

```ruby
use Rack::Request::Sampler

Rack::Request::Sampler.config.on_picked_up = [
  { numerator: 1, denominator: 3 }, Proc.new do |env|
     # The condition to be picked should be checked at first
   end],[
   { numerator: 2, denominator: 5 }, Proc.new do |env|
     # The condition to be picked should be checked next
   end
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/woahidan/rack-request-sampler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rack::Request::Sampler project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/woahidan/rack-request-sampler/blob/master/CODE_OF_CONDUCT.md).
