class AddInputsToSimulations < ActiveRecord::Migration[8.0]
  def change
    # Public permalink identifier — non-sequential so share links don't leak volume or invite scraping.
    add_column :simulations, :uuid, :uuid, default: -> { "gen_random_uuid()" }, null: false
    add_index :simulations, :uuid, unique: true

    # Option-1 linkage: the Simulation stores the user's inputs; results stay a shared read-through cache.
    add_column :simulations, :bet_type_keys, :string, array: true, default: [], null: false
    add_column :simulations, :weekly_amount_cents, :integer
    add_column :simulations, :timeframe_weeks, :integer
  end
end
