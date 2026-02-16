# syntax=docker/dockerfile:1
FROM ruby:3.3-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    libvips \
    pkg-config \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/usr/local/bundle

COPY Gemfile ./
RUN bundle lock --add-platform ruby && bundle install

COPY . .
COPY docker/entrypoint.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

RUN bundle exec bootsnap precompile --gemfile

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
