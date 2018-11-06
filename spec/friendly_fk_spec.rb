require 'spec_helper'
require 'support/connection_helper'

RSpec.describe FriendlyFk do
  it 'has a version number' do
    expect(FriendlyFk::VERSION).not_to be nil
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
      end
    end

    after do
      connection.drop_table :child_table
      connection.drop_table :parent_table
    end

    it 'adds foreign key with default name' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id

      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table')).to be_truthy
    end

    it 'removes foreign key with default name' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id
      connection.remove_foreign_key :child_table, column: :parent_id

      expect(connection.foreign_key_exists?(:child_table, name: 'fk_child_table__parent_table')).to be_falsy
    end
  end
end
