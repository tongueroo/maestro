class CreateMaestroBuyers < ActiveRecord::Migration[5.2]
  def change
    create_table :maestro_buyers do |t|
      t.string :name
      t.bigint :phone
      t.string :transfer_type
      t.string :web_hook
      t.string :web_hook_trigger_type
      t.integer :call_cap_concurrent
      t.integer :call_cap_daily
      t.integer :call_cap_hourly
      t.integer :call_cap_monthly
      t.bigint :call_cap_lifetime
      t.boolean :active

      t.timestamps
    end
  end
end
