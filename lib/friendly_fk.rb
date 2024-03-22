# frozen_string_literal: true

require 'friendly_fk/version'

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module SchemaStatements
      def foreign_key_options(from_table, to_table, options) # :nodoc:
        options = options.dup
        options[:to_table] = to_table
        options[:column] ||= foreign_key_column_for(to_table)
        options[:name]   ||= foreign_key_name(from_table, options)
        options
      end

      def foreign_key_name(from_table, options)
        options.fetch(:name) do
          "fk_#{from_table}__#{options[:to_table]}"
        end
      end
    end
  end
end
