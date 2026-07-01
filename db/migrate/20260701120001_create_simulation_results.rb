class CreateSimulationResults < ActiveRecord::Migration[8.1]
  def change
    create_table :simulation_results do |t|
      t.string :inputs_signature, null: false, index: { unique: true }
      t.jsonb :results, null: false, default: {}

      t.timestamps
    end
  end
end
