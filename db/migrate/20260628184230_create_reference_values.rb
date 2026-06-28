class CreateReferenceValues < ActiveRecord::Migration[8.1]
  def change
    create_table :reference_values do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :value, null: false
      t.string :value_type, null: false, default: "string"
      t.string :category, null: false, index: true
      t.string :description
      t.string :data_source

      t.timestamps
    end
  end
end
