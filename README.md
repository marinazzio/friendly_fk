[![Gem Version](https://badge.fury.io/rb/friendly_fk.svg)](https://badge.fury.io/rb/friendly_fk)
[![Maintainability](https://api.codeclimate.com/v1/badges/73f1cc07c4bce785ee76/maintainability)](https://codeclimate.com/github/marinazzio/friendly_fk/maintainability)

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
