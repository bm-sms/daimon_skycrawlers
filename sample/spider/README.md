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
$ bin/crawler # on new terminal
$ bin/processor # on new terminal
```

4. Enqueue task

```
$ bin/enqueue url http://example.com/
```

5. You'll see `It works with 'http://example.com'` on your terminal which runs your processor!

6. You can re-enqueue task for processor

```
$ bin/enqueue response http://example.com/
```

Display `It works with 'http://example.com'` again on your terminal which runs your processor.
