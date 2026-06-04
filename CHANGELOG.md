# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-06-04

### Added
- Support for ActiveRecord 6.1 through 8.1 (`>= 6.1, < 8.2`); the dependency was
  previously unconstrained.
- Support for Ruby `>= 2.7`.
- CI runs the suite across a Ruby × ActiveRecord matrix — Ruby 2.7/3.1 against
  AR 6.1/7.1 and Ruby 3.2–3.4 against the latest AR — on both PostgreSQL and
  MySQL, so the supported range is actually exercised.

### Changed
- Generated foreign key names now fold in the referencing column:
  `fk_<from>__<to>__<column>` (composite columns joined with `_and_`), instead of
  `fk_<from>__<to>`. This keeps names unique when several foreign keys connect the
  same pair of tables — the previous scheme generated identical names and could
  collide.
- When a generated name would exceed the database's identifier limit, the column
  part is replaced with a short deterministic hash (`fk_<from>__<to>__<hash>`); if
  even the table-pair prefix is too long, the whole name falls back to
  `fk_friendly_<hash>`.
- The published gem now contains only `lib/`, `README.md`, `LICENSE`, and this
  changelog. Repository tooling and CI files are no longer packaged.

### Fixed
- `add_foreign_key` without an explicit `column:` no longer raises
  `ArgumentError` on ActiveRecord 8.x. Column resolution is delegated to
  ActiveRecord via `super`, which also restores composite primary key support and
  arity validation.
- The patch now requires `active_record` itself and is applied via `prepend`,
  removing a load-order dependency.

### Upgrading
- Foreign key constraints already created in your database are unaffected. New
  migrations generate the column-folded names.
- `remove_foreign_key` by table or by `column:` is unaffected. Only if you remove
  a foreign key by its explicit `name:` do you need to update the name to the new
  scheme (or keep passing an explicit `name:` when you create it).

[1.1.0]: https://github.com/marinazzio/friendly_fk/releases/tag/v1.1.0
