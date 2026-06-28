class CreateAppConfigs < ActiveRecord::Migration[8.1]
  def change
    create_table :app_configs do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :value, null: false
      t.string :value_type, null: false, default: "string"
      t.string :description
      t.string :data_source

      t.timestamps
    end
  end
end
