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

    it 'adds foreign key without explicit column using the AR-derived default column', :aggregate_failures do
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

    it 'removes a foreign key that was added without an explicit column' do
      connection.add_foreign_key :child_table, :parent_table
      connection.remove_foreign_key :child_table, :parent_table

      expect(connection.foreign_keys(:child_table)).to be_empty
    end

    it 'raises when a second default-named foreign key collides on the same table pair' do
      connection.add_foreign_key :child_table, :parent_table, column: :parent_id

      expect do
        connection.add_foreign_key :child_table, :parent_table, column: :parent_table_id
      end.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  context 'with a composite primary key parent' do
    let(:connection) { ActiveRecord::Base.connection }

    before do
      ARTest.connect

      connection.create_table :tenant_parent, primary_key: %i[tenant_id id] do |t|
        t.integer :tenant_id, null: false
        t.integer :id, null: false
      end

      connection.create_table :tenant_child do |t|
        t.integer :tenant_parent_tenant_id
        t.integer :tenant_parent_id
      end
    end

    after do
      connection.drop_table :tenant_child
      connection.drop_table :tenant_parent
    end

    it 'applies the friendly name while delegating composite column resolution to AR', :aggregate_failures do
      connection.add_foreign_key :tenant_child, :tenant_parent,
                                 column: %i[tenant_parent_tenant_id tenant_parent_id],
                                 primary_key: %i[tenant_id id]

      fk = connection.foreign_keys(:tenant_child).first
      expect(fk.name).to eq('fk_tenant_child__tenant_parent')
      expect(fk.column).to eq(%w[tenant_parent_tenant_id tenant_parent_id])
      expect(fk.primary_key).to eq(%w[tenant_id id])
    end
  end
end
