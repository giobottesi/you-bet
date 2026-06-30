class AddBetTypeToReferenceValues < ActiveRecord::Migration[8.1]
  def change
    add_column :reference_values, :bet_type, :string

    remove_index :reference_values, :key, unique: true
    add_index :reference_values, :key, unique: true,
              where: 'bet_type IS NULL', name: 'idx_reference_values_unique_key'
    add_index :reference_values, %i[bet_type key], unique: true,
              where: 'bet_type IS NOT NULL', name: 'idx_reference_values_unique_bet_type_key'
  end
end
