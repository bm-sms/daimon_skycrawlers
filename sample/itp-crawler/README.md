# itp-crawler

Simple crawler for [iタウンページ](http://itp.ne.jp)

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
    $ bundle exec rake itp:db:create
    $ bundle exec rake itp:db:migrate
    ```

3. Open new terminal and run crawler/processor

    ```
    $ bundle exec daimon_skycrawlers exec crawler   # on new terminal
    $ bundle exec daimon_skycrawlers exec processor # on new terminal
    ```

4. Enqueue task

    ```
    $ bundle exec daimon_skycrawlers enqueue url "http://itp.ne.jp/osaka/genre_dir/niku/?num=50"
    ```

5. You'll see `It works with 'http://example.com'` on your terminal which runs your processor!

6. You can re-enqueue task for processor

    ```
    $ bundle exec daimon_skycrawlers enqueue response "http://itp.ne.jp/osaka/genre_dir/niku/?num=50"
    ```
