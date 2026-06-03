require 'spec_helper'
require 'support/connection_helper'

RSpec.describe FriendlyFk do
  it 'has a version number' do
    expect(FriendlyFk::VERSION).not_to be_nil
  end

  context 'with base' do
    let(:connection) { ActiveRecord::Base.connection }

    before do
      ARTest.connect

      connection.create_table :parent_table, id: false do |t|
        t.primary_key :id, :integer
        t.string :name
      end

      connection.create_table :child_table, id: false do |t|
        t.primary_key :id, :integer
        t.string :also_name
        t.integer :parent_id
        t.integer :parent_table_id
      end
    end

    after do
      connection.drop_table :child_table
      connection.drop_table :parent_table
    end

    it 'adds foreign key with a name that folds in the column' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id

      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table__parent_id')).to be true
    end

    it 'adds foreign key without explicit column using the AR-derived default column', :aggregate_failures do
      connection.add_foreign_key :child_table, :parent_table

      fk = connection.foreign_keys(:child_table).first
      expect(fk.column).to eq('parent_table_id')
      expect(connection.foreign_key_exists?(:child_table,
                                            name: 'fk_child_table__parent_table__parent_table_id')).to be true
    end

    it 'honors an explicit name and does not overwrite it' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id, name: 'custom_fk_name'

      expect(connection.foreign_key_exists?(:child_table, name: 'custom_fk_name')).to be true
    end

    it 'removes foreign key with default name' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id
      connection.remove_foreign_key :child_table, column: :parent_id

      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table__parent_id')).to be false
    end

    it 'removes a foreign key that was added without an explicit column' do
      connection.add_foreign_key :child_table, :parent_table
      connection.remove_foreign_key :child_table, :parent_table

      expect(connection.foreign_keys(:child_table)).to be_empty
    end

    it 'generates distinct names for multiple foreign keys between the same table pair', :aggregate_failures do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id
      connection.add_foreign_key :child_table, :parent_table, column: :parent_table_id

      expect(connection.foreign_keys(:child_table).size).to eq(2)
      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table__parent_id')).to be true
      expect(connection.foreign_key_exists?(:child_table,
                                            name: 'fk_child_table__parent_table__parent_table_id')).to be true
    end
  end

  # Composite foreign keys are an ActiveRecord 7.1+ feature; AR delegates column
  # resolution here, so this only applies where AR itself supports it.
  context 'with a composite primary key parent',
          if: ActiveRecord.version >= Gem::Version.new('7.1') do
    let(:connection) { ActiveRecord::Base.connection }

    before do
      ARTest.connect

      connection.create_table :orgs, primary_key: %i[region id] do |t|
        t.integer :region, null: false
        t.integer :id, null: false
      end

      connection.create_table :seats do |t|
        t.integer :org_region
        t.integer :org_id
      end
    end

    after do
      connection.drop_table :seats
      connection.drop_table :orgs
    end

    it 'folds composite columns into the name while delegating resolution to AR', :aggregate_failures do
      connection.add_foreign_key :seats, :orgs,
                                 column: %i[org_region org_id],
                                 primary_key: %i[region id]

      fk = connection.foreign_keys(:seats).first
      expect(fk.name).to eq('fk_seats__orgs__org_region_and_org_id')
      expect(fk.column).to eq(%w[org_region org_id])
      expect(fk.primary_key).to eq(%w[region id])
    end
  end

  context 'when the folded name exceeds the adapter identifier limit' do
    let(:connection) { ActiveRecord::Base.connection }
    let(:limit) { connection.max_identifier_length }

    before { ARTest.connect }

    it 'keeps the table pair readable and hashes the column when only the column overflows', :aggregate_failures do
      long_column = 'referencing_column_with_a_deliberately_very_long_name_id'
      connection.create_table(:parent_table, id: false) { |t| t.primary_key :id, :integer }
      connection.create_table :child_table, id: false do |t|
        t.primary_key :id, :integer
        t.integer long_column
      end
      connection.add_foreign_key :child_table, :parent_table, column: long_column

      name = connection.foreign_keys(:child_table).first.name
      expect(name.length).to be <= limit
      expect(name).to match(/\Afk_child_table__parent_table__[0-9a-f]{10}\z/)
    ensure
      connection.drop_table :child_table, if_exists: true
      connection.drop_table :parent_table, if_exists: true
    end

    it 'uses a fully hashed name when even the table pair overflows the limit', :aggregate_failures do
      parent = "parent_#{'x' * 40}"
      child = "child_#{'x' * 40}"
      connection.create_table(parent, id: false) { |t| t.primary_key :id, :integer }
      connection.create_table child, id: false do |t|
        t.primary_key :id, :integer
        t.integer :ref_id
      end
      connection.add_foreign_key child, parent, column: :ref_id

      name = connection.foreign_keys(child).first.name
      expect(name.length).to be <= limit
      expect(name).to match(/\Afk_friendly_[0-9a-f]{10}\z/)
    ensure
      connection.drop_table child, if_exists: true
      connection.drop_table parent, if_exists: true
    end
  end
end
