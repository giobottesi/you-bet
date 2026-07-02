class CreateSimulations < ActiveRecord::Migration[8.1]
  def change
    create_table :simulations do |t|
      t.string :visitor_id, null: false, index: true

      t.timestamps
    end
  end
end
