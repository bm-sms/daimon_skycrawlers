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

1\. Create project

```
$ bundle exec daimon-skycrawlers new mycrawlers
$ cd mycrawlers
```

2\. Install dependencies

```
$ bundle install
```

3\. Create database

```
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

4\. Open new terminal and run crawler/processor

```
$ bundle exec ruby crawler.rb # on new terminal
$ bundle exec ruby processor.rb # on new terminal
```

5\. Enqueue task

```
$ bundle exec ruby enqueue.rb url http://example.com/
```

6\. You'll see `It works with 'http://example.com'` on your terminal which runs your processor!

7\. You can re-enqueue task for processor

```
$ bundle exec ruby enqueue.rb response http://example.com/
```

Display `It works with 'http://example.com'` again on your terminal which runs your processor.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bundle console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bm-sms/daimon-skycrawlers.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

