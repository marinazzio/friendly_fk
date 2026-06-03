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

    it 'adds foreign key with default name' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id

      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table')).to be true
    end

    it 'adds foreign key without explicit column using the AR-derived default column' do
      connection.add_foreign_key :child_table, :parent_table

      fk = connection.foreign_keys(:child_table).first
      expect(fk.column).to eq('parent_table_id')
      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table')).to be true
    end

    it 'honors an explicit name and does not overwrite it' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id, name: 'custom_fk_name'

      expect(connection.foreign_key_exists?(:child_table, name: 'custom_fk_name')).to be true
    end

    it 'removes foreign key with default name' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id
      connection.remove_foreign_key :child_table, column: :parent_id

      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table')).to be false
    end
  end
end
