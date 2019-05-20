class CreatePhoneToMaestroCampaign < ActiveRecord::Migration[5.2]
  def change
    create_table(:maestro_phone_campaigns, id: false, :primary_key => :phone) do |t|
      t.bigint :phone
      t.references :maestro_campaign, foreign_key: true

      t.timestamps
    end
    add_index :maestro_phone_campaigns, :phone, unique: true
  end
end
