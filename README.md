## Caution!! This product is NOT production-ready.

# DaimonSkycrawlers

DaimonSkyCrawlers is a crawler framework.

## Requirements

- Ruby
- RabbitMQ
- RDB
  - PostgreSQL (default)
  - MySQL
  - SQLite3

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'daimon_skycrawlers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install daimon_skycrawlers

## Usage

1. Create project

    ```
    $ bundle exec daimon_skycrawlers new mycrawlers
    $ cd mycrawlers
    ```
    or
    ```
    $ daimon_skycrawlers new mycrawlers
    $ cd mycrawlers
    ```

2. Install dependencies

    ```
    $ bundle install
    ```

3. Create database

    ```
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate
    ```

4. Open new terminal and run crawler/processor

    ```
    $ daimon_skycrawlers exec crawler   # on new terminal
    $ daimon_skycrawlers exec processor # on new terminal
    ```

    NOTE: Execute step 5 as soon as possible. Because bin/crawler and
    bin/processor will stop after 10 seconds by default if their
    queues are empty.

    NOTE: You can change `shutdown_interval` using following code in config/init.rb:

    ```ruby
    DaimonSkycrawlers.configure do |config|
      config.shutdown_interval = 30
    end
    ```

5. Enqueue task

    ```
    $ daimon_skycrawlers enqueue url http://example.com/
    ```

6. You'll see `It works with 'http://example.com'` on your terminal which runs your processor!
7. You can re-enqueue task for processor

    ```
    $ daimon_skycrawlers enqueue response http://example.com/
    ```

Display `It works with 'http://example.com'` again on your terminal which runs your processor.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bundle console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bm-sms/daimon_skycrawlers.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

