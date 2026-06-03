# frozen_string_literal: true

require 'openssl'
require 'active_record'
require 'friendly_fk/version'

module FriendlyFk
  # Overrides the default foreign key name with a readable one built from the
  # parent and child table names plus the referencing column(s), while
  # delegating column resolution (including composite primary keys) to
  # ActiveRecord. Folding the column in keeps names unique when several foreign
  # keys connect the same table pair. Prepended so +super+ keeps working across
  # ActiveRecord versions.
  module SchemaStatements
    def foreign_key_options(from_table, to_table, options) # :nodoc:
      name_given = options.key?(:name)
      options = super
      options[:name] = friendly_fk_name(from_table, to_table, options[:column]) unless name_given
      options
    end

    private

    def friendly_fk_name(from_table, to_table, column)
      column_part = Array(column).join('_and_')
      name = "fk_#{from_table}__#{to_table}__#{column_part}"
      return name if name.length <= max_identifier_length

      # Too long for the adapter's identifier limit: keep a friendly prefix and
      # disambiguate with a deterministic hash of the same parts.
      digest = OpenSSL::Digest::SHA256.hexdigest("#{from_table}/#{to_table}/#{column_part}").first(10)
      candidate = "fk_#{from_table}__#{to_table}__#{digest}"
      candidate.length <= max_identifier_length ? candidate : "fk_friendly_#{digest}"
    end
  end
end

ActiveRecord::ConnectionAdapters::SchemaStatements.prepend(FriendlyFk::SchemaStatements)
