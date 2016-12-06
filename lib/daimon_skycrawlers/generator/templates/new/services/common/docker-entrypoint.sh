#!/bin/sh

set -x

MAIN=$1
case $MAIN in
    crawler)
        dockerize -timeout 60s \
                  -wait tcp://${DATABASE_HOST}:${DATABASE_PORT} \
                  -wait tcp://${SKYCRAWLERS_RABBITMQ_HOST}:${SKYCRAWLERS_RABBITMQ_PORT}
        bundle check || bundle install --retry=3 --path=vendor/bundle \
                && bundle exec rake db:migrate
        bundle exec daimon_skycrawlers exec $MAIN
        ;;
    processor)
        dockerize -timeout 60s \
                  -wait tcp://${DATABASE_HOST}:${DATABASE_PORT} \
                  -wait tcp://${SKYCRAWLERS_RABBITMQ_HOST}:${SKYCRAWLERS_RABBITMQ_PORT}
        while [ ! -e Gemfile.lock ]; do
            sleep 5
        done
        bundle check || bundle install --retry=3 --path=vendor/bundle \
                && bundle exec rake db:migrate
        bundle exec daimon_skycrawlers exec $MAIN
        ;;
    setup)
        bundle install --retry=3 --path=vendor/bundle
        bundle exec rake db:schema:load
        ;;
    migrate)
        bundle exec rake db:migrate
        ;;
    none)
        echo NOP
        ;;
    sleep)
        sleep 1d
        ;;
esac
