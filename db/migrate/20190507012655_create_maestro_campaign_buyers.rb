class CreateMaestroCampaignBuyers < ActiveRecord::Migration[5.2]
  def change
    create_table :maestro_campaign_buyers do |t|
      t.references :maestro_campaign, foreign_key: true
      t.references :maestro_buyer, foreign_key: true
      t.integer :priority, limit: 2
      t.integer :weight, limit: 2
      t.string :web_hook
      t.string :web_hook_trigger_type

      t.timestamps
    end
  end
end
