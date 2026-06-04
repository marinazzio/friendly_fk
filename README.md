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

## Requirements

- Ruby >= 2.7
- ActiveRecord >= 6.1, < 8.2

## Usage

Just use the conventional `add_foreign_key` call in your migrations — FriendlyFk
fills in the name automatically:

```ruby
add_foreign_key :comments, :posts
# constraint name: fk_comments__posts__post_id

add_foreign_key :comments, :users, column: :author_id
# constraint name: fk_comments__users__author_id
```

Because the column is part of the name, multiple foreign keys between the same
pair of tables get distinct names instead of colliding:

```ruby
add_foreign_key :messages, :users, column: :sender_id
# constraint name: fk_messages__users__sender_id
add_foreign_key :messages, :users, column: :recipient_id
# constraint name: fk_messages__users__recipient_id
```

Pass an explicit `name:` to opt out of the generated name entirely:

```ruby
add_foreign_key :comments, :posts, name: 'my_custom_fk'
```
