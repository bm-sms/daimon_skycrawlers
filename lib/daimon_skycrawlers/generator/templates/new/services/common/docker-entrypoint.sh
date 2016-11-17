#!/bin/sh

set -x

MAIN=$1
case $MAIN in
    crawler)
        bundle check || bundle install --retry=3 --path=vendor/bundle \
                && bundle exec rake db:schema:load || bundle exec rake db:migrate
        bundle exec daimon_skycrawlers exec $MAIN
        ;;
    processor)
        while [ ! -e Gemfile.lock ]; do
            sleep 5
        done
        bundle check || bundle install --retry=3 --path=vendor/bundle \
                && bundle exec rake db:schema:load || bundle exec rake db:migrate
        bundle exec daimon_skycrawlers exec $MAIN
        ;;
    setup)
        bundle install --path=vendor/bundle
        bundle exec rake db:schema:load
        ;;
    none)
        echo NOP
        ;;
    sleep)
        sleep 1d
        ;;
esac
