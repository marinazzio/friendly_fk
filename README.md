# FriendlyFk

Uses child and parent table names to give FK name by default. It doesn't use hash tail, so use it carefully, 'cause it may generate non-unique names.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'friendly_fk'
```

And then execute:

    $ bundle

## Usage

Just use conventional call of `add_foreign_key` method.
