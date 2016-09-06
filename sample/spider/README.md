# spider

TODO: Write description.

## Requirements

- Ruby
- RabbitMQ
- RDB
  - PostgreSQL (default)
  - MySQL
  - SQLite3

## Usage

1. Install dependencies

```
$ bundle install
```

2. Create database

```
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

3. Open new terminal and run crawler/processor

```
$ bundle exec ruby crawler.rb # on new terminal
$ bundle exec ruby processor.rb # on new terminal
```

4. Enqueue task

```
$ bundle exec ruby enqueue.rb http://example.com/
```

5. You'll see `It works with 'http://example.com'` on your terminal which runs your processor!

6. You can re-enqueue task for processor

```
$ bundle exec ruby enqueue.rb response http://example.com/
```

Display `It works with 'http://example.com'` again on your terminal which runs your processor.
