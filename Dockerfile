FROM ruby:3.3.8-slim
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev libyaml-dev pkg-config curl git libvips42 && rm -rf /var/lib/apt/lists/*
WORKDIR /rails
ENV RAILS_ENV=production BUNDLE_DEPLOYMENT=1 BUNDLE_PATH=/usr/local/bundle RAILS_SERVE_STATIC_FILES=true
COPY Gemfile Gemfile.lock* ./
RUN bundle install
COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
EXPOSE 3000
CMD ["bash", "-lc", "bundle exec rails db:prepare && bundle exec puma -C config/puma.rb"]
