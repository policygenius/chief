# Chief

A simple command pattern for Ruby.

[![Code Climate](https://codeclimate.com/github/policygenius/chief/badges/gpa.svg)](https://codeclimate.com/github/policygenius/chief)
[![Build Status](https://travis-ci.org/policygenius/chief.svg?branch=master)](https://travis-ci.org/policygenius/chief)


## Usage

A `Chief::Command`'s primary interface is the `.call` method, executes the command and returns a `Chief::Result` instance.

A `Chief::Result` encapsulates whether the command succeeded, including the return values and (optionally) any errors encountered.

Suppose we have an ExampleApplication, that needs to notify an external service with a message. First, we create the command:

```Ruby
require 'net/http'

module ExampleApplication
  module SomeExternalService
    class Notify < Chief::Command
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def call
        response = report_to_external_service

        if response.code == 200
          success!(message)
        else
          fail!(false, 'Could not notify the external service')
        end
      rescue => exception
        fail!(exception, 'Unexpected error while notifying service')
      end

      private

      def report_to_external_service
        Net::HTTP.post_form(
          URI.parse('https://some_external_service/messages'),
          message: message
        )
      end
    end
  end
end
```

You can use destructuring assignment to easily grab the value and the errors.


```
result, value, errors = ExampleApplication::SomeExternalService::Notify.call(message)
```

## Things to consider

* A `Chief::Command` must call `success!` or `fail!`. We think this leads to better code so we enforce it.

```ruby
irb(main):001:0> class ExampleCommand < Chief::Command
irb(main):002:1>   def call
irb(main):003:2>     nil
irb(main):004:2>   end
irb(main):005:1> end
=> :call
irb(main):006:0> ExampleCommand.call
RuntimeError: ExampleCommand must call success! or fail! and return the result
        from ../chief/lib/chief/command.rb:9:in `call'
        from (irb):6
        from bin/console:14:in `<main>'
```




## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chief'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chief

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/policygenius/chief.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

