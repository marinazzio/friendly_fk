source 'https://rubygems.org'

# Specify your gem's dependencies in friendly_fk.gemspec
gemspec

group :development, :test do
  gem 'bundler'
  gem 'fuubar'
  gem 'rake'
end

group :test do
  gem 'bundler-audit', require: false
  gem 'mysql2', require: false
  # parallel 2.x requires Ruby >= 3.3; pin to keep rubocop usable on Ruby 3.2.
  # Lint-only transitive dep (via rubocop) — no runtime impact. Drop pin once
  # Ruby 2.7/3.2 support is dropped (see issue).
  gem 'parallel', '< 2.0', require: false
  gem 'pg', require: false
  gem 'rspec', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
end
