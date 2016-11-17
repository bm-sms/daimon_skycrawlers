#!/bin/sh

set -x

MAIN=$1
case $MAIN in
    crawler|processor)
        bundle check || bundle install --retry=3 --path=vendor/bundle && bundle exec rake db:setup
        bundle exec daimon_skycrawlers exec $MAIN
        ;;
    setup)
        bundle install --path=vendor/bundle
        bundle exec rake db:setup
        ;;
    none)
        echo NOP
        ;;
    sleep)
        sleep 1d
        ;;
esac
