[![Gem Version](https://badge.fury.io/rb/friendly_fk.svg)](https://badge.fury.io/rb/friendly_fk)
[![Maintainability](https://api.codeclimate.com/v1/badges/73f1cc07c4bce785ee76/maintainability)](https://codeclimate.com/github/marinazzio/friendly_fk/maintainability)

# FriendlyFk

Uses child and parent table names plus the referencing column to give every foreign key a readable name by default — e.g. `fk_child_table__parent_table__parent_id`. Folding the column in keeps names unique even when several foreign keys connect the same table pair.

If the generated name would exceed the database's identifier limit, the column part is replaced with a short deterministic hash (`fk_child_table__parent_table__<hash>`). If even the table-pair prefix is too long for the limit, the whole name falls back to `fk_friendly_<hash>`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'friendly_fk'
```

And then execute:

    $ bundle

## Usage

Just use conventional call of `add_foreign_key` method.
