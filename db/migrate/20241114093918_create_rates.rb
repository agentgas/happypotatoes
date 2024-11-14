class CreateRates < ActiveRecord::Migration[7.1]
  def up
    create_table :rates do |t|
      t.float :value
      t.datetime :time
      t.index ["value"], name: "index_rates_on_value"

      t.timestamps
    end
  end

  def down
    drop_table :rates
  end
end
