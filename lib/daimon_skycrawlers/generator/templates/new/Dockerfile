FROM ruby:2.3.1-alpine

RUN apk --no-cache --update add build-base ruby-dev libxml2-dev postgresql-dev libcurl git

RUN adduser -D -h /home/crawler -g "DaimonSkycrawlers user" -s /bin/sh crawler crawler

ARG SKYCRAWLERS_ENV=production
ARG SKYCRAWLERS_MAIN=crawler
ENV SKYCRAWLERS_ENV=$SKYCRAWLERS_ENV \
    SKYCRAWLERS_MAIN=$SKYCRAWLERS_MAIN \
    BUNDLE_JOBS=4

USER crawler
WORKDIR /home/crawler
COPY ./Gemfile* ./

RUN if [ "$SKYCRAWLERS_ENV" = "production" ]; then \
      bundle install --without development:test; \
    fi

COPY . .

ADD services/common/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["$SKYCRAWLERS_MAIN"]
