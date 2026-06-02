# frozen_string_literal: true

require 'active_record'
require 'friendly_fk/version'

module FriendlyFk
  # Overrides the default foreign key name with a readable one built from the
  # parent and child table names, while delegating column resolution (including
  # composite primary keys) to ActiveRecord. Prepended so +super+ keeps working
  # across ActiveRecord versions.
  module SchemaStatements
    def foreign_key_options(from_table, to_table, options) # :nodoc:
      name_given = options.key?(:name)
      options = super
      options[:name] = friendly_fk_name(from_table, to_table) unless name_given
      options
    end

    private

    def friendly_fk_name(from_table, to_table)
      "fk_#{from_table}__#{to_table}"
    end
  end
end

ActiveRecord::ConnectionAdapters::SchemaStatements.prepend(FriendlyFk::SchemaStatements)
