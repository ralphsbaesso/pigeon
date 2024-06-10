FROM ruby:3.3.1-alpine

ENV APP_ROOT /app
RUN mkdir -p $APP_ROOT

WORKDIR $APP_ROOT

ADD Gemfile Gemfile.lock /app/
RUN bundle config --local without "test development" && bundle install

RUN adduser -D app
RUN chown -R app:app /app
USER app

ADD bin /app/bin
ADD rsc /app/rsc
